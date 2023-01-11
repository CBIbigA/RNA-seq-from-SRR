#STAR
rule star_index_gtf:
	output:
		GENDIR+"chrName.txt"
	input:
		fasta=GENOME,
		genomeDir=GENDIR,
		gtf=GTF
	params:
		splice_junction_overhang = STAR_OPT["reads_length"]
	priority: 90
	threads:
		THREADS["index"]
	benchmark: SAMPLEOUT+"/benchmarks/star_index_gtf/{input.fasta}.benchmark.txt"
	conda:
		"../envs/star.yaml"
	message: "Indexing with STAR for {input.fasta} with annotation : {input.gtf}"
	shell:
		"STAR"
		" --runMode genomeGenerate"
		" --runThreadN {threads}"
		" --genomeDir {input.genomeDir}"
		" --genomeFastaFiles {input.fasta}"
		" --sjdbGTFfile {input.gtf}"
		" --sjdbOverhang {params.splice_junction_overhang}"




def getAccesion(wildcards):
	return(["{}/{}_{}{}".format(INDIR,README[wildcards.sample],one,SAMPLEEXT) for one in R12])




rule star_load_genome:
	input:
		GENDIR+"chrName.txt"
	output:
		touch(SAMPLEOUT+"/mapping/sam/loading.done")
	params:
		genomeDir = GENDIR
	conda:
		"../envs/star.yaml"
	shell:
		"STAR --genomeLoad LoadAndExit --genomeDir {params.genomeDir}"

rule unload_genome:
	# Delete the loading.done flag file otherwise subsequent runs of the pipeline 
	# will fail to load the genome again if STAR alignment is needed.
	input:
		# Generic function that aggregates all alignment outputs
		bams= expand(SAMPLEOUT+"/mapping/sam/{sample}/{sample}_Aligned.out.sam",sample = SAMPLES),
		idx= SAMPLEOUT+"/mapping/sam/loading.done",
	output:
		temp("logs/STARunload_Log.out")
	params:
		genomeDir = GENDIR
	conda:
		"../envs/star.yaml"
	shell:
		"STAR --genomeLoad Remove "
		"--genomeDir {params.genomeDir} "
		"--outFileNamePrefix logs/STARunload_ "
		"rm {input.idx}"


rule star_aln_quant:
	output:
		SAMPLEOUT+"/mapping/sam/{sample}/{sample}_Aligned.out.sam",
		SAMPLEOUT+"/mapping/sam/{sample}/{sample}_ReadsPerGene.out.tab"
	input:
		getAccesion,
		index = GENDIR+"chrName.txt",
		idx=SAMPLEOUT+"/mapping/sam/loading.done"
	params:
		readFilesCommand = STAR_OPT["readFilesCommand"],
		genomeDir = GENDIR,
		prefix = SAMPLEOUT+"/mapping/sam/{sample}/{sample}_",
		supp=STAR_OPT["custom"],
		name="{sample}"
	priority: 50
	threads:
		THREADS["aln"]
	benchmark: SAMPLEOUT+"/benchmarks/star_aln/{sample}.benchmark.txt"
	conda:
		"../envs/star.yaml"
	message: "STAR aln for {params.name}"
	shell:
		"STAR"
		" {params.supp}"
		" --genomeLoad LoadAndKeep"
		" {params.readFilesCommand}"
		" --genomeDir {params.genomeDir}"
		" --runThreadN {threads}"
		" --readFilesIn {input[0]} {input[1]}"
		" --outFileNamePrefix {params.prefix}"
		" --quantMode GeneCounts"

rule cp_STAR_quant_to_counts:
	input:SAMPLEOUT+"/mapping/sam/{sample}/{sample}_ReadsPerGene.out.tab"
	output:SAMPLEOUT+"/mapping/counts/STAR/{sample}_counts.tsv"
	priority:50
	message: "Copy {input} to {output}"
	benchmark:SAMPLEOUT+"/benchmarks/cp_STAR_quant_to_counts/{sample}.benchmark.txt"
	shell:"cp {input} {output}"

