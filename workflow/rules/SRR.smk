rule sra_getfastq:
	output:
		"RAW/{accession}_1"+SAMPLEEXT,
		"RAW/{accession}_2"+SAMPLEEXT,
	params:
		name = "{accession}"
	benchmark: SAMPLEOUT+"/benchmarks/fastqdump/{accession}.benchmark.txt"
	conda:
		"envs/sra-tools.yaml"
	threads:
		THREADS["SRR"]
	run:
		# Outdir
		outdir = os.path.dirname(snakemake.output[0])
		if outdir:
			outdir = f"--outdir {outdir}"
		extra = snakemake.params.get("extra", "")
		for output in snakemake.output:
			out_name, out_ext = os.path.splitext(output)
			if out_ext == ".gz":
				compress += f"pigz -p {snakemake.threads} {out_name}; "
			elif out_ext == ".bz2":
				compress += f"pbzip2 -p{snakemake.threads} {mem} {out_name}; "
		shell(
			"fasterq-dump --threads {snakemake.threads} "
			"{extra} {outdir} {snakemake.wildcards.accession}; "
			"{compress}"
		)


def getAccesion(wildcards):
	return(README[wildcards.prefix])

rule rename_file:
	output:
		"RAW/{prefix}_{read}"+SAMPLEEXT
	input:
		getAccesion
	shell:
		"mv {input} {output}"