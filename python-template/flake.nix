{
  description = "Flake to manage a Python workspace";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    utils.url = "github:numtide/flake-utils";
    mach.url = "github:DavHau/mach-nix";
  };

  outputs = { self, nixpkgs, utils, mach}:
    utils.lib.eachDefaultSystem (system:
      let
        python = "python310";
        pkgs = import nixpkgs { inherit system; };
        wrapper = import mach { inherit pkgs python; };
        requirements = builtins.readFile ./requirements.txt;
        pythonBuild = wrapper.mkPython { inherit requirements; };
      in {
        devShell = pkgs.mkShell {
          buildInputs = [
            pythonBuild
            (pkgs.${python}.withPackages
              (ps: with ps; [ pip black ]))
          ];
        };
      });
}
