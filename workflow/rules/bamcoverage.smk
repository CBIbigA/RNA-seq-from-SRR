
rule bamCoverage:
    input:
        bam=SAMPLEOUT+"/mapping/bam/sorted/{prefix}.sorted.bam",
        bai=SAMPLEOUT+"/mapping/bam/sorted/{prefix}.sorted.bai"
    threads: THREADS["bigwig"]
    output:
        protected(SAMPLEOUT+"/mapping/BIGWIG/{prefix}_normalized.bw")
    params:
        normalization="CPM",
        binsize=1
    benchmark:
        SAMPLEOUT+"/benchmarks/bamCoverage/{prefix}.txt"
    conda: "../envs/deeptools.yaml"
    priority: 50
    shell:
        "bamCoverage -b {input.bam} -o {output} -of bigwig -bs {params.binsize} -p {threads} --exactScaling --normalizeUsing {params.normalization} "

rule bamCoverage_negative:
    input:
        bam=SAMPLEOUT+"/mapping/bam/sorted/{prefix}.sorted.bam",
        bai=SAMPLEOUT+"/mapping/bam/sorted/{prefix}.sorted.bai"
    threads: THREADS["bigwig"]
    output:
        protected(SAMPLEOUT+"/mapping/BIGWIG/{prefix}_normalized_negative_strand.bw")
    params:
        normalization="CPM",
        binsize=1
    benchmark:
        SAMPLEOUT+"/benchmarks/bamCoverage_negative/{prefix}.txt"
    conda: "../envs/deeptools.yaml"
    priority: 50
    shell:
        "bamCoverage -b {input.bam} -o {output} -of bigwig --filterRNAstrand reverse -bs {params.binsize} -p {threads} --exactScaling --normalizeUsing {params.normalization} "

rule bamCoverage_positive:
    input:
        bam=SAMPLEOUT+"/mapping/bam/sorted/{prefix}.sorted.bam",
        bai=SAMPLEOUT+"/mapping/bam/sorted/{prefix}.sorted.bai"
    threads: THREADS["bigwig"]
    output:
        protected(SAMPLEOUT+"/mapping/BIGWIG/{prefix}_normalized_positive_strand.bw")
    params:
        normalization="CPM",
        binsize=1
    benchmark:
        SAMPLEOUT+"/benchmarks/bamCoverage_positive/{prefix}.txt"
    conda: "../envs/deeptools.yaml"
    priority: 50
    shell:
        "bamCoverage -b {input.bam} -o {output} -of bigwig --filterRNAstrand forward -bs {params.binsize} -p {threads} --exactScaling --normalizeUsing {params.normalization} "
