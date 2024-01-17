---
author: Zaki Mughal
date: 2024-01-15
---

# A3 - Ontology Alignment Method Selection and Testing

Currently using a selection of ontologies for the schema:

 - [__ExO__: Exposure ontology](https://purl.bioontology.org/ontology/EXO)
 - [__BAO__: BioAssay Ontology](https://purl.bioontology.org/ontology/BAO)
 - [__CHEMINF__: Chemical Information Ontology](https://purl.bioontology.org/ontology/CHEMINF)
 - [__EDAM__: Ontology of bioscientific data analysis and data management](https://purl.bioontology.org/ontology/EDAM)
 - [__OBI__: Ontology for Biomedical Investigations](https://purl.bioontology.org/ontology/OBI)
 - [__SIO__: Semanticscience Integrated Ontology](https://purl.bioontology.org/ontology/SIO)
 - [__RO__: OBO Relation Ontology](https://purl.bioontology.org/ontology/OBOREL)

Many of these are from the Open Biological and Biomedical Ontology (OBO) Foundry.

## Exact matches

These already contain a large number of the entities that are needed to model
the data. For example, in ICE, the following terms for assay endpoints map
directly to existing terms:

<!---

```shell
# Remote
$ runoak -i bioportal: info BAO:0002145 BAO:0002117 BAO:0000186
BAO:0002145 ! LC50
BAO:0002117 ! LD50
BAO:0000186 ! AC50

# Local
$ eval $(./vendor/biobricks-script-lib/activate.sh); \
  export B=$( biobrick-path semsql ); \
  export E=$( realpath $B/../extract ); \
  mkdir -p $E; \
  ls $B/bao.db.gz | parallel '[ -f $E/{/.} ] || gunzip -vck {} > $E/{/.}'; \
  \
  runoak -i $E/bao.db info BAO:0002145 BAO:0002117 BAO:0000186 ;
```

--->

| Endpoint              | Term                                                                                                                          | rdfs:label                |
| --------------------- | ----------------------------------------------------------------------------------------------------------------------------- | ------------------------- |
| LC50                  | [BAO:0002145](https://purl.bioontology.org/ontology/BAO?conceptid=http%3A%2F%2Fwww.bioassayontology.org%2Fbao%23BAO_0002145)  | LC50                      |
| LD50                  | [BAO:0002117](https://purl.bioontology.org/ontology/BAO?conceptid=http%3A%2F%2Fwww.bioassayontology.org%2Fbao%23BAO_0002117)  | LD50                      |
| AC50                  | [BAO:0000186](https://purl.bioontology.org/ontology/BAO?conceptid=http%3A%2F%2Fwww.bioassayontology.org%2Fbao%23BAO_0000186)  | AC50                      |

The current approach for identifying these terms for _entity linking_
is to use [Ontology Access Kit (OAK)](https://incatools.github.io/ontology-access-kit/)
and [semantic-sql](https://github.com/INCATools/semantic-sql) to do searches
against both the BioPortal search API and OWL ontologies as SQLite databases
respectively.

```shell
$ runoak -i bioportal: search LD50 | head -5
BAO:0002117 ! LD50
PLIO:LD50 ! LD50
http://purl.jp/bio/4/id/200906044690497313 ! LD50
http://www.cea.fr/ontotoxnuc#DL50 ! LD50
BAO:0002117 ! LD50
```

## Close matches

There are however some concepts in particular datasets that do not yet have
exact terms in any ontology.

For example, [ __MEDDRA__: Medical Dictionary for Regulatory Activities
Terminology ](https://purl.bioontology.org/ontology/MEDDRA) does contain
something that is close to one of the endpoints in `ice/DART_Data.parquet`

<!--

```shell
duckdb -c "$(cat <<EOF
    SELECT DISTINCT Species, Endpoint, Response, "Unified Medical Language System"
    FROM "data-source/ice/DART_Data.parquet"
    WHERE Endpoint LIKE 'Bilirubin%';
EOF
)";
```

-->


| Endpoint              | Term                                                                                                                          | rdfs:label                | Reason for rejection                         |
| --------------------- | ----------------------------------------------------------------------------------------------------------------------------- | ------------------------- | -------------------------------------------- |
| Bilirubin (increased) | [MEDDRA:10005364](http://purl.bioontology.org/ontology/MEDDRA/10005364)                                                       | Blood bilirubin increased | DART data is applied to non-human organisms. |


However because __MEDDRA__ is for human organisms while DART describes the
total bilirubin in rabbits, this is not appropriate.

## No matches

There are also places where no close terms are available. For example,
`ice/Eye_Irritation_Data`, the following ocular irritation classification
systems are used:

<!--

```shell

duckdb -c "$(cat <<EOF

    -- Possible values for EPA or GHS classification
    SELECT DISTINCT Endpoint, Response
    FROM "data-source/ice/Eye_Irritation_Data.parquet"
    WHERE
        Endpoint LIKE 'EPA%'
        OR
        Endpoint LIKE 'GHS%'
    ORDER BY Endpoint, Response ;

    -- Count of EPA, GHS pairs
    SELECT tuple, COUNT(*)
    FROM (
        SELECT { "EPA": t1.Response, "GHS": t2.Response} AS tuple
        FROM "data-source/ice/Eye_Irritation_Data.parquet" AS t1
            INNER JOIN "data-source/ice/Eye_Irritation_Data.parquet" AS t2
            ON t1."DTXSID" = t2."DTXSID"
        WHERE
            t1.Endpoint LIKE 'EPA%'
            AND
            t2.Endpoint LIKE 'GHS%'
    )
    GROUP BY tuple
    ORDER BY tuple;
EOF
)";

```

-->

| Endpoint           | Values                                         |
| ------------------ | ---------------------------------------------- |
| EPA classification | {"1", "2", "3", "4", "Study criteria not met"} |
| GHS classification | {"1", "2", "2A", "2B", "Not classified"}       |

These can be mapped to specific terms for ocular irritation. Such
classifications exist for most of the ICE datasets (e.g., for skin
irritation/corrosion, acute inhalation).

<!--

# List of Endpoints for EPA or GHS classification systems
```shell
./report/2024-01-15/ice-endpoint-values-csv.sh | awk 'NR == 1 || /EPA|GHS/'
```

-->

# Issues

Slower query speed:

Using Jena with `hdt-java` to load the `.hdt` files can be slow.  This is
exacerbated by the addition of `uniprot-kg` which in some cases either

  - Takes a long time to load on server startup.
  - Crashes with OOM on server startup or during queries.

Solutions:

  1. Split RDF HDT files into even smaller files.
  2. Experiment with other triplestores.
  3. FedX federated querying: <https://rdf4j.org/documentation/programming/federation/>.
