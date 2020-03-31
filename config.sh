#!/usr/bin/env bash

DATABASE_DIR=$(pwd)/database
HUMAN_GRCH37_VERSION=75
HUMAN_GRCH38_VERSION=99

ENSEMBL_GRCh37_BASE=ftp://ftp.ensembl.org/pub/release-${HUMAN_GRCH37_VERSION}/fasta/homo_sapiens/dna
ENSEMBL_GRCh37_GTF_BASE=ftp://ftp.ensembl.org/pub/release-${HUMAN_GRCH37_VERSION}/gtf/homo_sapiens
UCSC_FTP=http://hgdownload.soe.ucsc.edu/goldenPath/
FLAT_FILE=refFlat.txt
FLAT_GRCH37=${UCSC_FTP}/hg19/database/${FLAT_FILE}.gz
FLAT_GRCH38=${UCSC_FTP}/hg38/database/${FLAT_FILE}.gz
ENSEMBL_GRCh38_BASE=ftp://ftp.ensembl.org/pub/release-${HUMAN_GRCH38_VERSION}/fasta/homo_sapiens/dna
ENSEMBL_GRCh38_GTF_BASE=ftp://ftp.ensembl.org/pub/release-${HUMAN_GRCH38_VERSION}/gtf/homo_sapiens

GRCH37_GTF_FILE=Homo_sapiens.GRCh37.${HUMAN_GRCH37_VERSION}.gtf
GRCH38_GTF_FILE=Homo_sapiens.GRCh38.${HUMAN_GRCH38_VERSION}.gtf


DBSNP_RELEASE=144
SNP_FILE=snp${DBSNP_RELEASE}Common.txt
GRCH37_UCSC_COMMON_SNP=http://hgdownload.cse.ucsc.edu/goldenPath/hg19/database/${SNP_FILE}
GRCH38_UCSC_COMMON_SNP=http://hgdownload.cse.ucsc.edu/goldenPath/hg38/database/${SNP_FILE}


HISAT2_BUILD_EXE=hisat2-build
HISAT2_SNP_SCRIPT=hisat2_extract_snps_haplotypes_UCSC.py
HISAT2_SS_SCRIPT=hisat2_extract_splice_sites.py
HISAT2_EXON_SCRIPT=hisat2_extract_exons.py
PICARD_EXE=picard
SAMTOOLS_EXE=samtools
BWA_EXE=bwa
STAR_EXE=STAR

GRCH37_FASTA=Homo_sapiens.GRCh37.${HUMAN_GRCH37_VERSION}.dna.primary_assembly.fa
GRCH38_FASTA=Homo_sapiens.GRCh38.dna.primary_assembly.fa

GRCH37_DICT=Homo_sapiens.GRCh37.${HUMAN_GRCH37_VERSION}.dna.primary_assembly.dict
GRCH38_DICT=Homo_sapiens.GRCh38.dna.primary_assembly.dict
rRNA_INTERVAL_LIST=Homo_sapiens.rRNA.interval_list