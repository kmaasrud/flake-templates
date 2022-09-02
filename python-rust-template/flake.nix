{
  description = "<PYTHON MODULE DESCRIPTION>";

  inputs = {
    utils.url = "github:numtide/flake-utils";
    rust.url = "github:oxalica/rust-overlay";
    mach.url = "github:DavHau/mach-nix";
  };

  outputs = { self, mach, nixpkgs, utils, rust }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ (import rust) ];
        };
        inherit (pkgs) rustPlatform mkShell stdenv lib;

        # Rust
        rustBuild = pkgs.rust-bin.selectLatestNightlyWith (toolchain: toolchain.default);
        cargo-toml = builtins.fromTOML (builtins.readFile ./Cargo.toml);

        # Python
        python = "python310";
        wrapper = import mach { inherit pkgs python; };
        requirements = builtins.readFile ./requirements.txt;
        pythonBuild = wrapper.mkPython { inherit requirements; };

        # Package
        pname = cargo-toml.package.name;
        version = cargo-toml.package.version;
      in
      rec {
        # `nix develop`
        devShell = mkShell {
          buildInputs = [
            pkgs.maturin
            rustBuild
            pythonBuild
            (pkgs.${python}.withPackages
              (ps: with ps; [ pip black ]))
          ];

          # Create virtualenv if it doesn't already exist
          shellHook = ''
            [ ! -d ".venv" ] && python -m virtualenv .venv
          '';
        };
      }
    );
}
