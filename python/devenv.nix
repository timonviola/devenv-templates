{ pkgs, lib, config, inputs, ... }:
{
  packages = [
	pkgs.python314
    pkgs.cocogitto
    pkgs.git
    pkgs.just
    pkgs.ruff
    pkgs.uv
];

  git-hooks.package = pkgs.prek;
  git-hooks.hooks = {
    ruff-format = {
      enable = true;
      entry = "ruff format --fix";
      language = "system";
      stages = [ "pre-commit" ];
    };
    ruff = {
      enable = true;
      entry = "ruff check .";
      language = "system";
      stages = [ "pre-commit" ];
    };
    typos = {
      enable = true;
      entry = "typos --check .";
      language = "system";
      stages = [ "pre-commit" ];
    };
    cog = {
      enable = true;
      entry = "cog verify --file";
      language = "system";
      stages = [ "commit-msg" ];
    };
  };

  # https://devenv.sh/tests/
  enterTest = ''
    git --version | grep --color=auto "${pkgs.git.version}"
  '';
}
