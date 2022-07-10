{
  description = "kmaasrud's flake templates";

  outputs = { self, ... }: {
    templates = {
      rust = {
        path = ./rust-template;
        description = "Simple Rust application";
      };
    };
  };
}
