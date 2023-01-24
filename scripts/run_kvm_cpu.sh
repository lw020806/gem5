#!/bin/bash
GEM5_DIR=/mnt/storage/qiling/gem5
${GEM5_DIR}/build/X86/gem5.opt ${GEM5_DIR}/configs/example/fs.py \
--kernel=${GEM5_DIR}/kernel/x86-linux-kernel-4.19.83 \
--disk-image=${GEM5_DIR}/disk-image/spec-2017/spec-2017-image/spec-2017 \
--cpu-type=X86KvmCPU \
--cpu-clock=2.6GHz \
-n 8 \
--command-line="earlyprintk=ttyS0 console=ttyS0 lpj=10400000 root=/dev/hda2 numa=fake=2 nr_cpus=8" \
--mem-size=16GB
