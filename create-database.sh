#!/usr/bin/env bash

# Human
# This bash script would create both hg19 and grch38 versions' general databases

# 1. reference fasta file
# 2. rRNA interval_list file
# 3. GTF file
# 4. gene ref flat file
# 5. GATK reference dict file
# 6. bwa reference index
# 7. hisat2 reference index
# 8. samtools reference index
# 9. to be continued.

if [[ $1 == 'test' ]]; then
    istest = 1
fi

set -e
source $(dirname $0)/config.sh



get() {
	file=$1
	if ! wget --version >/dev/null 2>/dev/null ; then
		if ! curl --version >/dev/null 2>/dev/null ; then
			echo "Please install wget or curl somewhere in your PATH"
			exit 1
		fi
		curl -o `basename $1` $1
		return $?
	else
		wget $1
		return $?
	fi
}

set -x

mkdir -p ${DATABASE_DIR}/human/GRCH37  ${DATABASE_DIR}/human/GRCH38

cd ${DATABASE_DIR}/human/GRCH37

echo "GRCH37"

if [ ! -f ${GRCH37_FASTA} ] ; then
	get ${ENSEMBL_GRCh37_BASE}/${GRCH37_FASTA}.gz || (echo "Error getting ${GRCH37_FASTA}" && exit 1)
	gunzip ${GRCH37_FASTA}.gz || (echo "Error unzipping ${GRCH37_FASTA}" && exit 1)
fi


if [ ! -f $SNP_FILE ] ; then
       get ${GRCH37_UCSC_COMMON_SNP}.gz || (echo "Error getting ${GRCH37_UCSC_COMMON_SNP}" && exit 1)
       gunzip ${SNP_FILE}.gz || (echo "Error unzipping ${SNP_FILE}" && exit 1)
       awk 'BEGIN{OFS="\t"} {if($2 ~ /^chr/) {$2 = substr($2, 4)}; if($2 == "M") {$2 = "MT"} print}' ${SNP_FILE} > ${SNP_FILE}.tmp
       mv ${SNP_FILE}.tmp ${SNP_FILE}
       ${HISAT2_SNP_SCRIPT} ${GRCH37_FASTA} ${SNP_FILE} genome
fi

if [ ! -f ${FLAT_FILE} ] ; then
        get ${FLAT_GRCH37} || (echo "Error getting ${FLAT_FILE}" && exit 1)
        gunzip ${FLAT_FILE}.gz || (echo "Error unzipping ${FLAT_FILE}" && exit 1)
fi


if [ ! -f ${GRCH37_GTF_FILE} ] ; then
       get ${ENSEMBL_GRCh37_GTF_BASE}/${GRCH37_GTF_FILE}.gz || (echo "Error getting ${GRCH37_GTF_FILE}" && exit 1)
       gunzip ${GRCH37_GTF_FILE}.gz || (echo "Error unzipping ${GRCH37_GTF_FILE}" && exit 1)
       ${HISAT2_SS_SCRIPT} ${GRCH37_GTF_FILE} > genome.ss
       ${HISAT2_EXON_SCRIPT} ${GRCH37_GTF_FILE} > genome.exon
fi

CMD="${HISAT2_BUILD_EXE} -p 4 ${GRCH37_FASTA} --snp genome.snp --haplotype genome.haplotype --ss genome.ss --exon genome.exon hisat2_index/genome"
echo Running ${CMD}

if $CMD ; then
	echo "genome index built; you may remove fasta files"
else
	echo "Index building failed; see error message"
fi


${PICARD_EXE} CreateSequenceDictionary R=${GRCH37_FASTA} O=${GRCH37_DICT}
cp ${GRCH37_DICT} ${rRNA_INTERVAL_LIST}


# Intervals for rRNA transcripts.
grep 'gene_type "rRNA"'  ${GRCH37_GTF_FILE} | awk '$3 == "transcript"' | cut -f1,4,5,7,9 | \
    perl -lane '
        /transcript_id "([^"]+)"/ or die "no transcript_id on $.";
        print join "\t", (@F[0,1,2,3], $1)
    ' | \
    sort -k1V -k2n -k3n >> ${rRNA_INTERVAL_LIST}

${BWA_EXE} index ${GRCH37_FASTA}
${SAMTOOLS_EXE} faidx ${GRCH37_FASTA}

if [[ ${istest} == 1 ]]; then
    rm -rf genome* hisat* Homo*
fi

cd ${DATABASE_DIR}/human/GRCH38

echo "GRCH38"

if [ ! -f ${GRCH38_FASTA} ] ; then
	get ${ENSEMBL_GRCh38_BASE}/${GRCH38_FASTA}.gz || (echo "Error getting ${GRCH38_FASTA}" && exit 1)
	gunzip ${GRCH38_FASTA}.gz || (echo "Error unzipping ${GRCH38_FASTA}" && exit 1)
fi


if [ ! -f $SNP_FILE ] ; then
       get ${GRCH38_UCSC_COMMON_SNP}.gz || (echo "Error getting ${GRCH38_UCSC_COMMON_SNP}" && exit 1)
       gunzip ${SNP_FILE}.gz || (echo "Error unzipping ${SNP_FILE}" && exit 1)
       awk 'BEGIN{OFS="\t"} {if($2 ~ /^chr/) {$2 = substr($2, 4)}; if($2 == "M") {$2 = "MT"} print}' ${SNP_FILE} > ${SNP_FILE}.tmp
       mv ${SNP_FILE}.tmp ${SNP_FILE}
       ${HISAT2_SNP_SCRIPT} ${GRCH38_FASTA} ${SNP_FILE} genome
fi

if [ ! -f ${FLAT_FILE} ] ; then
        get ${FLAT_GRCH38} || (echo "Error getting ${FLAT_FILE}" && exit 1)
        gunzip ${FLAT_FILE}.gz || (echo "Error unzipping ${FLAT_FILE}" && exit 1)
fi


if [ ! -f ${GRCH38_GTF_FILE} ] ; then
       get ${ENSEMBL_GRCh38_GTF_BASE}/${GRCH38_GTF_FILE}.gz || (echo "Error getting ${GRCH38_GTF_FILE}" && exit 1)
       gunzip ${GRCH38_GTF_FILE}.gz || (echo "Error unzipping ${GRCH38_GTF_FILE}" && exit 1)
       ${HISAT2_SS_SCRIPT} ${GRCH38_GTF_FILE} > genome.ss
       ${HISAT2_EXON_SCRIPT} ${GRCH38_GTF_FILE} > genome.exon
fi

CMD="${HISAT2_BUILD_EXE} -p 4 ${GRCH38_FASTA} --snp genome.snp --haplotype genome.haplotype --ss genome.ss --exon genome.exon hisat2_index/genome"
echo Running ${CMD}

if $CMD ; then
	echo "genome index built; you may remove fasta files"
else
	echo "Index building failed; see error message"
fi


${PICARD_EXE} CreateSequenceDictionary R=${GRCH38_FASTA} O=${GRCH38_DICT}
cp ${GRCH38_DICT} ${rRNA_INTERVAL_LIST}


# Intervals for rRNA transcripts.
grep 'gene_type "rRNA"'  ${GRCH38_GTF_FILE} | awk '$3 == "transcript"' | cut -f1,4,5,7,9 | \
    perl -lane '
        /transcript_id "([^"]+)"/ or die "no transcript_id on $.";
        print join "\t", (@F[0,1,2,3], $1)
    ' | \
    sort -k1V -k2n -k3n >> ${rRNA_INTERVAL_LIST}

${BWA_EXE} index ${GRCH38_FASTA}
${SAMTOOLS_EXE} faidx ${GRCH38_FASTA}