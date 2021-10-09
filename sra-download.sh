#!/bin/bash
#SBATCH --job-name=SRAtoolkitMeats
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=168:00:00
#SBATCH --mem=16gb
#SBATCH --output=SRAtoolkit.%J.out
#SBATCH --err=SRAtoolkit.%J.err

module load SRAtoolkit/2.9

SRA="./sra"

export VDB_CONFIG="$HOME/.ncbi/default.kfg"

echo "Downloading Paired List..."
echo "Number of paired list: $(wc -l paired-list.txt)"
for name in `cat paired-list.txt`; do
	fasterq-dump --threads $(nproc --all) --progress --outdir "$SRA/paired" --split-files "$name";
	echo "Downloaded $name."
done

echo "Downloading Single List..."
echo "Number of single list: $(wc -l single-list.txt)"
for name in `cat single-list.txt`; do
	fasterq-dump --threads $(nproc --all) --progress --outdir "$SRA/single" "$name";
	echo "Downloaded $name."
done

echo "Download successfull."
