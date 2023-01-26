#!/bin/bash
GEM5_DIR=/mnt/storage/qiling/gem5

# test size: 2B instructions
max_insts=2000000000
pf_modes=("enable_pf" "flush_pf" "disable_pf")
benchmarks=("600.perlbench_s" "602.gcc_s" "605.mcf_s" "620.omnetpp_s" "623.xalancbmk_s" "625.x264_s" "631.deepsjeng_s" "641.leela_s" "648.exchange2_s" "657.xz_s" "603.bwaves_s" "607.cactuBSSN_s" "619.lbm_s" "621.wrf_s" "627.cam4_s" "628.pop2_s" "638.imagick_s" "644.nab_s" "649.fotonik3d_s" "654.roms_s")

for benchmark in ${benchmarks[@]}; do
	for pf_mode in ${pf_modes[@]}; do
		OUT_DIR=results/spec2017/${benchmark}/${pf_mode}
		bash ${GEM5_DIR}/scripts/run_timing_cpu.sh ${OUT_DIR} ${benchmark} ${max_insts} ${pf_mode} &
	done
	wait
done

