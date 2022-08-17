import os
import tempfile
from snakemake.shell import shell
from snakemake_wrapper_utils.snakemake import get_mem


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