{
  description = "Rust Axum backend";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { self, nixpkgs, flake-utils, rust-overlay }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
        rust = pkgs.rust-bin.stable.latest.default;
      in
      {
        packages.default = pkgs.rustPlatform.buildRustPackage {
          pname = "server";
          version = "0.1.0";
          src = ./.;
          cargoLock.lockFile = ./Cargo.lock;
          
          buildInputs = with pkgs; [
            sqlite
            pkg-config
            libiconv
          ];

          env = {
            PKG_CONFIG_PATH = "${pkgs.sqlite.dev}/lib/pkgconfig:${pkgs.libiconv}/lib/pkgconfig";
          };
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            rust
            cargo
            cargo-watch
            cargo-deny
            rustc
            sqlite
            pkg-config
            libiconv
            sqlx-cli
            cocogitto
            rainfrog
            prek
          ];

          shellHook = ''
            export PKG_CONFIG_PATH="${pkgs.sqlite.dev}/lib/pkgconfig:${pkgs.libiconv}/lib/pkgconfig:$PKG_CONFIG_PATH";
            export DATABASE_URL="postgresql://postgres:password@localhost:5432/postgres";
            alias rainfrog='rainfrog --url ${DATABASE_URL}'
            export RUST_LOG="debug"
          '';
        };
      }
    );
}
