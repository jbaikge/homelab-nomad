let
  pkgs = import <nixpkgs> { };
  PROJECT_ROOT = builtins.toString ./.;
in
pkgs.mkShell {
  packages = [
    pkgs.age
    pkgs.opentofu
    pkgs.sops
    pkgs.yq
  ];

  shellHook = ''
  '';
}
