#!/bin/bash
GEM5_DIR=/mnt/storage/qiling/gem5

max_insts=$1
ckpt_dir=$2
OUT_DIR=$3
prefetcher_mode=$4
echo "649.fotonik3d_s ref nullptr" > ${GEM5_DIR}/scripts/readfile_timing

echo "configurations:"
echo "prefetcher_mode: ${prefetcher_mode}"
echo "max_insts: ${max_insts}"
echo "ckpt_dir: ${ckpt_dir}"
echo "OUT_DIR: ${OUT_DIR}"

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
	echo "invalid prefetcher flat"
	exit 1
fi


mkdir -p ${GEM5_DIR}/${OUT_DIR}
${GEM5_DIR}/build/X86_flushing/gem5.opt \
	--outdir=${GEM5_DIR}/${OUT_DIR} \
${GEM5_DIR}/configs/example/fs.py \
	--num-cpus=2 \
	--cpu-type=X86TimingSimpleCPU \
	--cpu-clock=2.6GHz \
	--caches --l2cache \
	--l1i_size 32kB \
	--l1i_assoc 8 \
	--l1d_size 32kB \
	--l1d_assoc 8 \
	--kernel=${GEM5_DIR}/kernel/x86-linux-kernel-4.19.83 \
	--disk-image=${GEM5_DIR}/disk-image/spec-2017/spec-2017-image-foto/spec-2017 \
	--mem-type=DDR4_2400_16x4 \
	--mem-size=16GB \
	--maxinsts=${max_insts} \
	--script=${GEM5_DIR}/scripts/readfile_timing \
	--restore-with-cpu=X86KvmCPU \
	--checkpoint-restore=3 \
	--checkpoint-dir=${GEM5_DIR}/${ckpt_dir} \
	${pf_argu} \
