rule sra_getfastq:
	output:
		"RAW/{accession}_1"+SAMPLEEXT,
		"RAW/{accession}_2"+SAMPLEEXT,
	params:
		name = "{accession}"
	benchmark: SAMPLEOUT+"/benchmarks/fastqdump/{accession}.benchmark.txt"
	conda:
		"../envs/sra-tools.yaml"
	threads:
		THREADS["SRR"]
	script:"scripts/SRR.py"
		


def getAccesion(wildcards):
	return(README[wildcards.prefix])

rule rename_file:
	output:
		"RAW/{prefix}_{read}"+SAMPLEEXT
	input:
		getAccesion
	shell:
		"mv {input} {output}"