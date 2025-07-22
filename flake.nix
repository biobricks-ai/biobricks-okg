{
  description = "biobricks-okg BioBrick";

  inputs = {
    self.submodules = true;
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils";
    dev-shell.url = "github:biobricks-ai/dev-shell";
    biobricks-script-lib = {
      url = "path:./vendor/biobricks-script-lib";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, dev-shell, biobricks-script-lib }:
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
              apache-jena
              apache-jena-fuseki
              jq
            ] ++ biobricks-script-lib.packages.${system}.buildInputs;

            env = oldAttrs.env // {
              JENA_HOME = "${apache-jena}";
            };

            shellHook = ''
              # Activate biobricks-script-lib environment
              eval $(${biobricks-script-lib.packages.${system}.activateScript})
            '';
          });
      });
}
