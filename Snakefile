THREADS = 4

rule all:
    input:
        "table.tsv",
        "taxonomy.tsv"

rule clean:
    shell:
        "rm -rf *.qza"

rule taxonomy_tsv:
    output:
        "taxonomy.tsv"
    input:
        "taxonomy.qza"
    shell:
        "qiime tools export"
        " --input-path {input}"
        " --output-path ."

rule taxonomy:
    output:
        "taxonomy.qza"
    input:
        reads="rep-seqs.qza",
        classifier="classifier.qza"
    params:
        n_jobs = THREADS
    shell:
        "qiime feature-classifier classify-sklearn"
        " --i-reads {input.reads}"
        " --i-classifier {input.classifier}"
        " --o-classification {output}"
        " --p-n-jobs {params.n_jobs}"

rule download_classifier:
    output:
        "classifier.qza"
    params:
        url="https://data.qiime2.org/2020.8/common/gg-13-8-99-515-806-nb-classifier.qza"
    shell:
        "wget {params.url} -O {output}"

rule convert_table:
    output:
        "{x}.tsv"
    input:
        "{x}.biom"
    shell:
        "biom convert --to-tsv -i {input} -o {output}"

rule export_table:
    output:
        "{x}.biom"
    input:
        "{x}.qza"
    shell:
        "qiime tools export"
        " --input-path {input}"
        " --output-path ."
        " && mv feature-table.biom {output}"

rule denoise:
    output:
        table = "table.qza",
        seqs = "rep-seqs.qza",
        stats = "denoise-stats.qza"
    input:
        "filter.qza"
    params:
        trim_length = 253,
        min_reads = 1,
        jobs_to_start = THREADS
    shell:
        "qiime deblur denoise-16S"
        " --i-demultiplexed-seqs {input}"
        " --p-trim-length {params.trim_length}"
        " --p-min-reads {params.min_reads}"
        " --p-jobs-to-start {params.jobs_to_start}"
        " --p-sample-stats"
        " --o-table {output.table}"
        " --o-representative-sequences {output.seqs}"
        " --o-stats {output.stats}"

rule filter:
    output:
        filter = "filter.qza",
        stats = "filter-stats.qza"
    input:
        "join.qza"
    shell:
        # N.B.: Qiime 2020.8 does *not* use q-score-joined
        "qiime quality-filter q-score"
        " --i-demux {input}"
        " --o-filtered-sequences {output.filter}"
        " --o-filter-stats {output.stats}"

rule join:
    output:
        "join.qza"
    input:
        "demux.qza"
    params:
        threads=THREADS
    shell:
        "qiime vsearch join-pairs"
        " --i-demultiplexed-seqs {input}"
        " --o-joined-sequences {output}"
        " --p-threads {params.threads}"

rule demultiplex:
    output:
        "demux.qza"
    shell:
        "qiime tools import"
        " --type 'SampleData[PairedEndSequencesWithQuality]'"
        " --input-path fastq"
        " --input-format CasavaOneEightSingleLanePerSampleDirFmt"
        " --output-path {output}"
