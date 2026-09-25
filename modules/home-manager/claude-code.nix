{
  config,
  lib,
  pkgs,
  ...
}:
let
  statuslineCommand = "node ${config.home.homeDirectory}/.claude/statusline.mjs";
in
{
  # Vendored from https://github.com/Pamacea/statusline (statusline-standalone.mjs)
  home.file.".claude/statusline.mjs" = {
    source = ./files/claude-statusline.mjs;
    executable = true;
  };

  # settings.json is otherwise edited imperatively (via `/config` etc.), so
  # only merge in the statusLine key instead of managing the whole file.
  home.activation.claudeStatusline = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    settingsFile="${config.home.homeDirectory}/.claude/settings.json"
    if [ -f "$settingsFile" ]; then
      tmpFile=$(mktemp)
      ${lib.getExe pkgs.jq} \
        --arg command ${lib.escapeShellArg statuslineCommand} \
        '.statusLine = {"type": "command", "command": $command}' \
        "$settingsFile" > "$tmpFile" && mv "$tmpFile" "$settingsFile"
    fi
  '';
}
