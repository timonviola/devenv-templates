{
    description = "Devenv project templates";

    outputs = { self, ... }: {
      templates = {
        python = {
          path = ./python;
          description = "Python project with devenv";
        };
        rust = {
          path = ./rust;
          description = "Rust project with devenv";
        };
        rust-flake = {
          path = ./rust-flake;
          description = "Rust project with raw flake.nix";
        };
        node = {
          path = ./node;
          description = "Node.js project with devenv";
        };
        default = self.templates.python;
      };
    };
}
