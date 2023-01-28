import subprocess
import matplotlib.pyplot as plt
import numpy as np

pf_modes=["disable_pf", "enable_pf", "flush_pf"]
benchmarks=["602.gcc_s", "605.mcf_s", "623.xalancbmk_s", "649.fotonik3d_s"]

data = {}
for benchmark in benchmarks :
	results = []
	for pf_mode in pf_modes :
		cmd = ["bash", "extract.sh"]
		cmd.append(benchmark + "/" + pf_mode + "/stats.txt")
		results.append(subprocess.run(cmd, capture_output=True).stdout.decode())
	
	data[benchmark] = {}
	for i in range(3) :
		result = results[i].split('\n')
		thisData = {}
		thisData["cycles"] = max(int(result[2].split()[1]), int(result[3].split()[1]))
		thisData["insts"] = int(result[4].split()[1]) + int(result[5].split()[1])
		thisData["misses"] = int(result[8].split()[1]) + int(result[9].split()[1])
		if i > 0 :
			thisData["accuracy"] = (float(result[10].split()[1]) + float(result[11].split()[1])) / 2
			thisData["coverage"] = (float(result[12].split()[1]) + float(result[13].split()[1])) / 2
		thisData["ipc"] = thisData["insts"] / thisData["cycles"]
		thisData["mpki"] = thisData["misses"] / (thisData["insts"] / 1000)
		data[benchmark][pf_modes[i]] = thisData

# plot normalized IPC
barWidth = 0.25
ipcFig = plt.subplots(figsize = (16, 8))

ipcData = {}
degrade = []
for pf_mode in pf_modes :
	ipcData[pf_mode] = []
for benchmark in benchmarks :
	thisData = data[benchmark]
	for pf_mode in pf_modes :
		ipcData[pf_mode].append(thisData[pf_mode]["ipc"] / thisData["disable_pf"]["ipc"])
	degrade.append(1-thisData["flush_pf"]["ipc"]/thisData["enable_pf"]["ipc"])
print("IPC degradation: ", list(zip(benchmarks, degrade)))
print("IPC degradation avg:", sum(degrade)/len(benchmarks))

bar_pos = {}
bar_pos["disable_pf"] = np.arange(len(ipcData["disable_pf"]))
bar_pos["enable_pf"] = [ x + barWidth for x in bar_pos["disable_pf"]]
bar_pos["flush_pf"] = [ x + barWidth for x in bar_pos["enable_pf"]]
colors = {}
colors["disable_pf"] = '#038C8C'
colors["enable_pf"] = '#00688B'
colors["flush_pf"] = '#F21905'
for pf_mode in pf_modes :
	plt.bar(bar_pos[pf_mode], ipcData[pf_mode], color=colors[pf_mode],edgecolor='black', width=barWidth-0.03, label=pf_mode)

plt.xlabel('SPEC2017 benchmarks', fontweight ='bold', fontsize = 15)
plt.ylabel('Normalized IPC', fontweight ='bold', fontsize = 15)
plt.xticks([r + barWidth for r in range(len(ipcData["disable_pf"]))], benchmarks)
plt.grid(color='grey', axis='y', linewidth=0.5, linestyle='--')
plt.legend()
plt.savefig("IPC.png")

# plot normalized MPKI
barWidth = 0.25
mpkiFig = plt.subplots(figsize = (16, 8))

mpkiData = {}
degrade = []
for pf_mode in pf_modes :
	mpkiData[pf_mode] = []
for benchmark in benchmarks :
	thisData = data[benchmark]
	for pf_mode in pf_modes :
		mpkiData[pf_mode].append(thisData[pf_mode]["mpki"] / thisData["disable_pf"]["mpki"])
	degrade.append(1-thisData["flush_pf"]["mpki"]/thisData["enable_pf"]["mpki"])
print("mpki degradation: ", list(zip(benchmarks, degrade)))
print("mpki degradation avg:", sum(degrade)/len(benchmarks))

bar_pos = {}
bar_pos["disable_pf"] = np.arange(len(mpkiData["disable_pf"]))
bar_pos["enable_pf"] = [ x + barWidth for x in bar_pos["disable_pf"]]
bar_pos["flush_pf"] = [ x + barWidth for x in bar_pos["enable_pf"]]
colors = {}
colors["disable_pf"] = '#038C8C'
colors["enable_pf"] = '#00688B'
colors["flush_pf"] = '#F21905'
for pf_mode in pf_modes :
	plt.bar(bar_pos[pf_mode], mpkiData[pf_mode], color=colors[pf_mode],edgecolor='black', width=barWidth-0.03, label=pf_mode)

plt.xlabel('SPEC2017 benchmarks', fontweight ='bold', fontsize = 15)
plt.ylabel('Normalized MPKI', fontweight ='bold', fontsize = 15)
plt.xticks([r + barWidth for r in range(len(mpkiData["disable_pf"]))], benchmarks)
plt.grid(color='grey', axis='y', linewidth=0.5, linestyle='--')
plt.legend()
plt.savefig("MPKI.png")

# plot prefetcher accuracy
barWidth = 0.25
accFig = plt.subplots(figsize = (16, 8))

accData = {}
pf_modes=["enable_pf", "flush_pf"]
for pf_mode in pf_modes :
	accData[pf_mode] = []
for benchmark in benchmarks :
	thisData = data[benchmark]
	for pf_mode in pf_modes :
		accData[pf_mode].append(thisData[pf_mode]["accuracy"])
	degrade.append(1-thisData["flush_pf"]["accuracy"]/thisData["enable_pf"]["accuracy"])
print("accuracy degradation: ", list(zip(benchmarks, degrade)))
print("accuracy degradation avg:", sum(degrade)/len(benchmarks))

bar_pos = {}
bar_pos["enable_pf"] = np.arange(len(accData["enable_pf"]))
bar_pos["flush_pf"] = [ x + barWidth for x in bar_pos["enable_pf"]]
colors = {}
colors["enable_pf"] = '#00688B'
colors["flush_pf"] = '#F21905'
for pf_mode in pf_modes :
	plt.bar(bar_pos[pf_mode], accData[pf_mode], color=colors[pf_mode],edgecolor='black', width=barWidth-0.03, label=pf_mode)

plt.xlabel('SPEC2017 benchmarks', fontweight ='bold', fontsize = 15)
plt.ylabel('Accuracy', fontweight ='bold', fontsize = 15)
plt.xticks([r + barWidth for r in range(len(accData["enable_pf"]))], benchmarks)
plt.grid(color='grey', axis='y', linewidth=0.5, linestyle='--')
plt.legend()
plt.savefig("accuracy.png")

# plot prefetcher coverage
barWidth = 0.25
covFig = plt.subplots(figsize = (16, 8))

covData = {}
pf_modes=["enable_pf", "flush_pf"]
for pf_mode in pf_modes :
	covData[pf_mode] = []
for benchmark in benchmarks :
	thisData = data[benchmark]
	for pf_mode in pf_modes :
		covData[pf_mode].append(thisData[pf_mode]["coverage"])
	degrade.append(1-thisData["flush_pf"]["coverage"]/thisData["enable_pf"]["coverage"])
print("coverage degradation: ", list(zip(benchmarks, degrade)))
print("coverage degradation avg:", sum(degrade)/len(benchmarks))

bar_pos = {}
bar_pos["enable_pf"] = np.arange(len(covData["enable_pf"]))
bar_pos["flush_pf"] = [ x + barWidth for x in bar_pos["enable_pf"]]
colors = {}
colors["enable_pf"] = '#00688B'
colors["flush_pf"] = '#F21905'
for pf_mode in pf_modes :
	plt.bar(bar_pos[pf_mode], covData[pf_mode], color=colors[pf_mode],edgecolor='black', width=barWidth-0.03, label=pf_mode)

plt.xlabel('SPEC2017 benchmarks', fontweight ='bold', fontsize = 15)
plt.ylabel('Coverage', fontweight ='bold', fontsize = 15)
plt.xticks([r + barWidth for r in range(len(covData["enable_pf"]))], benchmarks)
plt.grid(color='grey', axis='y', linewidth=0.5, linestyle='--')
plt.legend()
plt.savefig("coverage.png")
