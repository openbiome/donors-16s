# Stool banking donors 16S

## To do

- Upload fastq's to SRA
- Automate downloading fastq's in Snakefile
- Add output files when about to upload

## Getting started

1. Install [conda](https://docs.conda.io/)
2. Install the working environment (Qiime and Snakemake): `conda create --name donors-16s --file env.txt`
3. Install R packages using `./install-packages.R` into that environment
4. Run `snakemake` in that environment

## Files

### Input Scripts and utilities

- `analyze.R`: Performs beta diversity analyses on OTU table
- `env.txt`: Conda environment
- `fastq/`: Location where raw data is downloaded to
- `install-packages.R`: Script for installing relevant R packages
- `metadata.tsv`: Sample metadata
- `README.md`: This file
- `Snakefile`: File showing the computation order

### Output files

- `beta.tsv`: Beta diversity matrix
- `pcoa.tsv`: Sample coordinates
- `rep-seqs.fasta`: OTUs' representative sequences
- `results/`
    - `jsd.pdf`: Boxplot of between-sample JSDs by grouping
    - `jsd.txt`: Statistical tests of between-sample JSDs by grouping
    - `pcoa.pdf`: Plot of PCOA ordination
    - `permanova.txt`: Statistical test of beta diversity
- `table.tsv`: OTU table
- `taxonomy.tsv`: RDP taxonomies for OTUs
