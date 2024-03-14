---
author: Zaki Mughal
date: 2024-03-14
---

# Definitions

Roles:

- **Data owner**:
    Provider of the upstream data.
- **Data scientist** (or Informatician):
     Uses the data for further analysis. The consumer of the data.
- **Data engineer** (or ETL engineer):
    Processes the data so that it is usable (data cleaning, data modeling).
- **DataOps**:
    Makes sure data is deliverable to data consumers.

# Access to the knowledge graph data

## BioBricks download

Description:

- BioBricks for RDF graphs are stored as binary HDT files.

Pros:

- [**Data scientist**]
    Can download original data.
- [**Data scientist**]
    Able to pin a specific version of the data for a given project.
- [**Data scientist**]
    Possible to immediately load these data into a Jena Fuseki SPARQL endpoint
    for local querying without having to wait for database indexing (this exists
    via the `make db-fuseki-up` Makefile target).

Cons:

- [**Data scientist**]
    Requires local disk space.
- [**Data scientist**]
    Requires ability to work with terminal in order to
    configure Jena Fuseki SPARQL endpoint.
- [**Data scientist**]
    HDT is not usable directly for most languages so must be converted back to
    a text format like N-Triples if trying to use without `hdt-java` library.
- [**DataOps**]
    Currently using very large graphs such as UniProt (specifically in
    HDT format) with Jena Fuseki is quite slow. But for most datasets this is
    not a problem as most graphs are not that large.

Future development:

- [**Data engineer**]
    More generic textual RDF format (Turtle, etc.) to HDT conversion scripts that
    can be used to turn any RDF data into bricks.
- [**Data owner**, **Data engineer**]
    May need more coordination to prepare for updates to the data and schema
    changes.
- [**Data engineer**]
    Improve the generation of documentation for the schema. It needs more
    information than what what is in the PlantUML output. A good example is
    the PubChemRDF documentation
    ([1](https://pubchem.ncbi.nlm.nih.gov/docs/rdf-intro#section=PubChemRDF-Graphs),
    [2](https://pubchem.ncbi.nlm.nih.gov/docs/rdf-intro#section=Ontology-based-Data-Integration),
    [3](https://pubchem.ncbi.nlm.nih.gov/docs/rdf-uri)).

## SPARQL endpoint

Description:

- Endpoint with up-to-date loaded data.
- Currently using Virtuoso as the backend.
- Data can be loaded from the BioBricks HDT via conversion to textual RDF
  format or directly from the source textual RDF format files.

Pros:

- [**Data scientist**]
    Fast access even for large datasets.

Cons:

- [**Data scientist**]
     Requires learning / writing SPARQL.

- [**DataOps**]
    Datasets can not be used immediately. Need to be loaded and indexed first.
    This can take a while.

Future development:

- [**Data engineer**]
    Need to create a repository of SPARQL queries to answer questions. Existing
    examples of this at endpoints for other datasets are:
     * [PubChemRDF](https://pubchem.ncbi.nlm.nih.gov/docs/rdf-use-cases),
     * [UniProt](https://sparql.uniprot.org/.well-known/sparql-examples/),
     * [OrthoDB](https://sparql.orthodb.org/),
     * [WikiPathways](https://sparql.wikipathways.org/) ([Query repo](https://github.com/wikipathways/SPARQLQueries)).

    This can be distributed with the individual bricks for queries related to
    data within the brick itself and in another repository for queries that
    integrate multiple data sources.
- [**DataOps**]
    Need to set up improved loading which keeps track of data that has changed
    so that old data can be removed and replaced with new data (possible to
    use file checksum).
- [**DataOps**]
    Need to automate loading ontologies into the DB. This is just a list of
    URLs for a particular version of the ontology.

## LLM for SPARQL generation

Description:

- Frontend to the SPARQL endpoint that allows for a natural language
  interface that feels more like "question answering".
- Currently the approach uses the [SPARQL Query Template](https://community.openlinksw.com/t/using-sparql-query-templates-to-fine-tune-chatgpts-large-language-model-llm/3842) prompting approach.

Pros:

- [**Data scientist**]
     Does not require learning / writing SPARQL.

Cons:

- [**Data scientist**]
     May not be immediately clear why a particular query is not working.
     This may still require knowing how to read SPARQL but not necessarily
     write it (e.g., know what identifiers correspond to in order to tell it
     how to fix a query).

- [**DataOps**]
     The stochastic nature of these responses will require LLM monitoring to
     measure output performance.

Future development:

- [**DataOps**]
     Automatically create the prompts and knowledge base for the LLM.
     A repository of SPARQL queries and list of ontologies uses will help with
     generating this.

# Use case ideas

There are several potential use cases recorded as issues:

- [Developmental toxicity of substance X · Issue #14 · biobricks-ai/biobricks-okg · GitHub](https://github.com/biobricks-ai/biobricks-okg/issues/14)
- [Mapping of Modes of Action · Issue #15 · biobricks-ai/biobricks-okg · GitHub](https://github.com/biobricks-ai/biobricks-okg/issues/15)

Take existing methods in regulatory toxicology and perform part of the data
analysis using the knowledge graph.

- read-across frameworks
  * [Exploring Current Read-across Applications and Needs Among Selected U.S. Federal Agencies - PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6814248/)
- chemical similarity and fingerprinting methods
  * Some of these can be computed on-the-fly so do not need to be stored on
    disk. This might require some way of presenting a virtual knowledge graph (and
    using federation)?
