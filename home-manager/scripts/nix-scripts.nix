{ pkgs, ... }:
let
  symlink = pkgs.writeShellScript "symlink" ''
    if [[ "$1" == "-r" ]]; then
      rm -rf "$HOME/.config/nvim"
      rm -rf "$HOME/.config/ags"
    fi

    if [[ "$1" == "-a" ]]; then
      rm -rf "$HOME/.config/nvim"
      rm -rf "$HOME/.config/ags"

      ln -s "$HOME/Documents/nix-config/nvim" "$HOME/.config/nvim"
      ln -s "$HOME/Documents/nix-config/ags" "$HOME/.config/ags"
    fi
  '';
  nx-switch = pkgs.writeShellScriptBin "nx-switch" ''
    ${symlink} -r
    sudo nixos-rebuild switch --flake . --impure $@
    ${symlink} -a
  '';
  nx-boot = pkgs.writeShellScriptBin "nx-boot" ''
    ${symlink} -r
    sudo nixos-rebuild boot --flake . --impure $@
    ${symlink} -a
  '';
  nx-test = pkgs.writeShellScriptBin "nx-test" ''
    ${symlink} -r
    sudo nixos-rebuild test --flake . --impure $@
    ${symlink} -a
  '';
  nx-up-switch = pkgs.writeShellScriptBin "nx-up-switch" ''
    ${symlink} -r
    sudo nixos-rebuild switch --flake . --impure $@ --upgrade
    ${symlink} -a
  '';
  nx-gc = pkgs.writeShellScriptBin "nx-gc" ''
    sudo nix-collect-garbage -d
  '';
  nx-dev = pkgs.writeShellScriptBin "nx-dev" ''
    nix flake init --template github:cachix/devenv
  '';
  flake-ignore = pkgs.writeShellScriptBin "flake-ignore" ''
    git add --intent-to-add $1 && git update-index --assume-unchanged $1
  '';
  nx-stage = pkgs.writeShellScriptBin "nx-stage" ''
    git add . && git commit -m "$1" && git push
  '';
in
{
  home.packages = [
    flake-ignore
    nx-stage
    nx-switch
    nx-boot
    nx-test
    nx-up-switch
    nx-gc
    nx-dev
  ];
}
