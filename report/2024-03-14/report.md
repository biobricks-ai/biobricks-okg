---
author: Zaki Mughal
date: 2024-03-14
---

# Definitions

Roles:

- *Data owner*:
    Provider of the upstream data.
- *Data scientist* (or Informatician):
     Uses the data for further analysis. The consumer of the data.
- *Data engineer* (or ETL engineer):
    Processes the data so that it is usable (data cleaning, follows a schema).
- *DataOps*:
    Makes sure data is deliverable to data consumers.

# Ways to access the knowledge graph data

## BioBricks download

Description:

- BioBricks for RDF graphs are stored as binary HDT files.

Pros:

- *Data scientist*: Can download original data.
- *Data scientist*: Possible to immediately load these data into a Jena Fuseki SPARQL endpoint
  for local querying without having to wait for database indexing (this exists
  via the `make db-fuseki-up` Makefile target).

Cons:

- *Data scientist*:
    Requires local disk space.
- *Data scientist*:
    Requires ability to work with terminal in order to
    configure Jena Fuseki SPARQL endpoint.
- *Data scientist*:
    HDT is not usable directly for most languages so must be converted back to
    a text format like N-Triples if trying to use without .
- *DataOps*:
    Currently using very large graphs such as Uniprot (specifically in
    HDT format) with Jena Fuseki is quite slow.

Future development:

- *Data engineer*:
    More generic textual RDF format (Turtle, etc.) to HDT conversion scripts that
    can be used to turn any RDF data into bricks.
