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
    {
      overlays.default = final: prev: {
        perlPackages = prev.perlPackages // {
          TemplatePluginYAML  = final.callPackage ./maint/nixpkg/perl/template-plugin-yaml.nix {};
        };
      };
    } //
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ self.overlays.default ];
        };
      in {
        devShells.default = dev-shell.devShells.${system}.default.overrideAttrs
          (oldAttrs:
            let
              inherit (pkgs.perlPackages) makePerlPath;
              extraPerlPackages = with pkgs.perlPackages; [
                  CpanelJSONXS       # see cpanfile
                  YAML               # see cpanfile
                  URI                # see cpanfile
                  TemplateToolkit    # see db-fuseki/cpanfile
                  TemplatePluginYAML # see db-fuseki/cpanfile
                ];
              parallelWithPerlEnv = pkgs.stdenv.mkDerivation {
                name = "parallel-with-perl-env";
                buildInputs = [ pkgs.parallel pkgs.makeWrapper ];
                propagatedBuildInputs = extraPerlPackages;
                unpackPhase = "true";
                installPhase = ''
                  mkdir -p $out/bin
                  makeWrapper ${pkgs.parallel}/bin/parallel $out/bin/parallel \
                    --set PERL5LIB "${with pkgs.perlPackages; makeFullPerlPath (extraPerlPackages)}"
                '';
              };
          in {
            buildInputs = oldAttrs.buildInputs ++ [
              parallelWithPerlEnv
              hdt-java.packages.${system}.default
              pkgs.apache-jena
              pkgs.apache-jena-fuseki
              pkgs.jq
            ];
            env = oldAttrs.env // {
              JENA_HOME = "${pkgs.apache-jena}";
            };
          });
      });
}
