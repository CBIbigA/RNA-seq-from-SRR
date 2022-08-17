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
	script:"../scripts/SRR.py"
		

