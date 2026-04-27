{ pkgs, lib, config, inputs, ... }:

let
  # Fetch nixpkgs that contains Terraform 1.5.7
  terraform157Pkgs = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/4415dfb27cfecbe40a127eb3e619fd6615731004.tar.gz";
    sha256 = "sha256:06f4rs71cgpisx6kic1inaj25s2gg8pclvz20b0cn191vmh5hkns";
  }) { system = pkgs.system; };
in
{
  env.AWS_PROFILE = "hugabuga";
  env.AWS_REGION = "gs-east-1";

  packages = [
    pkgs.git
    pkgs.awscli2
    pkgs.ssm-session-manager-plugin
    terraform157Pkgs.terraform
  ];

  enterShell = ''
    alias tf='terraform'
    complete -C `which aws_completer` aws
    git --version
    terraform --version
  '';
}
