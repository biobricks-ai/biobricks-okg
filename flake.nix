{
  description = "biobricks-okg BioBrick";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils";
    dev-shell.url = "github:biobricks-ai/dev-shell";
    hdt-java = {
      url = "github:insilica/nix-hdt-java";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, dev-shell, hdt-java }:
    flake-utils.lib.eachDefaultSystem (system:
      with import nixpkgs { inherit system; }; {
        devShells.default = dev-shell.devShells.${system}.default.overrideAttrs
          (oldAttrs: {
            buildInputs = oldAttrs.buildInputs ++ [
              perlPackages.CpanelJSONXS    # see cpanfile
              perlPackages.YAML            # see cpanfile
              perlPackages.URI             # see cpanfile
              perlPackages.TemplateToolkit # see db-fuseki/cpanfile
              hdt-java.packages.${system}.default
              apache-jena
              apache-jena-fuseki
              jq
              (lib.hiPrio pkgs.parallel-full) # prefer GNU Parallel over `moreutils`
              moreutils
            ];
            shellHook = oldAttrs.shellHook + ''
              export JENA_HOME=$(realpath $( dirname $( which jena ) )/..)
            '';
          });
      });
}
