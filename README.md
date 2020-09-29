# Stool banking donors 16S

## Getting started

### Files needed:

- otu table (as tsv)
- metadata file (as tsv, sample_ids should match sample_ids of otu table)
- confirm_matching_samples.ipynb
- deseq2_normalization_final.ipynb


### Libraries needed:

- pandas
- numpy
- datetime
- scipy
- matplotlib
- seaborn
- skbio


### Step 1: Create new OTU table and metadata file with matching samples

Some samples may be filtered out in the 16S pipeline. This step creates new a new otu table and metadata file with matching samples.

**Inputs**
- otu table
- metadata file

**Run**
confirm_matching_samples.ipynb

**Outputs**
- otu table with all headers matching the metadata file index
- metadata file with all indices matching the otu table index


### Step 2: Normalize OTU table using DESeq2

This step normalizes the raw OTU table using DESeq2. It requires the diffexpr environment. 
Install the DESeq2 diffexpr environment according to https://github.com/wckdouglas/diffexpr

**Inputs**
- otu table - output of confirm_matching_samples.ipynb
- metadata file - output of confirm_matching_samples.ipynb

**Run**
deseq2_normalization_final.ipynb

**Outputs**
- normalized otu table 


### Step 3: Analyses

This step:
- uses PCoA analysis to generally visualize differences between donors and runs
- compares the Jensen Shannon Distance of samples from the same donor versus samples from the same run with using permanova
- creates a boxplot comparing these samples

**Inputs**
- otu table - output of confirm_matching_samples.ipynb
- metadata file - output of confirm_matching_samples.ipynb
- normalized otu table - output of deseq2_normalization_final.ipynb

**Run**
public_16S_notebook_final.ipynb

**Outputs**
- PCoA analysis of data
- Jensen-Shannon distance matrix
- boxplot image as .svg