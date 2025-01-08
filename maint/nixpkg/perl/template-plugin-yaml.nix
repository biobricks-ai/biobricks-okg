{ perlPackages, fetchurl, lib }:

perlPackages.buildPerlPackage {
  pname = "Template-Plugin-YAML";
  version = "1.23";
  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RC/RCLAMP/Template-Plugin-YAML-1.23.tar.gz";
    hash = "sha256-yN/lbWij7gPPHCdDGOuoxfkkGweU5NU+NSEG/hCy8rc=";
  };
  propagatedBuildInputs = with perlPackages; [ TemplateToolkit YAML ];
  meta = {
  };
}
