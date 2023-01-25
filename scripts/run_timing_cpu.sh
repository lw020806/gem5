#!/bin/bash

protocol=$1
label=$2
size=$3
bench=$4
nnodes=$5
wb_dc=$6


GEM5_DIR=/mnt/storage/qiling/gem5
mkdir -p ${GEM5_DIR}/results/w-prefetcher/
${GEM5_DIR}/build/X86/gem5.opt --outdir=${GEM5_DIR}/results/w-prefetcher/ \
${GEM5_DIR}/configs/example/fs.py \
	-n 8 \
	--cpu-type=X86TimingSimpleCPU \
	--cpu-clock=2.6GHz \
	--caches --l2cache \
	--l1i_size 32kB \
	--l1i_assoc 8 \
	--l1d_size 32kB \
	--l1d_assoc 8 \
	--l1d-hwp-type=StridePrefetcher \
	--l2-hwp-type=StridePrefetcher \
	--kernel=${GEM5_DIR}/kernel/x86-linux-kernel-4.19.83 \
	--disk-image=${GEM5_DIR}/disk-image/spec-2017/spec-2017-image-foto/spec-2017 \
	--mem-type=DDR4_2400_16x4 \
	--mem-size=16GB \
	--maxinsts=1000000000 \
	--script=${GEM5_DIR}/scripts/readfile \
	--restore-with-cpu=X86KvmCPU \
	--checkpoint-restore=1 \
	--checkpoint-dir=${GEM5_DIR}/checkpoints/foto/ \
