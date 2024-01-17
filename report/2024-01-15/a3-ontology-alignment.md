# A3 - Ontology Alignment Method Selection and Testing

Currently using a selection of ontologies for the schema:

 - [__ExO__: Exposure ontology](https://purl.bioontology.org/ontology/EXO)
 - [__BAO__: BioAssay Ontology](https://purl.bioontology.org/ontology/BAO)
 - [__CHEMINF__: Chemical Information Ontology](https://purl.bioontology.org/ontology/CHEMINF)
 - [__OBI__: Ontology for Biomedical Investigations](https://purl.bioontology.org/ontology/OBI)
 - [__RO__: OBO Relation Ontology](https://purl.bioontology.org/ontology/OBOREL)

Many of these are from the Open Biological and Biomedical Ontology (OBO) Foundry.

These already contain a large number of the entities that are needed to model
the data, for example, in ICE, the following terms for assay endpoints map
directly to existing terms:

| Endpoint              | Term                                                                                                                          | rdfs:label                |
| --------------------- | ----------------------------------------------------------------------------------------------------------------------------- | ------------------------- |
| LC50                  | [BAO:0002145](https://purl.bioontology.org/ontology/BAO?conceptid=http%3A%2F%2Fwww.bioassayontology.org%2Fbao%23BAO_0002145)  | LC50                      |
| LD50                  | [BAO:0002117](https://purl.bioontology.org/ontology/BAO?conceptid=http%3A%2F%2Fwww.bioassayontology.org%2Fbao%23BAO_0002117)  | LD50                      |
| AC50                  | [BAO:0000186](https://purl.bioontology.org/ontology/BAO?conceptid=http%3A%2F%2Fwww.bioassayontology.org%2Fbao%23BAO_0000186)  | AC50                      |
| Bilirubin (increased) | [MEDDRA:10005364](http://purl.bioontology.org/ontology/MEDDRA/10005364)                                                       | Blood bilirubin increased |

Many of these can be found in the __BAO__ and [ __MEDDRA__: Medical Dictionary for
Regulatory Activities Terminology ](https://purl.bioontology.org/ontology/MEDDRA).

There are however some concepts in particular datasets that do not yet have terms in any ontology.
