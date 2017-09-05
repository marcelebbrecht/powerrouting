#!/bin/bash
# PowerRouting for OMNeT++ - runfile linux
# Marcel Ebbrecht, marcel.ebbrecht@googlemail.com
# free software, see LICENSE.md for details

# Warning, written by a "dont-care" bash-hacker with
# a bad attitude - dirty but worky, sorry guys, I
# don't like bash - I love it! So dont study the 
# following code, it will harm your coding skills.
# You habe been warned ;)

### settings - must set ###
# gnuplot path for exporting graphs to png files
# please also set path in subs.pl for perl
GNUPLOT="gnuplot"

# perl path for cleaning and preparing data
PERL="perl"

# inetmanet name in workspace
INETMANET="inetmanet-3.x"

# use dialog for status (yes,no)
DIALOG="no"

### settings - may set ###
# substract from available cores (number >= 0)
COREBIAS=0

# delete elog files (yes,no)
DELETELOGS="yes"

# delete run log files (yes,no)
DELETERUNLOGS="yes"

# delete rt files (yes,no)
DELETERTS="yes"

# delete csv files (yes,no) after study
DELETECSV="no"

# delete results files sca/vci/vec (yes,no) after study
DELETERESULTS="no"

# decimal places for comparision
DECIMALPLACES="5"

# dropout interval in csv
DROPOUT="3"

# timelimit for shorter analysis
SHORTTIME="60"

# confidence for statistics
CONFIDENCE="95"

# interpolate parameter for 3d plots
INTERPOLATE="10"

### functions ###		
# get repeat
# R: NUMBEROFREPETITIONS (number)
function getRepeat {
	if [ $(grep "repeat" ./common.ini | grep "=" | cut -d "=" -f 2 | wc -l) -eq 1 ]; then
		grep "repeat" ./common.ini | grep "=" | cut -d "=" -f 2 | sed 's/ //g'
	else
		echo 1
	fi
}  
	  
# get simulation time
# R: SIMULATIONTIME (number)
function getSimTime {
	if [ $(grep "sim-time-limit" ./common.ini | grep "=" | cut -d "=" -f 2 | wc -l) -eq 1 ]; then
		grep "sim-time-limit" ./common.ini | grep "=" | cut -d "=" -f 2 | sed 's/ //g' | sed 's/s//g'
	else
		echo 1
	fi
}

# estimating thread-count
# 1: verbose (if wanted)
# R: NUMBEROFTHREADS (number)
function estimateThreads {
	CPUCOUNT=$(($(cat /proc/cpuinfo | grep processor | wc -l)-$COREBIAS))
	if [ $CPUCOUNT -le 0 ]; then CPUCOUNT = 1; fi
		if [[ $1 =~ "verbose" ]]; then
		echo
		echo "switching to single thread mode (verbose)"
		CPUCOUNT=1
	else
		echo
		echo "running with $CPUCOUNT threads"
	fi
}

# remove logfiles: elog and rt
# 1: Name of files to remove (string)
function cleanLogs {
	echo
	if [[ "$DELETELOGS" =~ "yes" ]]; then
		echo "Removing elog files."
		rm ./results/*.elog > /dev/null 2>&1
	fi
	if [[ "$DELETERUNLOGS" =~ "yes" ]]; then
		echo "Removing runlog files."
		rm ./logs/*.log > /dev/null 2>&1
	fi
	if [[ "$DELETERTS" =~ "yes" ]]; then
		echo "Removing rt files."
		rm ./results/*.rt > /dev/null 2>&1
	fi
}

# remove logfiles: csv, vec, sca, vci
# 1: First part of name of files to remove (string)
function cleanFiles {
	echo
	if [[ "$DELETECSV" =~ "yes" ]]; then
		echo "Removing csv files."
		rm ./results/$1*.csv > /dev/null 2>&1
	fi
	if [[ "$DELETERESULTS" =~ "yes" ]]; then
		echo "Removing result files."
		rm ./results/$1*.vec > /dev/null 2>&1
		rm ./results/$1*.sca > /dev/null 2>&1
		rm ./results/$1*.vci > /dev/null 2>&1
	fi
}

# wait until last opp_run is finished
function waitForFinish {
	sleep 1
	while [ $(ps aux | grep opp | grep -v grep | wc -l) -ge 1 ]; do sleep 1; done
	while [ $(ps aux | grep opp | grep -v grep | wc -l) -ge 1 ]; do sleep 1; done
	while [ $(ps aux | grep opp | grep -v grep | wc -l) -ge 1 ]; do sleep 1; done
	while [ $(ps aux | grep scavetool | grep -v grep | wc -l) -ge 1 ]; do sleep 1; done
	while [ $(ps -s | grep perl | grep -v grep | wc -l) -ge 1 ]; do sleep 1; done
	while [ $(ps -s | grep gnuplot | grep -v grep | wc -l) -ge 1 ]; do sleep 1; done
}

# wait until last opp_run is finished
function waitForFinishScave {
	sleep 0.1
	while [ $(ps aux | grep scave | grep -v grep | wc -l) -ge 1 ]; do sleep 1; done
}

# wait for free slot (num of runnung processes < CPUCOUNT)
function waitForFreeSlot {
	sleep 1
	while [ $(ps aux | grep opp | grep -v grep | wc -l) -ge $CPUCOUNT ]; do sleep 1; done	
	while [ $(ps aux | grep opp | grep -v grep | wc -l) -ge $CPUCOUNT ]; do sleep 1; done	
	while [ $(ps aux | grep opp | grep -v grep | wc -l) -ge $CPUCOUNT ]; do sleep 1; done	
}

# wait until last opp_run is finished
function waitForFinishGnuplot {
	sleep 0.1
	while [ $(ps aux | grep gnuplot | grep -v grep | wc -l) -ge 1 ]; do sleep 1; done
}

# wait for free slot (num of runnung processes < CPUCOUNT)
function waitForFreeSlotPlot {
	while [ $(ps aux | grep scavetool | grep -v grep | wc -l) -ge $CPUCOUNT ]; do sleep 1; done	
	while [ $(ps -s | grep perl | grep -v grep | wc -l) -ge $CPUCOUNT ]; do sleep 1; done
	while [ $(ps -s | grep gnuplot | grep -v grep | wc -l) -ge $CPUCOUNT ]; do sleep 1; done
}

# wait for free slot (num of runnung processes < CPUCOUNT)
function waitForFreeSlotScave {
	while [ $(ps aux | grep scave | grep -v grep | wc -l) -ge $CPUCOUNT ]; do sleep 1; done  
}

# run simulation
# 1: CONFIGFILE (filename)
# 2: CONFIGNAME (name)
# 3: verbose (if wanted)
function runSimulation {
	REPEAT=$(getRepeat)
	if [[ $3 =~ "verbose" ]]; then
		N=0
		while [ $N -lt $REPEAT ]; do
			waitForFreeSlot
			echo "    simulation: $2, run $(($N+1)) of $REPEAT"
			opp_run -r $N -m -u Cmdenv \
				-n "../src;../simulations;../../$INETMANET/examples;../../$INETMANET/showcases;../../$INETMANET/src;../../$INETMANET/tutorials" --image-path=../../$INETMANET/images \
				-l ../src/powerrouting \
				-c $2 ../simulations/$1 2>&1 | tee logs/$2-$N.log &
			N=$(($N+1))
		done
	else
		N=0
		while [ $N -lt $REPEAT ]; do
			waitForFreeSlot
			if [[ "$DIALOG" =~ "yes" ]]; then
				echo $(($(($N+1))*100/$(($REPEAT+1)))) | dialog --gauge "Simulation: $2, run $(($N+1)) of $REPEAT" 10 70 0
			else
				echo "    simulation: $2, run $(($N+1)) of $REPEAT"
			fi
			opp_run -r $N -m -u Cmdenv \
				-n "../src;../simulations;../../$INETMANET/examples;../../$INETMANET/showcases;../../$INETMANET/src;../../$INETMANET/tutorials" --image-path=../../$INETMANET/images \
				-l ../src/powerrouting \
				-c $2 ../simulations/$1 > logs/$2-$N.log 2>&1 &
				#-l ../src/powerrouting \
			N=$(($N+1))
		done
	fi
	cleanLog $2 > /dev/null 2>&1
}

# plot simulation
# 1: CONFIGNAME (name)
function plotSimulation {
	REPEAT=$(getRepeat)
	N=0
	mkdir -p ./export/$1/CapacityOverTime/Full > /dev/null 2>&1
	mkdir -p ./export/$1/CapacityOverTime/Short > /dev/null 2>&1
	mkdir -p ./export/$1/CapacityAtEnd/Full > /dev/null 2>&1
	mkdir -p ./export/$1/CapacityAtEnd/Short > /dev/null 2>&1
	rm ./export/$1/CapacityOverTime/Full > /dev/null 2>&1
	rm ./export/$1/CapacityOverTime/Short > /dev/null 2>&1
	rm ./export/$1/CapacityAtEnd/Full > /dev/null 2>&1
	rm ./export/$1/CapacityAtEnd/Short > /dev/null 2>&1
	while [ $N -lt $REPEAT ]; do
		waitForFreeSlotPlot
		echo "    plot: $1, run $(($N+1)) of $REPEAT"
		plotOne "$1-#$N" &
		N=$(($N+1))
	done
}

# plot simulation for complete protocol
# 1: CONFIGNAME (name)
function plotSimulationProtocol {
	mkdir -p ./export/Summary/CapacityAtEnd/Full > /dev/null 2>&1
	mkdir -p ./export/Summary/CapacityAtEnd/Short > /dev/null 2>&1
	mkdir -p ./export/Summary/UdpPacketLoss/Full > /dev/null 2>&1
	mkdir -p ./export/Summary/UdpPacketLoss/Short > /dev/null 2>&1
	mkdir -p ./export/Summary/Performance/Full > /dev/null 2>&1
	mkdir -p ./export/Summary/Performance/Short > /dev/null 2>&1
	mkdir -p ./export/Summary/CapacityAtEndConfidence/Full > /dev/null 2>&1
	mkdir -p ./export/Summary/CapacityAtEndConfidence/Short > /dev/null 2>&1
	mkdir -p ./export/Summary/UdpPacketLossConfidence/Full > /dev/null 2>&1
	mkdir -p ./export/Summary/UdpPacketLossConfidence/Short > /dev/null 2>&1
	mkdir -p ./export/Summary/PerformanceConfidence/Full > /dev/null 2>&1
	mkdir -p ./export/Summary/PerformanceConfidence/Short > /dev/null 2>&1
	rm ./export/Summary/CapacityAtEnd/Full/$1* > /dev/null 2>&1
	rm ./export/Summary/CapacityAtEnd/Short/$1* > /dev/null 2>&1
	rm ./export/Summary/UdpPacketLoss/Full/$1* > /dev/null 2>&1
	rm ./export/Summary/UdpPacketLoss/Short/$1* > /dev/null 2>&1
	rm ./export/Summary/Performance/Full/$1* > /dev/null 2>&1
	rm ./export/Summary/Performance/Short/$1* > /dev/null 2>&1
	rm ./export/Summary/CapacityAtEndConfidence/Full/$1* > /dev/null 2>&1
	rm ./export/Summary/CapacityAtEndConfidence/Short/$1* > /dev/null 2>&1
	rm ./export/Summary/UdpPacketLossConfidence/Full/$1* > /dev/null 2>&1
	rm ./export/Summary/UdpPacketLossConfidence/Short/$1* > /dev/null 2>&1
	rm ./export/Summary/PerformanceConfidence/Full/$1* > /dev/null 2>&1
	rm ./export/Summary/PerformanceConfidence/Short/$1* > /dev/null 2>&1
	echo "    plot: $1 protocol comparision"	
	declare -a protocolArray=("${!2}")
	plotProtocol $1 $(getRepeat) protocolArray[@] &
}

# plot simulation for compare protocols
# 1: CONFIGNAME (name)
function compareProtocols {
	mkdir -p ./export/Compare/CapacityAtEnd/Full > /dev/null 2>&1
	mkdir -p ./export/Compare/CapacityAtEnd/Short > /dev/null 2>&1
	mkdir -p ./export/Compare/UdpPacketLoss/Full > /dev/null 2>&1
	mkdir -p ./export/Compare/UdpPacketLoss/Short > /dev/null 2>&1
	mkdir -p ./export/Compare/Performance/Full > /dev/null 2>&1
	mkdir -p ./export/Compare/Performance/Short > /dev/null 2>&1
	mkdir -p ./export/Compare/CapacityAtEndConfidence/Full > /dev/null 2>&1
	mkdir -p ./export/Compare/CapacityAtEndConfidence/Short > /dev/null 2>&1
	mkdir -p ./export/Compare/UdpPacketLossConfidence/Full > /dev/null 2>&1
	mkdir -p ./export/Compare/UdpPacketLossConfidence/Short > /dev/null 2>&1
	mkdir -p ./export/Compare/PerformanceConfidence/Full > /dev/null 2>&1
	mkdir -p ./export/Compare/PerformanceConfidence/Short > /dev/null 2>&1
	rm ./export/Compare/CapacityAtEnd/Full/* > /dev/null 2>&1
	rm ./export/Compare/CapacityAtEnd/Short/* > /dev/null 2>&1
	rm ./export/Compare/UdpPacketLoss/Full/* > /dev/null 2>&1
	rm ./export/Compare/UdpPacketLoss/Short/* > /dev/null 2>&1
	rm ./export/Compare/Performance/Full/* > /dev/null 2>&1
	rm ./export/Compare/Performance/Short/* > /dev/null 2>&1
	rm ./export/Compare/CapacityAtEndConfidence/Full/* > /dev/null 2>&1
	rm ./export/Compare/CapacityAtEndConfidence/Short/* > /dev/null 2>&1
	rm ./export/Compare/UdpPacketLossConfidence/Full/* > /dev/null 2>&1
	rm ./export/Compare/UdpPacketLossConfidence/Short/* > /dev/null 2>&1
	rm ./export/Compare/PerformanceConfidence/Full/* > /dev/null 2>&1
	rm ./export/Compare/PerformanceConfidence/Short/* > /dev/null 2>&1
	echo "    plot: $1 protocol comparision"	
	declare -a protocolArray=("${!2}")
	scavetool scalar -p '(module(*sender*udpApp[0]) AND name(sentPk:count)) OR (module(*receiver*udpApp[0]) AND name(rcvdPk:count))' -O results/AODV-OLSR-UDPStats.csv -F csv results/AODV-*.sca results/AODVPO-*.sca results/AODVPOT*.sca results/OLSRPO-*.sca  results/OLSR-*.sca  results/OLSRPOT*.sca > /dev/null 2>&1
	$PERL plot.pl compareProtocols $1 $(getRepeat) $CONFIDENCE $SHORTTIME $(getSimTime) ${protocolArray[@]}
}

# run simulation part of study
# 1: CONFIGFILE (filename)
# 2: CONFIGNAME (name)
# 3: NUMBEROFRUN (number)
# 4: NUMBEROFALLRUNS (number) 
function runStudySimulation {
	waitForFreeSlot
	if [[ "$DIALOG" =~ "yes" ]]; then
		echo $(($(($3+1))*100/$(($4+2)))) | dialog --gauge "Simulation: $2 ($(($3+1)) of $(($4+1)), log: logs/$2-$3.log)" 10 70 0
	else
		echo "    simulation: $2 ($(($3+1)) of $(($4+1)), log: logs/$2-$3.log)"
	fi
	opp_run -r $3 -m -u Cmdenv \
		-n "../src;../simulations;../../$INETMANET/examples;../../$INETMANET/showcases;../../$INETMANET/src;../../$INETMANET/tutorials" --image-path=../../$INETMANET/images \
		-l ../src/powerrouting \
		-c $2 ../simulations/$1 > logs/$2-$3.log 2>&1 &
	cleanLog $2 > /dev/null 2>&1
}

# output before run
# 1: SIMULATIONNAME (string)
# R: ECHO TEXT (output)
function runPreamble { 
	echo
	echo "running $1 simulations, please wait ..."
}

# output after run
# 1: SIMULATIONNAME (string)
function runPostamble { 
	echo
	echo "$1 simulations done."
	echo
}

# kill running opp_run processes
function killOppRun {
	echo
	echo "killing all running opp_run processes, please wait..."
	while [[ $(ps aux | grep opp_run | grep -v grep | awk {'print $1'} | wc -l ) -ge 1 ]]; do
		for i in ../simulations/logs/opprun-*.pid; do
			kill $(cat $i) > /dev/null 2>&1
		done
		for i in $(ps aux | grep opp_run | grep -v grep | awk {'print $1'}); do 
			kill $i > /dev/null 2>&1
		done
	done
	rm ../simulations/logs/opprun-*.pid > /dev/null 2>&1
	echo "done!"
	echo
}

# write PID to file
# 1: PID (number)
function writePid {
	echo $1 > ../simulations/logs/opprun-$1.pid
}

# delete PID file
# 1: PID (number)
function deletePid {
	rm ../simulations/logs/opprun-$1.pid
}

# estimate number of runs for parameter study
# 1: CONFIGFILE (filename)
# 2: CONFIGNAME (name)
# R: NUMBEROFRUNS (number)
function numberOfRuns {
	RUNNUMS=$(($(opp_run -u Cmdenv \
		-n "../src;../simulations;../../$INETMANET/examples;../../$INETMANET/showcases;../../$INETMANET/src;../../$INETMANET/tutorials" --image-path=../../$INETMANET/images \
		-l ../src/powerrouting -c $2 ../simulations/$1 -q numruns | grep "Number of runs" | cut -d ":" -f 2 | sed 's/ //g')-1))
	echo $RUNNUMS	
}

# get result name for study case
# 1: CONFIGFILE (filename)
# 2: CONFIGNAME (name)
# 3: NUMBEROFRUN (number)
# R: NAMEOFRESULT (name)
function getStudyResultName {
	SUFFIX=$(opp_run -r $3 -u Cmdenv \
		-n "../src;../simulations;../../$INETMANET/examples;../../$INETMANET/showcases;../../$INETMANET/src;../../$INETMANET/tutorials" --image-path=../../$INETMANET/images \
		-l ../src/powerrouting -c $2 ../simulations/$1 -q runs | grep "Run " | sed 's/\$//g' | cut -d ":" -f 2 | sed 's/ //g' | sed 's/,repetition=/-#/g')
	echo "results/$2-$SUFFIX"
}

# clean tmp directory
function cleanTemp {
	rm ./tmp/* > /dev/null 2>&1
	rm ./tmp/results/* > /dev/null 2>&1
}

# plot capacity csv data for given result as png
# 1: EXPERIMENTNAME (name)
function plotOne {
	# convert omnetdata to csv
	scavetool vector -p 'name(*Capacity*) AND NOT ( module(*sender*) OR module (*receiver*) OR module (*router22*)  OR module (*router23*)  OR module (*router24*)  OR module (*router42*)  OR module (*router43*)  OR module (*router44*) )' -O results/$1-CapacityOverTime.csv -F csv results/$1.vec > /dev/null 2>&1
	mkdir -p export > /dev/null 2>&1
	PROTOCOL=$(echo $1 | cut -d "-" -f 1)
	
	# create better data with perl and plot files
	$PERL plot.pl singleCapacity $1 $DROPOUT $SHORTTIME $(getSimTime) $DECIMALPLACES
	
	# perl::gnuplot is buggy, cant plot with more than 8 datasets, so we use bash
	# for timebased charts over all hosts, full time
	DATETIME="$(ls --full-time results/$1.vec | awk {'print $6'}) $(ls --full-time results/$1.vec | awk {'print $7'} | cut -d "." -f 1)"
	NUMHOSTS=$(($(head -1 results/$1-CapacityOverTime.csv | sed 's/[^,]//g' | wc -m)-1))
	CSVHEAD=$(head -1 results/$1-CapacityOverTime-Clean.csv)
	MAXVALUE=$(head -2 results/$1-CapacityOverTime-Clean.csv	| tail -1 | cut -d "," -f 2)
	TITLE="$1 ("$(getSimTime)"s) - CapacityOverTime" 
	PLOTSTRING="set title \"$TITLE\"; set timestamp \"%Y-%m-%d %H:%I:%S\"; set datafile missing \"\"; set key outside right; set ylabel \"Capacity\"; set xlabel \"Time\"; set yrange [0:$MAXVALUE*1.05]; set term png size 900 400 font \"Arial,9\"; set auto x; set output \"export/$PROTOCOL/CapacityOverTime/Full/$1-CapacityOverTime.png\"; set datafile separator ','; plot " 
	J=0
	while [ $J -lt $NUMHOSTS ]; do
		PLOTSTRING="$PLOTSTRING \"results/$1-CapacityOverTime-Clean.csv\" using 1:$(($J+2)) with lines lw 2 smooth bezier title \"$(echo $CSVHEAD | cut -d "," -f $(($J+2)) | cut -d "." -f 2)\","
		J=$(($J+1))
	done
	$GNUPLOT -e "$PLOTSTRING" > /dev/null 2>&1
	
	# perl::gnuplot is buggy, cant plot with more than 8 datasets, so we use bash
	# for timebased charts over all hosts, short time
	DATETIME="$(ls --full-time results/$1.vec | awk {'print $6'}) $(ls --full-time results/$1.vec | awk {'print $7'} | cut -d "." -f 1)"
	NUMHOSTS=$(($(head -1 results/$1-CapacityOverTime.csv | sed 's/[^,]//g' | wc -m)-1))
	CSVHEAD=$(head -1 results/$1-CapacityOverTime-Clean-Short.csv)
	MAXVALUE=$(head -2 results/$1-CapacityOverTime-Clean-Short.csv | tail -1 | cut -d "," -f 2)
	TITLE="$1 ("$SHORTTIME"s) - CapacityOverTime"	 
	PLOTSTRING="set title \"$TITLE\"; set timestamp \"%Y-%m-%d %H:%I:%S\"; set datafile missing \"\"; set key outside right; set ylabel \"Capacity\"; set xlabel \"Time\"; set yrange [0:$MAXVALUE*1.05]; set term png size 900 400 font \"Arial,9\"; set auto x; set output \"export/$PROTOCOL/CapacityOverTime/Short/$1-CapacityOverTime-Short.png\"; set datafile separator ','; plot " 
	J=0
	while [ $J -lt $NUMHOSTS ]; do
		PLOTSTRING="$PLOTSTRING \"results/$1-CapacityOverTime-Clean-Short.csv\" using 1:$(($J+2)) with lines lw 2 smooth bezier title \"$(echo $CSVHEAD | cut -d "," -f $(($J+2)) | cut -d "." -f 2)\","
		J=$(($J+1))
	done
	$GNUPLOT -e "$PLOTSTRING" > /dev/null 2>&1
}

# plot capacity csv data for given result as png
# 1: PROTOCOL (name)
# 2: REPETITIONS (integer)
# 3: CONFIGURATIONS (array)
function plotProtocol {
	scavetool scalar -p '(module(*sender*udpApp[0]) AND name(sentPk:count)) OR (module(*receiver*udpApp[0]) AND name(rcvdPk:count))' -O results/$1-UDPStats.csv -F csv results/$1-*.sca results/$1PO-*.sca results/$1POT*.sca > /dev/null 2>&1
	declare -a protocols=("${!3}")
	$PERL plot.pl compareProtocol $1 $2 $CONFIDENCE $SHORTTIME $(getSimTime) ${protocols[@]}
}

# export capacity csv data for given result
# 1: EXPERIMENTNAME (name)
function plotStudy {
	mkdir -p export/$1POParameterStudy/CapacityOverTime/Full > /dev/null 2>&1
	mkdir -p export/$1POParameterStudy/CapacityOverTime/Short > /dev/null 2>&1
	mkdir -p export/$1POParameterStudy/CapacityAtEnd/Full > /dev/null 2>&1
	mkdir -p export/$1POParameterStudy/CapacityAtEnd/Short > /dev/null 2>&1
	mkdir -p export/$1POParameterStudy/Full > /dev/null 2>&1
	mkdir -p export/$1POParameterStudy/Short > /dev/null 2>&1
	rm export/$1POParameterStudy/CapacityOverTime/Full/* > /dev/null 2>&1
	rm export/$1POParameterStudy/CapacityOverTime/Short/* > /dev/null 2>&1
	rm export/$1POParameterStudy/CapacityAtEnd/Full/* > /dev/null 2>&1
	rm export/$1POParameterStudy/CapacityAtEnd/Short/* > /dev/null 2>&1
	rm export/$1POParameterStudy/Full/* > /dev/null 2>&1
	rm export/$1POParameterStudy/Short/* > /dev/null 2>&1
	REPEAT=$2
	N=0
	for i in results/$1*Study*.vec; do
		waitForFreeSlotPlot
		RESULTNAME=$(echo $i | cut -d "/" -f 2- | sed 's/\.vec//g')
		echo "    plot: $(echo $RESULTNAME | cut -d '-' -f 1), run $(($N+1)) of $REPEAT" 
		N=$(($N+1))
		scavetool vector -p 'name(*Capacity*) AND NOT ( module(*sender*) OR module (*receiver*) OR module (*router22*)  OR module (*router23*)  OR module (*router24*)  OR module (*router42*)  OR module (*router43*)  OR module (*router44*) )' -O results/$RESULTNAME-CapacityOverTime.csv -F csv results/$RESULTNAME.vec > /dev/null 2>&1 &&
		scavetool scalar -p '(module(*sender*udpApp[0]) AND name(sentPk:count)) OR (module(*receiver*udpApp[0]) AND name(rcvdPk:count))' -O results/$RESULTNAME-UDPStats.csv -F csv results/$RESULTNAME.sca > /dev/null 2>&1 &&
		
		# create better data with perl and plot files
		$PERL plot.pl studyCapacity $RESULTNAME $DROPOUT $SHORTTIME $(getSimTime) $DECIMALPLACES &&
		
		# perl::gnuplot is buggy, cant plot with more than 8 datasets, so we use bash
		# for timebased charts over all hosts, full time
		DATETIME="$(ls --full-time results/$RESULTNAME.vec | awk {'print $6'}) $(ls --full-time results/$RESULTNAME.vec | awk {'print $7'} | cut -d "." -f 1)" &&
		NUMHOSTS=$(($(head -1 results/$RESULTNAME-CapacityOverTime.csv | sed 's/[^,]//g' | wc -m)-1)) &&
		CSVHEAD=$(head -1 results/$RESULTNAME-CapacityOverTime-Clean.csv) &&
		MAXVALUE=$(head -2 results/$RESULTNAME-CapacityOverTime-Clean.csv | tail -1 | cut -d "," -f 2) &&
		TITLE="$RESULTNAME ("$(getSimTime)"s) - CapacityOverTime" &&
		PLOTSTRING="set title \"$TITLE\"; set timestamp \"%Y-%m-%d %H:%I:%S\"; set datafile missing \"\"; set key outside right; set ylabel \"Capacity\"; set xlabel \"Time\"; set yrange [0:$MAXVALUE*1.05]; set term png size 900 400 font \"Arial,9\"; set auto x; set output \"export/$1POParameterStudy/CapacityOverTime/Full/$RESULTNAME-CapacityOverTime.png\"; set datafile separator ','; plot " &&
		J=0 &&
		while [ $J -lt $NUMHOSTS ]; do 
			PLOTSTRING="$PLOTSTRING \"results/$RESULTNAME-CapacityOverTime-Clean.csv\" using 1:$(($J+2)) with lines lw 2 smooth bezier title \"$(echo $CSVHEAD | cut -d "," -f $(($J+2)) | cut -d "." -f 2)\","
			J=$(($J+1))
		done &&
		$GNUPLOT -e "$PLOTSTRING" > /dev/null 2>&1 &&
	
		# perl::gnuplot is buggy, cant plot with more than 8 datasets, so we use bash
		# for timebased charts over all hosts, short time
		DATETIME="$(ls --full-time results/$RESULTNAME.vec | awk {'print $6'}) $(ls --full-time results/$RESULTNAME.vec | awk {'print $7'} | cut -d "." -f 1)" &&
		NUMHOSTS=$(($(head -1 results/$RESULTNAME-CapacityOverTime.csv | sed 's/[^,]//g' | wc -m)-1)) &&
		CSVHEAD=$(head -1 results/$RESULTNAME-CapacityOverTime-Clean-Short.csv) &&
		MAXVALUE=$(head -2 results/$RESULTNAME-CapacityOverTime-Clean-Short.csv | tail -1 | cut -d "," -f 2) &&
		TITLE="$RESULTNAME ("$SHORTTIME"s) - CapacityOverTime" &&
		PLOTSTRING="set title \"$TITLE\"; set timestamp \"%Y-%m-%d %H:%I:%S\"; set datafile missing \"\"; set key outside right; set ylabel \"Capacity\"; set xlabel \"Time\"; set yrange [0:$MAXVALUE*1.05]; set term png size 900 400 font \"Arial,9\"; set auto x; set output \"export/$1POParameterStudy/CapacityOverTime/Short/$RESULTNAME-CapacityOverTime-Short.png\"; set datafile separator ','; plot " &&
		J=0 &&
		while [ $J -lt $NUMHOSTS ]; do
			PLOTSTRING="$PLOTSTRING \"results/$RESULTNAME-CapacityOverTime-Clean-Short.csv\" using 1:$(($J+2)) with lines lw 2 smooth bezier title \"$(echo $CSVHEAD | cut -d "," -f $(($J+2)) | cut -d "." -f 2)\","
			J=$(($J+1))
		done &&
		$GNUPLOT -e "$PLOTSTRING" > /dev/null 2>&1 &
	done
		
	echo "    plot: $1POStudy protocol comparision"	
	$PERL plot.pl studyCompare $1 $DECIMALPLACES
	REPETITIONS=$(for i in results/AODVPOParameterStudy-*\#*Time-Clean-Short.csv; do A=0; while [ -e $(echo $i | cut -d '#' -f 1)*$A*Time-Clean-Short.csv ]; do A=$(($A+1)); done ; echo $A; break; done)
		
	# print 3d map for capacityOverTime
	TITLE="$1POParameterStudy ("$(getSimTime)"s, Interpolation: $INTERPOLATE, $REPETITIONS repetitions) - CapacityOverTime"
	DATAFILE="results/$1POParameterStudy-CapacityAtEnd.dat"
	PLOTSTRING="set title \"$TITLE\"; set timestamp \"%Y-%m-%d %H:%I:%S\"; set datafile missing \"\"; set ylabel \"Trigger\"; set xlabel \"Sensitivity\"; set zlabel \"1 - stddev\" offset -2 rotate by 90; set term png size 900 400 font \"Arial,9\"; set output \"export/$1POParameterStudy/Full/$1POParameterStudy-CapacityAtEnd-3D.png\"; set dgrid3d; set pm3d interpolate $INTERPOLATE,$INTERPOLATE; splot \"$DATAFILE\" using 1:2:3 with pm3d title\"\""
	$GNUPLOT -e "$PLOTSTRING"
		
	# print heat map for capacityOverTime
	TITLE="$1POParameterStudy ("$(getSimTime)"s, Interpolation: $INTERPOLATE, $REPETITIONS repetitions) - CapacityOverTime"
	DATAFILE="results/$1POParameterStudy-CapacityAtEnd.dat"
	PLOTSTRING="set title \"$TITLE\"; set view map; set timestamp \"%Y-%m-%d %H:%I:%S\"; set datafile missing \"\"; set ylabel \"Trigger\"; set xlabel \"Sensitivity\"; set zlabel \"1 - stddev\"; set term png size 900 400 font \"Arial,9\"; set output \"export/$1POParameterStudy/Full/$1POParameterStudy-CapacityAtEnd-Map.png\"; set dgrid3d; set pm3d interpolate $INTERPOLATE,$INTERPOLATE; splot \"$DATAFILE\" using 1:2:3 with pm3d title\"\""
	$GNUPLOT -e "$PLOTSTRING"
		
	# print 3d map for udpPacketLoss
	TITLE="$1POParameterStudy ("$(getSimTime)"s, Interpolation: $INTERPOLATE, $REPETITIONS repetitions) - udpPacketTransmitted"
	DATAFILE="results/$1POParameterStudy-UDPStats.dat"
	PLOTSTRING="set title \"$TITLE\"; set timestamp \"%Y-%m-%d %H:%I:%S\"; set datafile missing \"\"; set ylabel \"Trigger\"; set xlabel \"Sensitivity\"; set zlabel \"Percent\" offset -2 rotate by 90; set term png size 900 400 font \"Arial,9\"; set output \"export/$1POParameterStudy/Full/$1POParameterStudy-UDPStats-3D.png\"; set dgrid3d; set pm3d interpolate $INTERPOLATE,$INTERPOLATE; splot \"$DATAFILE\" using 1:2:3 with pm3d title\"\""
	$GNUPLOT -e "$PLOTSTRING"
		
	# print heat map for udpPacketLoss
	TITLE="$1POParameterStudy ("$(getSimTime)"s, Interpolation: $INTERPOLATE, $REPETITIONS repetitions) - udpPacketTransmitted"
	DATAFILE="results/$1POParameterStudy-UDPStats.dat"
	PLOTSTRING="set title \"$TITLE\"; set view map; set timestamp \"%Y-%m-%d %H:%I:%S\"; set datafile missing \"\"; set ylabel \"Trigger\"; set xlabel \"Sensitivity\"; set zlabel \"Percent\"; set term png size 900 400 font \"Arial,9\"; set output \"export/$1POParameterStudy/Full/$1POParameterStudy-UDPStats-Map.png\"; set dgrid3d; set pm3d interpolate $INTERPOLATE,$INTERPOLATE; splot \"$DATAFILE\" using 1:2:3 with pm3d title\"\""
	$GNUPLOT -e "$PLOTSTRING"
		
	# print 3d map for performance
	TITLE="$1POParameterStudy ("$(getSimTime)"s, Interpolation: $INTERPOLATE, $REPETITIONS repetitions) - Performance"
	DATAFILE="results/$1POParameterStudy-Performance.dat"
	PLOTSTRING="set title \"$TITLE\"; set timestamp \"%Y-%m-%d %H:%I:%S\"; set datafile missing \"\"; set ylabel \"Trigger\"; set xlabel \"Sensitivity\"; set zlabel \"Performance\" offset -2 rotate by 90; set term png size 900 400 font \"Arial,9\"; set output \"export/$1POParameterStudy/Full/$1POParameterStudy-Performance-3D.png\"; set dgrid3d; set pm3d interpolate $INTERPOLATE,$INTERPOLATE; splot \"$DATAFILE\" using 1:2:3 with pm3d title\"\""
	$GNUPLOT -e "$PLOTSTRING"
		
	# print heat map for performance
	TITLE="$1POParameterStudy ("$(getSimTime)"s, Interpolation: $INTERPOLATE, $REPETITIONS repetitions) - Performance"
	DATAFILE="results/$1POParameterStudy-Performance.dat"
	PLOTSTRING="set title \"$TITLE\"; set view map; set timestamp \"%Y-%m-%d %H:%I:%S\"; set datafile missing \"\"; set ylabel \"Trigger\"; set xlabel \"Sensitivity\"; set zlabel \"Performance\"; set term png size 900 400 font \"Arial,9\"; set output \"export/$1POParameterStudy/Full/$1POParameterStudy-Performance-Map.png\"; set dgrid3d; set pm3d interpolate $INTERPOLATE,$INTERPOLATE; splot \"$DATAFILE\" using 1:2:3 with pm3d title\"\""
	$GNUPLOT -e "$PLOTSTRING"
		
	# print 3d map for capacityOverTime short
	TITLE="$1POParameterStudy ("$SHORTTIME"s, Interpolation: $INTERPOLATE, $REPETITIONS repetitions) - CapacityOverTime"
	DATAFILE="results/$1POParameterStudy-CapacityAtEnd-Short.dat"
	PLOTSTRING="set title \"$TITLE\"; set timestamp \"%Y-%m-%d %H:%I:%S\"; set datafile missing \"\"; set ylabel \"Trigger\"; set xlabel \"Sensitivity\"; set zlabel \"1 - stddev\" offset -2 rotate by 90; set term png size 900 400 font \"Arial,9\"; set output \"export/$1POParameterStudy/Short/$1POParameterStudy-CapacityAtEnd-3D.png\"; set dgrid3d; set pm3d interpolate $INTERPOLATE,$INTERPOLATE; splot \"$DATAFILE\" using 1:2:3 with pm3d title\"\""
	$GNUPLOT -e "$PLOTSTRING"
		
	# print heat map for capacityOverTime short
	TITLE="$1POParameterStudy ("$SHORTTIME"s, Interpolation: $INTERPOLATE, $REPETITIONS repetitions) - CapacityOverTime"
	DATAFILE="results/$1POParameterStudy-CapacityAtEnd-Short.dat"
	PLOTSTRING="set title \"$TITLE\"; set view map; set timestamp \"%Y-%m-%d %H:%I:%S\"; set datafile missing \"\"; set ylabel \"Trigger\"; set xlabel \"Sensitivity\"; set zlabel \"1 - stddev\"; set term png size 900 400 font \"Arial,9\"; set output \"export/$1POParameterStudy/Short/$1POParameterStudy-CapacityAtEnd-Map.png\"; set dgrid3d; set pm3d interpolate $INTERPOLATE,$INTERPOLATE; splot \"$DATAFILE\" using 1:2:3 with pm3d title\"\""
	$GNUPLOT -e "$PLOTSTRING"
		
	waitForFinish
}

# create html reports
function createHTML {
	echo "    report: creating HTML files"
	$PERL plot.pl createHTML
}

### execution ###
# create directory for logs
mkdir ../simulations/logs > /dev/null 2>&1

# mode switch
case $1 in

	# full set of simulations
	aodv)
		writePid $$
		runPreamble $1
		estimateThreads $2
		runSimulation "aodv.ini" "AODV" $2
		runSimulation "aodv.ini" "AODVPO" $2
		runSimulation "aodv.ini" "AODVPOTriggerHappy" $2
		runSimulation "aodv.ini" "AODVPOTriggerSloppy" $2
		runSimulation "aodv.ini" "AODVPOMixed" $2
		waitForFinish
		plotSimulation "AODV"
		plotSimulation "AODVPO"
		plotSimulation "AODVPOTriggerHappy"
		plotSimulation "AODVPOTriggerSloppy"
		plotSimulation "AODVPOMixed"
		waitForFinish
		PROTOCOLS=("AODV" "AODVPO" "AODVPOTriggerHappy" "AODVPOTriggerSloppy")
		plotSimulationProtocol "AODV" PROTOCOLS[@]
		waitForFinish
		createHTML
		cleanLogs
		runPostamble $1
		deletePid $$
	;;

	# run aodv study
	aodvstudy)
		writePid $$
		runPreamble $1
		estimateThreads $2
		RUNNUMS=$(numberOfRuns aodv.ini AODVPOParameterStudy)	
		N=0
		rm ./results/AODVPOP* > /dev/null 2>&1
		while [ $N -le $RUNNUMS ]; do
			runStudySimulation "aodv.ini" AODVPOParameterStudy $N $RUNNUMS
			N=$(($N+1))
		done
		waitForFinish		
		plotStudy AODV $(($RUNNUMS+1))
		createHTML
		cleanLogs
		cleanFiles AODVPOP
		runPostamble $1
		deletePid $$ 
	;;

	# full set of simulations
	olsr)
		writePid $$
		runPreamble $1
		estimateThreads $2
		runSimulation "olsr.ini" "OLSR" $2
		runSimulation "olsr.ini" "OLSRPO" $2
		runSimulation "olsr.ini" "OLSRPOTriggerHappy" $2
		runSimulation "olsr.ini" "OLSRPOTriggerSloppy" $2
		runSimulation "olsr.ini" "OLSRPOMixed" $2
		waitForFinish
		plotSimulation "OLSR"
		plotSimulation "OLSRPO"
		plotSimulation "OLSRPOTriggerHappy"
		plotSimulation "OLSRPOTriggerSloppy"
		plotSimulation "OLSRPOMixed"
		waitForFinish
		PROTOCOLS=("OLSR" "OLSRPO" "OLSRPOTriggerHappy" "OLSRPOTriggerSloppy")
		plotSimulationProtocol "OLSR" PROTOCOLS[@]
		waitForFinish
		createHTML
		cleanLogs
		runPostamble $1
		deletePid $$
	;;
	
	# run olsr study
	olsrstudy)
		writePid $$
		runPreamble $1
		estimateThreads $2
		RUNNUMS=$(numberOfRuns olsr.ini OLSRPOParameterStudy)	
		N=0
		rm ./results/OLSRPOP* > /dev/null 2>&1
		while [ $N -le $RUNNUMS ]; do
			runStudySimulation "olsr.ini" OLSRPOParameterStudy $N $RUNNUMS
			N=$(($N+1))
		done
		waitForFinish		
		plotStudy OLSR $(($RUNNUMS+1))
		createHTML
		cleanLogs
		cleanFiles OLSRPOP
		runPostamble $1
		deletePid $$ 
	;;

	# create aodv and olsr protocol comparision
	compare)
		writePid $$
		runPreamble $1
		PROTOCOLS=("AODV" "AODVPO" "AODVPOTriggerHappy" "AODVPOTriggerSloppy" "OLSR" "OLSRPO" "OLSRPOTriggerHappy" "OLSRPOTriggerSloppy")
		compareProtocols "AODV-OLSR" PROTOCOLS[@]
		createHTML
		runPostamble $1
		deletePid $$
	;;

	# run all simulations, except longterm
	normal)
		writePid $$
		$0 aodv $2
		$0 olsr $2
		deletePid $$
	;;

	# run study simulations
	study)
		writePid $$
		$0 aodvstudy $2
		$0 olsrstudy $2
		deletePid $$
	;;

	# run all simulations
	all)
		writePid $$
		$0 aodv $2
		$0 olsr $2
		$0 aodvstudy $2
		$0 olsrstudy $2
		$0 compare $2
		deletePid $$
	;;

	# kill running simulations
	killopp)
		killOppRun
	;;

	# create html reports
	createHTML)
		writePid $$
		runPreamble $1
		createHTML
		runPostamble $1
		deletePid $$
	;;
	
	# if no mode given print help
	*)
		echo
		echo "usage: ./run [mode] (verbose)"
		echo "    runs designated tests and logs to files (multihreaded),"
		echo "    for logging to screen and files, append 'verbose' (only singlethreaded)"
		echo "    script must be started in directory simulations, you have been warned!"
		echo
		echo "    modes:"
		echo "    all - runs all aodv and olsr simulations"
		echo "    normal - runs all aodv and olsr simulations without study"
		echo "    study - runs all aodv and olsr simulations with varying parameter"
		echo "    olsr - runs olsr simulations"
		echo "    aodv - runs aodv simulations"
		echo "    olsrstudy - runs olsr simulations with varying parameter"
		echo "    aodvstudy - runs aodv simulations with varying parameter"
		echo "    compare - creates comparision charts for olsr and aodv, run after aodv and olsr"
		echo "    createHTML - creates HTML reports"
		echo "    killopp - kills all running opp_run processes"
		echo "    help - print this help"
		echo
	;;

esac
