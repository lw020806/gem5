#!/bin/bash
GEM5_DIR=/mnt/storage/qiling/gem5

echo "null null null" > ${GEM5_DIR}/scripts/readfile_kvm
CKPT_DIR=${GEM5_DIR}/checkpoints/boot

${GEM5_DIR}/build/X86_flushing/gem5.fast ${GEM5_DIR}/configs/example/fs.py \
--kernel=${GEM5_DIR}/kernel/x86-linux-kernel-4.19.83 \
--command-line="earlyprintk=ttyS0 console=ttyS0 lpj=10400000 root=/dev/hda1 numa=fake=2 nr_cpus=2" \
--disk-image=${GEM5_DIR}/disk-image/spec-2017/spec-2017-image-all/spec-2017 \
--script=${GEM5_DIR}/scripts/readfile_kvm \
--cpu-type=X86KvmCPU \
--cpu-clock=2.6GHz \
--num-cpus=2 \
--mem-size=16GB \
--checkpoint-dir=${CKPT_DIR} \
--max-checkpoint=1 \
