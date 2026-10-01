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
      noctalia.enable = true;
    };
  };
}
