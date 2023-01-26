#!/bin/bash
GEM5_DIR=/mnt/storage/qiling/gem5
CKPT_DIR=checkpoints/boot

OUT_DIR=$1
benchmark=$2
max_insts=$3
prefetcher_mode=$4

mkdir -p ${GEM5_DIR}/${OUT_DIR}
echo "${benchmark} ref nullptr" > ${GEM5_DIR}/${OUT_DIR}/readfile

if [[ ${prefetcher_mode} == "disable_pf" ]];
then
	pf_argu=""
elif [[ ${prefetcher_mode} == "enable_pf" ]];
then
	pf_argu="--l1d-hwp-type=StridePrefetcher --hwp-counter-bits=2 --hwp-initial-confidence=1 --hwp-confidence-threshold=50 --hwp-degree=4 --hwp-table-assoc=32 --hwp-table-entries=32"
elif [[ ${prefetcher_mode} == "flush_pf" ]];
then
	pf_argu="--l1d-hwp-type=StridePrefetcher --l1d-hwp-flush-interval=10us --hwp-counter-bits=2 --hwp-initial-confidence=1 --hwp-confidence-threshold=50 --hwp-degree=4 --hwp-table-assoc=32 --hwp-table-entries=32"
else
	echo "invalid prefetcher flag"
	exit 1
fi

echo -n `date "+%T"`
echo "  Starting: ${benchmark}---${prefetcher_mode}---${max_insts}"

${GEM5_DIR}/build/X86_flushing/gem5.fast \
	--outdir=${GEM5_DIR}/${OUT_DIR} \
	--redirect-stdout --stdout-file=${GEM5_DIR}/${OUT_DIR}/simout \
${GEM5_DIR}/configs/example/fs.py \
	--kernel=${GEM5_DIR}/kernel/x86-linux-kernel-4.19.83 \
	--disk-image=${GEM5_DIR}/disk-image/spec-2017/spec-2017-image-all/spec-2017 \
	--script=${GEM5_DIR}/${OUT_DIR}/readfile \
	--num-cpus=2 \
	--cpu-type=X86TimingSimpleCPU \
	--cpu-clock=2.6GHz \
	--caches --l2cache \
	--l1i_size 32kB \
	--l1i_assoc 8 \
	--l1d_size 32kB \
	--l1d_assoc 8 \
	${pf_argu} \
	--mem-type=DDR4_2400_16x4 \
	--mem-size=16GB \
	--checkpoint-dir=${GEM5_DIR}/${CKPT_DIR} \
	--checkpoint-restore=1 \
	--restore-with-cpu=X86KvmCPU \
	--fast-forward-after-restore=500000000000 \
	--maxinsts=${max_insts} \

echo -n `date "+%T"`
echo "  Ending: ${benchmark}---${prefetcher_mode}---${max_insts}"
