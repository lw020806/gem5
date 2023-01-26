#!/bin/bash

gem5_dir=/mnt/storage/qiling/gem5
pf_modes=("enable_pf" "flush_pf" "disable_pf")
# pf_modes=("flush_pf")
max_insts=1000000000
ckpt_dir=checkpoints/foto/2-cores

for pf_mode in ${pf_modes[@]}; do
	bash ${gem5_dir}/scripts/run_timing_cpu.sh ${max_insts} ${ckpt_dir} results/${pf_mode} ${pf_mode}
done

