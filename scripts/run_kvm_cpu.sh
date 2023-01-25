#!/bin/bash
GEM5_DIR=/mnt/storage/qiling/gem5
${GEM5_DIR}/build/X86/gem5.opt ${GEM5_DIR}/configs/example/fs.py \
--kernel=${GEM5_DIR}/kernel/x86-linux-kernel-4.19.83 \
--disk-image=${GEM5_DIR}/disk-image/spec-2017/spec-2017-image-foto-wo-reset/spec-2017 \
--cpu-type=X86KvmCPU \
--cpu-clock=2.6GHz \
-n 2 \
--command-line="earlyprintk=ttyS0 console=ttyS0 lpj=10400000 root=/dev/hda1 numa=fake=2 nr_cpus=2" \
--mem-size=16GB \
--script=${GEM5_DIR}/scripts/readfile \
--take-checkpoints=300000000000000,50000000000000 \
--checkpoint-at-end \
--max-checkpoints=10 \
--checkpoint-dir=${GEM5_DIR}/checkpoints/foto/2-cores \
