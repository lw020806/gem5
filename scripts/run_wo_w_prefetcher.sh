#!/bin/bash

num_core=2
pf_modes=("disable_pf" "enable_pf")
max_insts=1000000000
ckpt_dir=checkpoints/foto/2-cores

for pf_mode in ${pf_modes[@]}; do
	echo "${num_core} ${pf_mode} ${max_insts} ${ckpt_dir}"
done

