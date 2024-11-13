set -e

mkdir -p hg38/genome hg38/genes hg38/repeats

# Download the chromosome sizes from UCSC
wget https://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/p14/hg38.p14.chrom.sizes -O hg38/genome/hg38.p14.chrom.sizes

# Download the chromosome FASTAs from UCSC
mkdir tmp; cd tmp
wget https://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/p14/hg38.p14.chromFa.tar.gz
tar xvzf hg38.p14.chromFa.tar.gz

# Remove chromosome M and create a unique FASTA file.
# Chromosome will be ordered following the chromosome size ordering.
cut -f1 ../hg38/genome/hg38.p14.chrom.sizes | awk '{print "chroms/"$1".fa"}' | xargs cat > ../hg38/genome/hg38.p14.ucsc.fa

# Clean up
cd ..; rm -r tmp

# Download the GENCODE complete gene annotations.
wget https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_47/gencode.v47.chr_patch_hapl_scaff.annotation.gtf.gz -O - | gzip -dc > hg38/genes/gencode.v47.hg38.p14.chr_patch_hapl_scaff.annotation.gtf

# Download TEtranscript pre-indexed files. The repeat masker is filtered and contains less entries than the UCSC one. 
# tRNA are removed and other simple and short entries. Exact details are unclear.
# Note that the script will remove most simple repetitive sequences and short non-coding RNA (e.g. tRNA)
# All these files need to be uncompressed using the `gzip -d` command. TElocal does not accept compressed files.
wget https://labshare.cshl.edu/shares/mhammelllab/www-data/TEtranscripts/TE_GTF/hg38_rmsk_TE.gtf.gz -O - | gzip -dc > hg38/repeats/hg38.p14_rmsk_TE.gtf
wget https://labshare.cshl.edu/shares/mhammelllab/www-data/TElocal/annotation_tables/hg38_rmsk_TE.gtf.locInd.locations.gz -O - | gzip -dc > hg38/repeats/hg38.p14_rmsk_TE.gtf.locInd.locations
wget https://labshare.cshl.edu/shares/mhammelllab/www-data/TElocal/prebuilt_indices/hg38_rmsk_TE.gtf.locInd.gz -O - | gzip -dc > hg38/repeats/hg38.p14_rmsk_TE.gtf.locInd

# Generate md5 checksums for all downloaded and processed files
md5sum-lite hg38/genome/hg38.p14.ucsc.fa > hg38/genome/hg38.p14.ucsc.fa.md5
md5sum-lite hg38/genome/hg38.p14.chrom.sizes > hg38/genome/hg38.p14.chrom.sizes.md5
md5sum-lite hg38/genes/gencode.v47.hg38.p14.chr_patch_hapl_scaff.annotation.gtf > hg38/genes/gencode.v47.hg38.p14.chr_patch_hapl_scaff.annotation.gtf.md5
md5sum-lite hg38/repeats/hg38.p14_rmsk_TE.gtf > hg38/repeats/hg38.p14_rmsk_TE.gtf.md5
md5sum-lite hg38/repeats/hg38.p14_rmsk_TE.gtf.locInd.locations > hg38/repeats/hg38.p14_rmsk_TE.gtf.locInd.locations.md5
md5sum-lite hg38/repeats/hg38.p14_rmsk_TE.gtf.locInd > hg38/repeats/hg38.p14_rmsk_TE.gtf.locInd.md5