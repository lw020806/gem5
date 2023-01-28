#!/bin/bash

statFile=$1
matrices=("simSeconds" "simInsts" "system.switch_cpus.\.numCycles" "system.switch_cpus.\.exec_context.thread_.\.numInsts" "system.cpu.\.dcache.overallMisses::switch_cpus.\.data" "system.l2.overallMisses::switch_cpus.\.data" "accuracy" "coverage" "dcache.prefetcher.pfIssued")

for matrix in ${matrices[@]}; do
	cat ${statFile} | grep ${matrix}
done

