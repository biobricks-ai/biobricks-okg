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
          (oldAttrs:
            let
              inherit (pkgs.perlPackages) makePerlPath;
              perlEnv =
                perl.withPackages (p: with p; [
                  CpanelJSONXS    # see cpanfile
                  YAML            # see cpanfile
                  URI             # see cpanfile
                  TemplateToolkit # see db-fuseki/cpanfile
                ]); in {
            buildInputs = oldAttrs.buildInputs ++ [
              perlEnv
              hdt-java.packages.${system}.default
              apache-jena
              apache-jena-fuseki
              jq
            ];
            env = oldAttrs.env // {
              JENA_HOME = "${apache-jena}";
            };
          });
      });
}
