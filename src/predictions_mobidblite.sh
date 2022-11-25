# Generate input
# The disorder reference contains all targets, by definition
grep -A1 ">" --no-group-separator ../data/output/references/disorder.fasta > disorder.fasta

# Generate predictions
# https://github.com/BioComputingUP/MobiDB-lite
module load mobidb-lite/latest
time mobidb_lite.py disorder.fasta -fc -sf -f caid > MobiDB-lite_all.caid

# Extract mobidb_lite
awk '{if (substr($1,1,1) == ">") {start=0}; if ($2=="mobidb_lite") {start=1}; if (start==1) print $0}' MobiDB-lite_all.caid > MobiDB-lite.caid