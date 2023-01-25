#!/bin/bash

gem5_dir=/mnt/storage/qiling/gem5
num_core=2
#pf_modes=("disable_pf" "enable_pf")
pf_modes=("flush_pf")
max_insts=1000000000
ckpt_dir=checkpoints/foto/2-cores

for pf_mode in ${pf_modes[@]}; do
	bash ${gem5_dir}/scripts/run_timing_cpu.sh ${num_core} ${pf_mode} ${max_insts} ${ckpt_dir} results/${pf_mode}
done

