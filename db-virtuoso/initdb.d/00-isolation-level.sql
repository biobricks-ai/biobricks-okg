-- Sets the transaction isolation level to avoid locking with bulk loading.
-- 
-- SEE ALSO:
--   * "Performance Tuning" <https://docs.openlinksw.com/virtuoso/ptune/#ptuneprogvirtpl>
--   * PubChemRDF's tips for bulk loading <https://pubchem.ncbi.nlm.nih.gov/docs/rdf-load>
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
