# ZiTheme: a custom base24 color scheme, replacing Stylix's Cyberdream

## Context

`nix-config` currently themes ghostty/alacritty/foot/noctalia via Stylix using
the Cyberdream base16 palette (`modules/home-manager/stylix.nix`, see
`docs/superpowers/specs/` history and memory `project_stylix_cyberdream.md`).
After verifying Stylix was applying Cyberdream correctly end-to-end (including
to noctalia, confirmed live via `noctalia msg color-scheme-get`), the user
decided they don't like the look: Cyberdream's near-maximum-saturation hues
read fine as small syntax-highlight accents but become overwhelming when
Stylix's generic base16→role mapping (`mPrimary`, `mSecondary`, ...) puts the
same hues on large UI surfaces (bar capsules, widget backgrounds, borders).

The user named three existing Neovim colorschemes they like the *code*
appearance of: `oxocarbon.nvim`, `onedark.nvim` (navarasu), `kurayami.nvim`.
Pulling their actual palettes confirmed the pattern: Oxocarbon and OneDark use
restrained, "tempered" accent saturation that works at both small (syntax) and
large (UI chrome) scale; Kurayami's syntax accents are genuinely neon and
would likely repeat the Cyberdream problem if used system-wide.

This spec covers designing and packaging a new, from-scratch color scheme
("ZiTheme") as a standalone public repo, to replace Cyberdream as the palette
Stylix consumes. It does **not** cover the nix-config-side integration work
(swapping `stylix.base16Scheme`, the noctalia color override, the Neovim
highlight override, the Firefox target, or the WSL setup) — that is a
follow-up task against this spec's deliverable, scoped separately in the
implementation plan.

## Goals

- A dark, from-scratch base24 color scheme, authored to the
  [tinted-theming base24 spec](https://github.com/tinted-theming/base24)
  (verified against the actual spec document, not inferred), portable to any
  base16/base24-compatible tool.
- Accent saturation tuned to read correctly at *both* small scale (syntax
  highlighting in Neovim) and large scale (UI chrome: bar widgets, window
  borders, icons) — the specific failure mode that killed Cyberdream.
- Red/pink/magenta as the dominant accent family (system UI), with
  blue/green/cyan demoted to minor/status-only roles in UI contexts while
  keeping their conventional semantic roles in code (functions, strings,
  support) so generic base16/24 templates still render correctly.
- Usable from both Nix (as a flake input) and from a plain, non-Nix shell
  environment (the user's Ubuntu WSL work machine — see memory
  `project_shell_scripts_vf_vg.md`, which documents that machine as
  deliberately non-Nix).

## Non-goals

- A light-mode variant. Dark only for v1, matching the current
  `stylix.polarity = "dark"` setup in `nix-config`.
- Doing the actual `nix-config` integration (Stylix, noctalia override,
  Neovim highlights, Firefox, WSL). Covered by a separate follow-up plan once
  this repo exists and is tagged.
- Porting to Zen Browser. Already identified (memory
  `project_stylix_cyberdream.md`) as a separate, bigger restructuring (Zen is
  currently a bare package, not the `programs.zen-browser` HM module) and is
  explicitly out of scope here.
- Submitting ZiTheme to the upstream `tinted-theming/schemes` gallery. Can
  happen later if desired; not required for personal use.

## Design decisions

These were reached interactively (including a visual side-by-side comparison
tool) and are considered final for v1:

1. **Base tone**: warm near-black, `base00 = #1c1c1c`, `base05 = #d0d0d0`
   fg — closest in mood to Kurayami's background, chosen over a true-neutral
   near-black (Oxocarbon-style) and a blue-gray (OneDark-style).
2. **Accent intensity**: "atom-muted" tier — OneDark-level saturation, chosen
   over a more vivid "Carbon-tempered" tier and a "signature-neon-restrained"
   tier that kept a dialed-down Kurayami neon hue.
3. **Hue dominance**: red/pink/magenta lead (base08, base0E), blue/green/cyan
   demoted to minor and status-only roles *in UI contexts*. In code, standard
   base16/24 semantic roles are kept (base0D blue = functions per spec
   convention, base0B green = strings) so the scheme stays compatible with
   third-party templates that assume those conventions.
4. **Neovim function styling** (a deliberate, scheme-external override, not
   part of the base24 file itself): function names rendered in `base08`
   (red) + italic, instead of the spec-conventional `base0D` (blue). Errors
   stay `base08` + undercurl, so the two don't read as the same thing despite
   sharing a hue. This reuses the signature accent color for the
   highest-attention code identifier (functions) instead of introducing a new
   hue. Because this deviates from the spec convention, it ships as a
   separate highlight-override template, not baked into the scheme file —
   generic base16/24 Neovim templates built from `zitheme.yaml` directly will
   still show blue functions (spec-correct); only `nix-config`'s own Neovim
   setup applies the override on top.

### Final palette

`system: base24`, `name: ZiTheme`, `slug: zitheme`, `author: Artem Sokolov`,
`variant: dark`.

| slot | hex | spec role | notes |
|---|---|---|---|
| base00 | `#1c1c1c` | default background | |
| base01 | `#262626` | lighter bg (status lines) | |
| base02 | `#303030` | selection background | |
| base03 | `#6b6b6b` | comments, invisibles | |
| base04 | `#949494` | dark fg (status bars) | |
| base05 | `#d0d0d0` | default foreground | |
| base06 | `#e6e6e6` | light fg (rarely used) | |
| base07 | `#f2f2f2` | lightest fg (rarely used) | |
| base08 | `#e06c75` | red: variables, errors | **signature color**; also functions+italic via override |
| base09 | `#d19a66` | orange: integers/booleans/constants | |
| base0A | `#e5c07b` | yellow: classes, search bg | |
| base0B | `#98c379` | green: strings | minor/status-only outside code |
| base0C | `#56b6c2` | cyan: support, regex, escapes | minor outside code |
| base0D | `#61afef` | blue: functions, methods | minor outside code; standard in generic templates |
| base0E | `#d47d94` | magenta: keywords, storage | **secondary signature** (dusty rose) |
| base0F | `#be5046` | dark red/brown: deprecated | |
| base10 | `#141414` | darker background | base24-only |
| base11 | `#0d0d0d` | darkest background | base24-only |
| base12 | `#ff7b86` | bright red | base24-only |
| base13 | `#efb074` | bright yellow | base24-only |
| base14 | `#b1e18b` | bright green | base24-only |
| base15 | `#63d4e0` | bright cyan | base24-only |
| base16 | `#67cdff` | bright blue | base24-only |
| base17 | `#f29bb5` | bright magenta | base24-only |

All values verified against the tinted-theming base24 styling guide's role
table (fetched and read during design, not assumed from memory).

## Repo structure (`github.com/Sombrer0Dev/ZiTheme`, public)

```
ZiTheme/
├── zitheme.yaml          # canonical scheme file, common scheme format
│                         #   (system/name/slug/author/variant/palette keys)
├── flake.nix             # thin wrapper: parses zitheme.yaml, exposes
│                         #   lib.scheme (full attrset incl. metadata) and
│                         #   lib.base16Scheme (palette-only attrset shaped
│                         #   for stylix.base16Scheme's expected input)
├── templates/
│   └── nvim-functions.lua   # function=base08+italic / error=base08+undercurl
│                            #   override, meant to layer on top of whatever
│                            #   base16/24-driven colorscheme is active
├── README.md             # swatches, the small-area-vs-large-area design
│                         #   rationale, usage for Nix (flake input) and
│                         #   non-Nix (base16-shell) consumers
└── LICENSE                # MIT, matching the scheme's open, shareable intent
```

`zitheme.yaml` is the single source of truth. `flake.nix` does not duplicate
the palette as a second hand-maintained copy — it reads and parses the YAML
at eval time.

## Follow-up integration (tracked here for scope clarity; separate plan)

Once ZiTheme is published and tagged, a second piece of work (not part of
this spec's implementation) applies it in `nix-config`:

- `stylix.nix`: replace the inline Cyberdream `base16Scheme` attrset with
  `inputs.zitheme.lib.base16Scheme`.
- noctalia (and any other large-surface Stylix target): use the target's
  `colors.override` option (confirmed to exist via `mk-target.nix`'s
  `cfg.${argument}.override` mechanism) to promote `base0E`/`base08` over the
  default `base0D`-as-primary convention, instead of baking a non-standard
  role into the scheme itself.
- Neovim: apply `templates/nvim-functions.lua`'s highlight overrides on top
  of Stylix's generated base16 colorscheme.
- Firefox: `stylix.targets.firefox.profileNames = [ "default" ];` —
  straightforward, since `programs.firefox.profiles.default` already exists
  in `browser.nix` (confirmed by reading the file; unlike Zen Browser, which
  needs its own restructuring per `project_stylix_cyberdream.md`).
- WSL work machine: `base16-shell` pointed at `zitheme.yaml`'s raw GitHub
  URL, invoked from shell rc, consistent with that machine's existing
  deliberately-non-Nix setup (`project_shell_scripts_vf_vg.md`).

## Testing / validation

- `nix flake check` on the ZiTheme repo itself (validates `flake.nix` parses
  and evaluates `zitheme.yaml` without error).
- A manual render check: build at least one well-known base16/24 template
  (e.g. a terminal template) against `zitheme.yaml` using a standard builder,
  to confirm the YAML is spec-valid common-scheme-format, not just
  Nix-parseable.
- Visual confirmation deferred to the follow-up integration plan, where it
  can be checked against the real running system (same method used to verify
  Cyberdream's noctalia integration: `noctalia msg color-scheme-get` plus a
  visual look).
