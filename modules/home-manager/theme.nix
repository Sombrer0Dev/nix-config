{ pkgs, config, ... }:
let
  theme = {
    name = "Adwaita-dark";
    package = pkgs.gnome-themes-extra;
  };
  font = {
    name = "Ubuntu Nerd Font";
    size = 11;
  };
  cursorTheme = {
    name = "Qogir";
    size = 24;
    package = pkgs.qogir-icon-theme;
  };
  iconTheme = {
    name = "MoreWaita";
    package = pkgs.morewaita-icon-theme;
  };
in
{
  home = {
    packages = with pkgs; [
      material-symbols
      cantarell-fonts
      font-awesome
      theme.package
      cursorTheme.package
      iconTheme.package
      adwaita-icon-theme
      adwaita-icon-theme-legacy
      papirus-icon-theme
      victor-mono
      nerd-fonts.symbols-only
      nerd-fonts.ubuntu
      nerd-fonts.ubuntu-mono
      nerd-fonts.caskaydia-mono
      nerd-fonts.fantasque-sans-mono
      nerd-fonts.fira-code
      nerd-fonts.mononoki
      nerd-fonts.monaspace
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
    ];
    sessionVariables = {
      XCURSOR_THEME = cursorTheme.name;
      XCURSOR_SIZE = "${toString cursorTheme.size}";
    };
    pointerCursor = cursorTheme // {
      gtk.enable = true;
    };
    file = {
      ".config/gtk-4.0/gtk.css".text = ''
        window.messagedialog .response-area > button,
        window.dialog.message .dialog-action-area > button,
        .background.csd{
          border-radius: 0;
        }
      '';
    };
  };
  fonts.fontconfig.enable = true;

  services.mako = {
    enable = true;
    settings.default-timeout = 4000;
  };
  gtk = {
    inherit font cursorTheme iconTheme;
    theme.name = theme.name;
    # theme.package = theme.package;
    enable = true;
    # gtk3.extraCss = ''
    #   headerbar, .titlebar,
    #   .csd:not(.popup):not(tooltip):not(messagedialog) decoration{
    #     border-radius: 0;
    #   }
    # '';
  };

  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style.name = "adwaita-dark";
  };

  home.file.".local/share/flatpak/overrides/global".text =
    let
      dirs = [
        "/nix/store:ro"
        "xdg-config/gtk-3.0:ro"
        "xdg-config/gtk-4.0:ro"
        "${config.xdg.dataHome}/icons:ro"
      ];
    in
    ''
      [Context]
      filesystems=${builtins.concatStringsSep ";" dirs}
    '';
}
