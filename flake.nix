{
  description = "biobricks-okg BioBrick";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
    dev-shell.url = "github:biobricks-ai/dev-shell";
  };

  outputs = { self, nixpkgs, flake-utils, dev-shell }:
    flake-utils.lib.eachDefaultSystem (system:
      with import nixpkgs { inherit system; }; {
        devShells.default = dev-shell.devShells.${system}.default.overrideAttrs
          (oldAttrs: {
            buildInputs = oldAttrs.buildInputs ++ [
              perlPackages.CpanelJSONXS    # see cpanfile
              perlPackages.YAML            # see cpanfile
              perlPackages.TemplateToolkit # see db-fuseki/cpanfile
              jq
              (lib.hiPrio pkgs.parallel-full) # prefer GNU Parallel over `moreutils`
              moreutils
            ];
          });
      });
}
