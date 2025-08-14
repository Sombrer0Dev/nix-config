{
  pkgs,
  ...
}:
{
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;

    profiles.default = {
      enableExtensionUpdateCheck = false;
      enableUpdateCheck = false;
      extensions = (
        with pkgs.vscode-marketplace;
        [
          ms-python.python
          ms-python.python
          ms-python.debugpy
          ms-python.vscode-pylance
          ms-python.pylint
          ms-python.flake8
          ms-python.mypy-type-checker

          danprince.vsnetrw
          mkhl.direnv
        ]
      );
    };
  };
}
