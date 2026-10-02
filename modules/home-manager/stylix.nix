{ inputs, ... }:
{
  stylix = {
    enable = true;
    polarity = "dark";

    # Only theme what we've asked it to; everything else (GTK, QT, cursor,
    # icons, GNOME dconf, ...) is already owned by theme.nix/dconf.nix.
    autoEnable = false;

    # https://github.com/Sombrer0Dev/ZiTheme — zitheme.yaml there is the
    # single source of truth; this just reads it via the flake input.
    base16Scheme = inputs.zitheme.lib.base16Scheme;

    targets = {
      ghostty.enable = true;
      alacritty.enable = true;
      foot.enable = true;
      # No-ops harmlessly on hosts without `programs.noctalia` (laptop).
      noctalia = {
        enable = true;
        # ZiTheme's base0D/base0C/base0E (blue/cyan/mauve-pink) leak into the
        # bar as mPrimary/mTertiary-mHover/mSecondary. Pin just this target's
        # copy of those three slots to ZiTheme's own red family
        # (base08/base0F/base12) so the bar is red, not blue/cyan/pink --
        # without touching those slots anywhere else (terminal ANSI colors).
        colors.override = {
          base0D = "ff7b86"; # was 61afef (blue) -> bright red (base12)
          base0C = "e06c75"; # was 56b6c2 (cyan) -> red (base08)
          base0E = "be5046"; # was d47d94 (mauve-pink) -> dark rust red (base0F)
          withHashtag = {
            base0D = "#ff7b86";
            base0C = "#e06c75";
            base0E = "#be5046";
          };
        };
      };
    };
  };
}
