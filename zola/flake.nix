{
  description = "My personal website";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  inputs.zola-pkg.url = "github:nixos/nixpkgs/5b5b46259bef947314345ab3f702c56b7788cab8";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, zola-pkg, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        zola = zola-pkg.legacyPackages.${system}.zola;
        serene-theme = pkgs.fetchgit {
          url = "https://github.com/isunjn/serene.git";
          rev = "673df39abd1a478df316ac9f64ae1553b123d8ff";
          sha256 = "sha256-ChfqARB8PP1e+0Z8sPJpeK0TGKoSUjmyLXUWp4EprkQ=";
        };
      in
      {
        packages.website = pkgs.stdenv.mkDerivation rec {
          pname = "static-website";
          version = "2026-01-31";
          src = self;
          nativeBuildInputs = [ zola ];
          preBuildPhases = [ "setupThemePhase" ];
          setupThemePhase = ''
            mkdir -p themes
            ln -s ${serene-theme} themes/serene
          '';
          buildPhase = "zola build";
          installPhase = "cp -r public $out";
        };
        defaultPackage = self.packages.${system}.website;
        apps.default = {
          type = "app";
          program = "${pkgs.writeShellScript "zola-serve" ''
            exec ${zola}/bin/zola serve "$@"
          ''}";
        };
        devShell = pkgs.mkShell {
          packages = [
            zola
            pkgs.typos
          ];
        };
      }
    );
}
