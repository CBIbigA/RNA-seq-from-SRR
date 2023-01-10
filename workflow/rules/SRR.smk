rule sra_getfastq:
	output:
		INDIR+"/{accession}_1"+SAMPLEEXT,
		INDIR+"/{accession}_2"+SAMPLEEXT,
	params:
		name = "{accession}"
	benchmark: SAMPLEOUT+"/benchmarks/fastqdump/{accession}.benchmark.txt"
	conda:
		"../envs/sra-tools.yaml"
	threads:
		THREADS["SRR"]
	script:"../scripts/SRR.py"
		

