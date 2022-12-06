# CAID reference and analysis

```bash
# Generate the folder structure
mkdir -p data/{disprot,sifts,alphafold,output/{references,references_stat,references_merge_analysis,homology}}
````

## references
Generate the references from two snapshots of the DisProt database (mongo export)
DisProt data can be obtained directly exporting the relevant database collections (ask the developers). 
Or using the download service from the website (lastest annotations might not be available to the public). Note the formats are slightly different.

```bash
# 20 Nov 2022
mongoexport -d disprot8 -c entries_2022_06 -o disprot_entries_2022_06.mjson
mongoexport -d disprot8 -c entries_2022_12_c -o disprot_entries_2022_12_c.mjson
scp moros:disprot_entries* .

# Download data (20 Nov 2022)
wget -O data/sifts/uniprot_segments_observed.tsv.gz ftp://ftp.ebi.ac.uk/pub/databases/msd/sifts/flatfiles/tsv/uniprot_segments_observed.tsv.gz
wget -O data/disprot/go-basic.obo http://purl.obolibrary.org/obo/go/go-basic.obo
```

## homology
Parse the blast output, extract information about the best match and perform optimal 
pairwise alignments.
Comparison are between CAID and DisProt "old" and between
CAID and PDB seqres.

Generate BLAST alignments of the new DisProt against the old DisProt and against PDB seqres
Install blast on your home (check the version and paths)
```
wget https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/ncbi-blast-2.13.0+-x64-linux.tar.gz
tar -xf ncbi-blast-2.13.0+-x64-linux.tar.gz
export PATH="/home/$USER/ncbi-blast-2.13.0+/bin:$PATH" 
```
Download PDB seqres
```
wget https://ftp.wwpdb.org/pub/pdb/derived_data/pdb_seqres.txt.gz -O data/output/homology/pdb_seqres.txt.gz
gunzip data/output/homology/pdb_seqres.txt.gz
```

Make dbs
```
makeblastdb -in data/output/homology/disprot_old.fasta -dbtype prot
makeblastdb -in data/output/homology/pdb_seqres.txt -dbtype prot
```

Run BLAST
```
blastp -db data/output/homology/disprot_old.fasta -query data/output/homology/disprot_new.fasta -out data/output/homology/disprot_new_old.blast -outfmt 6 -num_threads 12
blastp -db data/output/homology/pdb_seqres.txt -query data/output/homology/disprot_new.fasta -out data/output/homology/disprot_new_pdb.blast -outfmt 6 -num_threads 12
```

## homology_plot
Generate plots from the output of the homology notebook

## references_stat
Generate statistics about the references

## references_merge
Combine predictions with reference data.
It requires the predictions, the references, the mapping of predictions to the
different challenges (this might be removed in the future) and the assessment
(F1-score) one for each reference

```bash
scp -r urano:/projects/CAID2/results data/assessment_results
scp -r urano:/projects/CAID2/predictions data/predictions
```
Also, save the 

## reference_merge_analysis
Generate figures comparing predictions and references, one for each target

## predictions_alphafold
Given the list of targets in the references, it retrieves the predicted structures from
AlphaFoldDB. 

Then you can generate disorde and binding predictions
with the [AlphaFold-disorder](https://github.com/BioComputingUP/AlphaFold-disorder)
package:

```bash
python3 alphafold_disorder.py -i ../caid2-reference/data/alphafold/download/ -o ../caid2-reference/data/alphafold/af -dssp=dssp-2.3.0/mkdssp
python3 alphafold_disorder.py -i ../caid2-reference/data/alphafold/download/ -o ../caid2-reference/data/alphafold/af -dssp=dssp-2.3.0/mkdssp -f caid
```

## predictions_mobidblite
Instruction to generate MobiDB-lite predictions

Generate input. The disorder reference contains all targets, by definition
```bash
grep -A1 ">" --no-group-separator ../data/output/references/disorder.fasta > disorder.fasta
```
Generate predictions with [MobiDB-lite](https://github.com/BioComputingUP/MobiDB-lite) package.
```bash
module load mobidb-lite/latest
time mobidb_lite.py disorder.fasta -fc -sf -f caid > MobiDB-lite_all.caid
```

Extract mobidb_lite predictions, remove other methods
```bash
awk '{if (substr($1,1,1) == ">") {start=0}; if ($2=="mobidb_lite") {start=1}; if (start==1) print $0}' MobiDB-lite_all.caid > MobiDB-lite.caid
```

