{
  pkgs,
  inputs,
  ...
}:
{
  programs.zed-editor = {
    enable = true;
    package = inputs.zed.packages.${pkgs.stdenv.hostPlatform.system}.default;
    extensions = [
      "nix"
      "toml"
      "rust"
    ];
    extraPackages = with pkgs; [
      bash-language-server
      cargo
      package-version-server
      ruff
      rust-analyzer
      rustc

      nil
      nixd
      # json-language-server
    ];
    userSettings = {
      theme = {
        mode = "dark";
        dark = "One Dark";
        light = "One Light";
      };
      hour_format = "hour24";
      vim_mode = true;
      load_direnv = "shell_hook";
      base_keymap = "Emacs";
      show_whitespaces = "trailing";
      ui_font_size = 16;
      buffer_font_size = 14;
      lsp = {
        nil = {
          binary = {
            path_lookup = true;
          };
          settings = {
            formatting = {
              command = [ "nixfmt" ];
            };
            diagnostics = {
              ignored = [
                "unused_binding"
              ];
            };
          };
        };
      };
      terminal = {
        alternate_scroll = "off";
        blinking = "off";
        copy_on_select = false;
        dock = "bottom";
        detect_venv = {
          on = {
            directories = [
              ".env"
              "env"
              ".venv"
              "venv"
            ];
            activate_script = "default";
          };
        };
        env = {
          TERM = "kitty";
        };
        working_directory = "current_project_directory";
      };
    };
  };
}
