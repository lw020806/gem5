#!/bin/bash

num_core=$1
prefetcher_mode=$2
max_insts=$3
ckpt_dir=$4
OUT_DIR=$5


echo "configurations:"
echo "num_core: ${num_core}"
echo "prefetcher_mode: ${prefetcher_mode}"
echo "max_insts: ${max_insts}"
echo "ckpt_dir: ${ckpt_dir}"
echo "OUT_DIR: ${OUT_DIR}"

if [[ ${prefetcher_mode} == "disable_pf" ]];
then
	pf_argu=""
elif [[ ${prefetcher_mode} == "enable_pf" ]];
then
	pf_argu="--l1d-hwp-type=StridePrefetcher --l2-hwp-type=StridePrefetcher"
else
	echo "invalid prefetcher flat"
	exit 1
fi


GEM5_DIR=/mnt/storage/qiling/gem5
mkdir -p ${GEM5_DIR}/${OUT_DIR}
${GEM5_DIR}/build/X86/gem5.opt \
	--outdir=${GEM5_DIR}/${OUT_DIR} \
	--debug-flags=HWPrefetch \
${GEM5_DIR}/configs/example/fs.py \
	--num-cpus=${num_core} \
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
	--script=${GEM5_DIR}/scripts/readfile \
	--restore-with-cpu=X86KvmCPU \
	--checkpoint-restore=3 \
	--checkpoint-dir=${GEM5_DIR}/${ckpt_dir} \
	${pf_argu} \
