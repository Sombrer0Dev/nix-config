#!/usr/bin/env node
/**
 * Claude Code Enhanced Statusline Script v0.9.0
 *
 * Features:
 * - Dynamic context window (200k/1M) based on model detection
 * - Support for Claude 4.5/4.6 (Opus, Sonnet, Haiku) + GLM models
 * - Real-time token tracking from current session
 * - Git branch with staged/unstaged changes
 * - Model version display
 * - Enhanced progress bar
 * - Live 5-hour rate-limit block status (tokens used + time left) and
 *   trailing 7-day usage, aggregated across all projects
 */

import { execSync } from 'child_process';
import { readFileSync, existsSync, readdirSync, statSync } from 'fs';
import { join } from 'path';

// Model context window sizes
const MODEL_CONTEXT_SIZES = {
  "claude-opus-4-6": 1000000,
  "claude-opus-4-5": 200000,
  "claude-sonnet-4-6": 200000,
  "claude-sonnet-4-5": 200000,
  "claude-haiku-4-5": 200000,
  "glm-5": 200000,
  "glm-5-plus": 200000,
  "glm-4": 200000,
  "glm-4-plus": 200000,
  "glm-4-long": 1000000,
  "glm-4.7": 200000,
};

function getContextSizeForModel(modelId) {
  if (!modelId) return 200000;
  if (modelId.includes('[1m]')) return 1000000;
  if (MODEL_CONTEXT_SIZES[modelId] !== undefined) return MODEL_CONTEXT_SIZES[modelId];
  for (const [key, size] of Object.entries(MODEL_CONTEXT_SIZES)) {
    if (modelId.startsWith(key)) return size;
  }
  if (modelId.includes('opus-4-6') || modelId.includes('opus-4.6')) return 1000000;
  if (modelId.includes('opus-4-5') || modelId.includes('opus-4.5')) return 200000;
  if (modelId.includes('sonnet')) return 200000;
  if (modelId.includes('haiku')) return 200000;
  if (modelId.includes('glm-4-long')) return 1000000;
  if (modelId.includes('glm')) return 200000;
  return 200000;
}

// Configuration
const CONFIG = {
  maxTokens: 200000, // default, overridden dynamically per model
  progressBarWidth: 15,
  showModel: true,
  colors: {
    low: 'green',
    medium: 'yellow',
    high: 'red'
  }
};

const FIVE_HOUR_MS = 5 * 60 * 60 * 1000;
const WEEK_MS = 7 * 24 * 60 * 60 * 1000;

// ANSI Color codes
const COLORS = {
  reset: '\x1b[0m',
  bold: '\x1b[1m',
  red: '\x1b[91m',
  green: '\x1b[92m',
  yellow: '\x1b[93m',
  blue: '\x1b[94m',
  magenta: '\x1b[95m',
  cyan: '\x1b[96m',
  white: '\x1b[97m',
  gray: '\x1b[90m',
  orange: '\x1b[38;5;208m',
  peach: '\x1b[38;5;213m'
};

/**
 * Get current session ID and file
 */
function getCurrentSessionFile() {
  const homeDir = process.env.HOME || process.env.USERPROFILE;
  const projectsDir = join(homeDir, '.claude', 'projects');

  try {
    // Get current project path hash (match Claude's format)
    // C:\Users\Yanis\Projects\-plugins\statusline -> C--Users-Yanis-Projects--plugins-statusline
    const cwd = process.cwd();
    const projectHash = cwd
      .replace(/:/g, '-')      // Replace colon with dash (C: -> C-)
      .replace(/[\/\\]/g, '-'); // Replace all slashes with dashes

    // List session files for this project
    const projectDir = join(projectsDir, projectHash);
    if (!existsSync(projectDir)) {
      return null;
    }

    const files = readdirSync(projectDir)
      .filter(f => f.endsWith('.jsonl'))
      .map(f => ({
        path: join(projectDir, f),
        mtime: statSync(join(projectDir, f)).mtime.getTime()
      }))
      .sort((a, b) => b.mtime - a.mtime);  // Sort by modification time, newest first

    // Return most recent file
    return files.length > 0 ? files[0].path : null;
  } catch (error) {
    return null;
  }
}

function getSessionTokens() {
  const sessionFile = getCurrentSessionFile();

  if (!sessionFile || !existsSync(sessionFile)) {
    return { current: 0, max: CONFIG.maxTokens, model: 'Claude' };
  }

  try {
    // Read last line of session file
    const content = readFileSync(sessionFile, 'utf-8');
    const lines = content.trim().split('\n');

    // Find the last line with usage data
    let lastData = null;
    for (let i = lines.length - 1; i >= 0; i--) {
      try {
        const parsed = JSON.parse(lines[i]);
        if (parsed.isSidechain === true || parsed.isApiErrorMessage === true) continue;
        if (parsed.message?.usage) {
          lastData = parsed;
          break;
        }
      } catch {
        continue;
      }
    }

    if (!lastData || !lastData.message?.usage) {
      return { current: 0, max: CONFIG.maxTokens, model: 'Claude' };
    }

    const usage = lastData.message.usage;

    // Calculate total tokens
    const inputTokens = usage.input_tokens || 0;
    const cacheReadTokens = usage.cache_read_input_tokens || 0;
    const cacheCreationTokens = usage.cache_creation_input_tokens || 0;
    const totalTokens = inputTokens + cacheReadTokens + cacheCreationTokens;

    // Extract model name
    const model = lastData.message.model || 'Claude';

    // Dynamic max tokens based on detected model
    const maxTokens = getContextSizeForModel(model);

    return {
      current: totalTokens,
      max: maxTokens,
      model: model
    };
  } catch (error) {
    return { current: 0, max: CONFIG.maxTokens, model: 'Claude' };
  }
}

/**
 * Collect {timestamp, tokens} for every usage-bearing message across ALL
 * projects — Anthropic's 5-hour and weekly rate-limit windows are
 * account-wide, not per-project or per-session. Session files whose mtime
 * is older than the weekly window are skipped without being read, so this
 * stays cheap regardless of how much history has piled up.
 */
function getRecentUsageEvents() {
  const homeDir = process.env.HOME || process.env.USERPROFILE;
  const projectsDir = join(homeDir, '.claude', 'projects');
  const cutoff = Date.now() - WEEK_MS;
  const events = [];

  let projectDirs;
  try {
    projectDirs = readdirSync(projectsDir, { withFileTypes: true })
      .filter(d => d.isDirectory())
      .map(d => join(projectsDir, d.name));
  } catch {
    return events;
  }

  for (const dir of projectDirs) {
    let files;
    try {
      files = readdirSync(dir).filter(f => f.endsWith('.jsonl'));
    } catch {
      continue;
    }

    for (const file of files) {
      const filePath = join(dir, file);
      let mtime;
      try {
        mtime = statSync(filePath).mtime.getTime();
      } catch {
        continue;
      }
      if (mtime < cutoff) continue;

      let content;
      try {
        content = readFileSync(filePath, 'utf-8');
      } catch {
        continue;
      }

      for (const line of content.split('\n')) {
        if (!line) continue;
        let parsed;
        try {
          parsed = JSON.parse(line);
        } catch {
          continue;
        }
        if (parsed.isSidechain === true || parsed.isApiErrorMessage === true) continue;

        const usage = parsed.message?.usage;
        if (!usage || !parsed.timestamp) continue;

        const timestamp = new Date(parsed.timestamp).getTime();
        if (Number.isNaN(timestamp) || timestamp < cutoff) continue;

        const tokens =
          (usage.input_tokens || 0) +
          (usage.output_tokens || 0) +
          (usage.cache_read_input_tokens || 0) +
          (usage.cache_creation_input_tokens || 0);

        events.push({ timestamp, tokens });
      }
    }
  }

  events.sort((a, b) => a.timestamp - b.timestamp);
  return events;
}

/**
 * The 5-hour rate-limit window is block-based, not a trailing window: it
 * starts at the first message after a >5h idle gap and runs 5h from there.
 * Walk backward from the most recent event to find that start.
 */
function getActiveFiveHourBlock(events) {
  if (events.length === 0) return null;

  let startIdx = events.length - 1;
  for (let i = events.length - 1; i > 0; i--) {
    if (events[i].timestamp - events[i - 1].timestamp > FIVE_HOUR_MS) break;
    startIdx = i - 1;
  }

  const blockStart = events[startIdx].timestamp;
  const blockEnd = blockStart + FIVE_HOUR_MS;
  const now = Date.now();
  if (now >= blockEnd) return null;

  const tokens = events
    .slice(startIdx)
    .reduce((sum, e) => sum + e.tokens, 0);

  return { tokens, remainingMs: blockEnd - now };
}

/**
 * Plain trailing 7-day token total. Unlike the 5h window, Anthropic's weekly
 * reset boundary isn't derivable locally, so this reports cumulative usage
 * rather than claiming to know a reset time.
 */
function getWeekUsage(events) {
  const tokens = events.reduce((sum, e) => sum + e.tokens, 0);
  return { tokens };
}

/**
 * Get git information for current directory
 */
function getGitInfo() {
  const nullDevice = process.platform === 'win32' ? 'nul' : '/dev/null';
  try {
    const branch = execSync(`git rev-parse --abbrev-ref HEAD 2>${nullDevice} || echo ""`, {
      cwd: process.cwd(),
      encoding: 'utf-8',
      shell: true,
      windowsHide: true
    }).trim();

    const root = execSync(`git rev-parse --show-toplevel 2>${nullDevice} || echo .`, {
      cwd: process.cwd(),
      encoding: 'utf-8',
      shell: true,
      windowsHide: true
    }).trim();

    const relative = execSync(`git rev-parse --show-prefix 2>${nullDevice} || echo .`, {
      cwd: process.cwd(),
      encoding: 'utf-8',
      shell: true,
      windowsHide: true
    }).trim().replace(/\\$/, '').replace(/\/$/, '') || '.';

    // Check dirty state and get detailed status
    const status = execSync(`git status --porcelain 2>${nullDevice}`, {
      cwd: process.cwd(),
      encoding: 'utf-8',
      shell: true,
      windowsHide: true
    }).trim();

    const dirty = status.length > 0;

    // Count staged and unstaged files
    const stagedFiles = status.split('\n').filter(line =>
      line && (line.startsWith('M') || line.startsWith('A') || line.startsWith('D') || line.startsWith('R'))
    ).length;

    const unstagedFiles = status.split('\n').filter(line =>
      line && (line[1] === 'M' || line[1] === 'D' || line.startsWith('??'))
    ).length;

    // Get staged changes
    let stagedInsertions = 0;
    let stagedDeletions = 0;
    try {
      const stagedStat = execSync(`git diff --staged --shortstat 2>${nullDevice}`, {
        cwd: process.cwd(),
        encoding: 'utf-8',
        shell: true,
        windowsHide: true
      }).trim();

      const stagedInsertMatch = stagedStat.match(/(\d+) insertion/);
      const stagedDeleteMatch = stagedStat.match(/(\d+) deletion/);

      if (stagedInsertMatch) stagedInsertions = parseInt(stagedInsertMatch[1], 10);
      if (stagedDeleteMatch) stagedDeletions = parseInt(stagedDeleteMatch[1], 10);
    } catch {
      // Ignore staged diff errors
    }

    // Get unstaged changes
    let unstagedInsertions = 0;
    let unstagedDeletions = 0;
    try {
      const unstagedStat = execSync(`git diff --shortstat 2>${nullDevice}`, {
        cwd: process.cwd(),
        encoding: 'utf-8',
        shell: true,
        windowsHide: true
      }).trim();

      const unstagedInsertMatch = unstagedStat.match(/(\d+) insertion/);
      const unstagedDeleteMatch = unstagedStat.match(/(\d+) deletion/);

      if (unstagedInsertMatch) unstagedInsertions = parseInt(unstagedInsertMatch[1], 10);
      if (unstagedDeleteMatch) unstagedDeletions = parseInt(unstagedDeleteMatch[1], 10);
    } catch {
      // Ignore unstaged diff errors
    }

    return {
      branch,
      root,
      relative,
      dirty,
      stagedFiles,
      unstagedFiles,
      stagedInsertions,
      stagedDeletions,
      unstagedInsertions,
      unstagedDeletions
    };
  } catch {
    return {
      branch: '',
      root: '.',
      relative: '.',
      dirty: false,
      stagedFiles: 0,
      unstagedFiles: 0,
      stagedInsertions: 0,
      stagedDeletions: 0,
      unstagedInsertions: 0,
      unstagedDeletions: 0
    };
  }
}

/**
 * Format token count for display
 */
function formatTokenCount(count) {
  if (count >= 1000000) {
    return `${(count / 1000000).toFixed(1)}M`;
  }
  if (count >= 1000) {
    return `${(count / 1000).toFixed(0)}K`;
  }
  return count.toString();
}

/**
 * Format duration in ms to human readable
 */
function formatDuration(ms) {
  const minutes = Math.floor(ms / 60000);
  const hours = Math.floor(minutes / 60);
  const mins = minutes % 60;

  if (hours > 0) {
    return mins > 0 ? `${hours}h${mins}m` : `${hours}h`;
  }
  return `${mins}m`;
}

/**
 * Get a readable display name for the model, e.g. "Sonnet 4.5" from
 * "claude-sonnet-4-5" or "claude-sonnet-5", "GLM 4.7" from "glm-4.7".
 * Real Claude model IDs use hyphens between version segments, not dots,
 * so a naive \d+\.\d+ regex (the previous approach) never matched them.
 */
function getModelDisplayName(modelId) {
  if (!modelId) return '';

  // Version is 1-2 short hyphen-separated numeric segments right after the
  // family name; some IDs (e.g. Haiku's) append an 8-digit release date
  // after that, which this deliberately stops short of.
  const claudeMatch = modelId.match(/claude-(opus|sonnet|haiku|fable)-(\d{1,2}(?:-\d{1,2})?)/i);
  if (claudeMatch) {
    const family = claudeMatch[1][0].toUpperCase() + claudeMatch[1].slice(1).toLowerCase();
    const version = claudeMatch[2].replace(/-/g, '.');
    return `${family} ${version}`;
  }

  const glmMatch = modelId.match(/glm-(.+)/i);
  if (glmMatch) return `GLM ${glmMatch[1]}`;

  return modelId;
}

/**
 * Create a progress bar with enhanced colors
 */
function createProgressBar(percentage, width = CONFIG.progressBarWidth) {
  const filled = Math.round((percentage / 100) * width);
  const empty = width - filled;

  // Use better characters for progress bar
  const bar = '━'.repeat(filled) + (empty > 0 ? '╸' : '') + '─'.repeat(Math.max(0, empty - 1));

  // Enhanced colors with better gradients
  let colorCode = '\x1b[92m';  // green
  if (percentage >= 90) colorCode = '\x1b[91m';  // red
  else if (percentage >= 70) colorCode = '\x1b[38;5;208m';  // orange
  else if (percentage >= 40) colorCode = '\x1b[93m';  // yellow

  return `\x1b[1m${colorCode}[${bar}]\x1b[0m`;
}

/**
 * Format git changes for display - enhanced v0.6.0
 */
function formatGitChanges(gitInfo) {
  const parts = [];

  // Staged changes (cyan)
  if (gitInfo.stagedInsertions > 0 || gitInfo.stagedDeletions > 0 || gitInfo.stagedFiles > 0) {
    const stagedParts = [];
    if (gitInfo.stagedInsertions > 0) stagedParts.push(`\x1b[96m+${gitInfo.stagedInsertions}\x1b[0m`);
    if (gitInfo.stagedDeletions > 0) stagedParts.push(`\x1b[96m-${gitInfo.stagedDeletions}\x1b[0m`);
    if (gitInfo.stagedFiles > 0) stagedParts.push(`\x1b[96m[${gitInfo.stagedFiles}]\x1b[0m`);

    if (stagedParts.length > 0) {
      parts.push(stagedParts.join(' '));
    }
  }

  // Unstaged changes (green/red/yellow)
  if (gitInfo.unstagedInsertions > 0 || gitInfo.unstagedDeletions > 0 || gitInfo.unstagedFiles > 0) {
    const unstagedParts = [];
    if (gitInfo.unstagedInsertions > 0) unstagedParts.push(`\x1b[92m+${gitInfo.unstagedInsertions}\x1b[0m`);
    if (gitInfo.unstagedDeletions > 0) unstagedParts.push(`\x1b[91m-${gitInfo.unstagedDeletions}\x1b[0m`);
    if (gitInfo.unstagedFiles > 0) unstagedParts.push(`\x1b[93m[${gitInfo.unstagedFiles}]\x1b[0m`);

    if (unstagedParts.length > 0) {
      parts.push(unstagedParts.join(' '));
    }
  }

  // Join staged and unstaged with space, no separator between them
  return parts.length > 0 ? ` \x1b[90m▸\x1b[0m ${parts.join(' ')}` : '';
}

/**
 * Format the active 5-hour rate-limit block: tokens used so far this block,
 * plus time left until it resets. `null` means no block is currently open
 * (nothing sent in the last 5h).
 */
function formatFiveHourDisplay(block) {
  if (!block) {
    return `\x1b[1m\x1b[96m5h\x1b[0m \x1b[90m--\x1b[0m`;
  }
  const remaining = formatDuration(block.remainingMs);
  return `\x1b[1m\x1b[96m5h\x1b[0m \x1b[97m${formatTokenCount(block.tokens)}\x1b[0m \x1b[90m(${remaining} left)\x1b[0m`;
}

/**
 * Format trailing 7-day token usage.
 */
function formatWeekDisplay(week) {
  return `\x1b[1m\x1b[95mwk\x1b[0m \x1b[97m${formatTokenCount(week.tokens)}\x1b[0m`;
}

/**
 * Get project name/path for display
 */
function getProjectPath(gitInfo) {
  if (!gitInfo.branch) {
    return process.cwd().split(/[/\\]/).pop() || '.';
  }

  if (gitInfo.relative === '.' || gitInfo.relative === '') {
    return gitInfo.root.split(/[/\\]/).pop() || '.';
  }

  const projectName = gitInfo.root.split(/[/\\]/).pop() || '.';
  return `${projectName}/${gitInfo.relative}`;
}

/**
 * Main function
 */
function main() {
  const gitInfo = getGitInfo();
  const sessionData = getSessionTokens();
  const { current, max, model } = sessionData;
  const percentage = Math.min(100, Math.round((current / max) * 100));

  const usageEvents = getRecentUsageEvents();
  const fiveHourBlock = getActiveFiveHourBlock(usageEvents);
  const weekUsage = getWeekUsage(usageEvents);

  // Build statusline components
  const branch = gitInfo.branch || 'no-git';
  const dirtyMarker = gitInfo.dirty ? `\x1b[95m*\x1b[0m` : '';
  const projectPath = getProjectPath(gitInfo);
  const progressBar = createProgressBar(percentage);
  const currentDisplay = formatTokenCount(current);
  const maxDisplay = formatTokenCount(max);
  const gitChanges = formatGitChanges(gitInfo);

  // Model display name
  const modelDisplayName = getModelDisplayName(model);
  const modelDisplay = modelDisplayName
    ? `\x1b[38;5;213m${modelDisplayName}\x1b[0m`
    : '';

  // Build final statusline on ONE line with better separators
  // Order: Branch ▸ Path ▸ Git changes ▸ Model ▸ Progress ▸ Tokens ▸ 5h ▸ Week
  let statusline =
    `\x1b[1m\x1b[97m${branch}${dirtyMarker}\x1b[0m` +
    ` \x1b[90m▸\x1b[0m ` +
    `\x1b[90m${projectPath}\x1b[0m` +
    gitChanges +
    (modelDisplay ? ` \x1b[90m▸\x1b[0m ${modelDisplay}` : '') +
    ` \x1b[90m▸\x1b[0m ` +
    progressBar +
    ` \x1b[90m▸\x1b[0m ` +
    `\x1b[1m${percentage}% (${currentDisplay}/${maxDisplay})\x1b[0m` +
    ` \x1b[90m▸\x1b[0m ${formatFiveHourDisplay(fiveHourBlock)}` +
    ` \x1b[90m▸\x1b[0m ${formatWeekDisplay(weekUsage)}`;

  // Output to stdout
  console.log(statusline);
}

main();
