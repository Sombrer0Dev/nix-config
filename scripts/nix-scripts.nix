{ pkgs, ... }:
let
  flake-ignore = pkgs.writeShellScriptBin "flake-ignore" ''
    git add --intent-to-add $1 && git update-index --assume-unchanged $1
  '';
  nx-hardware = pkgs.writeShellScriptBin "nx-hardware" ''
    nixos-generate-config --show-hardware-config > hardware-configuration.nix
  '';
  vpn = pkgs.writeShellScriptBin "vpn" ''
    proxy_host="127.0.0.1"
    proxy_port="2080"

    # Check if first argument is `-p` or `-h`
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -p)
                proxy_port="$2"
                shift 2
                ;;
            -h)
                proxy_host="$2"
                shift 2
                ;;
            --)
                shift
                break
                ;;
            -*)
                echo "Unknown option: $1"
                exit 1
                ;;
            *)
                break
                ;;
        esac
    done

    # Remaining arguments are the command to run
    if [[ $# -eq 0 ]]; then
        echo "No command provided to run via proxy."
        exit 1
    fi

    # Run the command with the proxy environment variables
    env HTTPS_PROXY="''${proxy_host}:''${proxy_port}" HTTP_PROXY="''${proxy_host}:''${proxy_port}" "$@"
  '';
  nx-switch = pkgs.writeShellScriptBin "nx-switch" ''
    nh os switch .
  '';
  nx-switch-vpn = pkgs.writeShellScriptBin "nx-switch-vpn" ''
    vpn nh os switch .
  '';
  nx-stage = pkgs.writeShellScriptBin "nx-stage" ''
    git add . && git commit -m "$1" && git push
  '';
in
{
  home.packages = [
    flake-ignore
    nx-hardware
    vpn
    nx-switch
    nx-switch-vpn
    nx-stage
  ];
}
