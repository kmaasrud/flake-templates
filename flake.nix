{
  description = "kmaasrud's flake templates";

  outputs = { self, ... }: {
    templates = {
      python = {
        path = ./python-template;
        description = "Simple Python application";
      };

      rust = {
        path = ./rust-template;
        description = "Simple Rust application";
      };
    };
  };
}
