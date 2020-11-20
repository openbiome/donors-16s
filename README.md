# Stool banking donors 16S

## To do

- Automate downloading fastq's in Snakefile
- Add output files when about to upload
- Make Zenodo release

## Getting started

1. Install [conda](https://docs.conda.io/)
2. Install the working environment (Qiime and Snakemake): `conda env create --file env.yml`
3. Make sure you're in that environment: `conda activate donors-16s`
4. Install R packages: `./install-packages.R` 
5. Run `snakemake` in that environment

## Files

### Data files

- `data-descriptions/`:
    - `donor_health_data.xlsx`: Characteristics of the stool donors in this
      dataset. "Data file 2" in the manuscript.
    - `exclusion_criteria_comparison.xlsx`: Comparison of the exclusion
      criteria used in this data set, HMP, and AGP. "Data file 1" in the
      manuscript
- `fastq/`: Location where raw data is downloaded to. When downloaded, these
   are "Data set 1" in the manuscript.
- `metadata.csv`: Sample metadata. "Data file 4" in the manuscript.
- `files_list.csv`: Fantastic fastq's and where to download them

### Input Scripts and utilities

- `README.md`: This file
- `Snakefile`: File showing the computation order
- `analyze.R`: Performs beta diversity analyses on OTU table
- `env.yml`: Conda environment specification
- `install-packages.R`: Script for installing relevant R packages

### Output files

- `beta.tsv`: Beta diversity matrix
- `pcoa.tsv`: Sample coordinates
- `rep-seqs.fasta`: OTUs' representative sequences
- `results/`
    - `jsd.pdf`: Boxplot of between-sample JSDs by grouping. "Figure 1"
      in the manuscript.
    - `jsd.txt`: Statistical tests of between-sample JSDs by grouping
    - `pcoa.pdf`: Plot of PCOA ordination. "Figure 2" in the manuscript.
    - `permanova.txt`: Statistical test of beta diversity
- `table.tsv`: OTU table. "Data file 3" in the manuscript.
- `taxonomy.tsv`: RDP taxonomies for OTUs

## Authors

Marina Santiago <msantiago@openbiome.org>

Scott Olesen <solesen@openbiome.org>
