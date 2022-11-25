# CAID reference and analysis

## references
Generate the references from two snapshots of the DisProt database (mongo export)

## alphafold
Given the list of targets in the references, it retrieves the predictions from
AlphaFoldDB. The notebook contains instruction about how to extract the disorder
predictions in CAID fromat

## homology
Parse the blast output, extract information about the best match and perform optimal 
pairwise alignments.
Comparison are between CAID and DisProt "old" and between
CAID and PDB seqres.
The notebook also contains instructions about how to run BLAST

# homology_plot
Generate plots from the output of the homology notebook

# references_stat
Generate statistics about the references

# references_merge
Combine predictions with reference data.
It requires the predictions, the references, the mapping of predictions to the
different challenges (this might be removed in the future) and the assessment
(F1-score) one for each reference

# reference_merge_analysis
Generate figures comparing predictions and references, one for each target

# predictions_mobidblite
Instruction to generate MobiDB-lite predictions
