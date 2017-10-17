# PowerRouting for OMNeT++ - plot.pl
# Marcel Ebbrecht, marcel.ebbrecht@googlemail.com
# free software, see LICENSE.md for details

# Warning, written by a "dont-care" bash-hacker with
# a bad attitude - dirty but worky, sorry guys, I
# don't like bash - I love it! So dont study the 
# following code, it will harm your coding skills.
# You habe been warned ;)

### includes
use Switch;
use strict;

### imports
require "./subs.pl";

### reading variables from commandline
# program mode
my $mode = $ARGV[0];

### execution
# mode switch
switch($mode) {

	# mode for creating data for a single run and plot some charts
	case "singleCapacity" {	
		# get parameters
		shift;
		my $title = $ARGV[0];
		shift;
		my $dropoutInterval = $ARGV[0];
		shift;
		my $shortTime = $ARGV[0];
		shift;
		my $longTime = $ARGV[0];
		shift;
		my $decimalplaces = $ARGV[0];
		my @protocol = split("-", $title);
		
		# filenames
		my $capacityOriginalFile = "results/$title-CapacityOverTime.csv";
		my $capacityOverTimeCsvFile = "results/$title-CapacityOverTime-Clean.csv";
		my $capacityOverTimeCsvFileShort = "results/$title-CapacityOverTime-Clean-Short.csv";
		my $capacityAtEndCsvFile = "results/$title-CapacityAtEnd-Clean.csv";
		my $capacityAtEndCsvFileShort = "results/$title-CapacityAtEnd-Clean-Short.csv";
		my $capacityAtEndPlotFile = "export/$protocol[0]/CapacityAtEnd/Full/$title-CapacityAtEnd.png";
		my $capacityAtEndPlotFileShort = "export/$protocol[0]/CapacityAtEnd/Short/$title-CapacityAtEnd-Short.png";
		my $capacityAtEndPlotTitle = "$title (".$longTime."s)";
		my $capacityAtEndPlotTitleShort = "$title (".$shortTime."s)";
		
		# create csv for external plot
		my @resultsCapacity = getCapacityResults($capacityOriginalFile, $decimalplaces, $dropoutInterval);
		my @resultsCapacityShort = getCapacityResultsShort($shortTime, @resultsCapacity);
		my @resultsCapacityAtEnd = getMinimumCapacityValues(@resultsCapacity);
		my @resultsCapacityShortAtEnd = getMinimumCapacityValues(@resultsCapacityShort);
		
		# write data to csv files
		writeCapacityArrayToCsv($capacityOverTimeCsvFile, @resultsCapacity);
		writeCapacityArrayToCsv($capacityOverTimeCsvFileShort, @resultsCapacityShort);
		writeCapacityArrayToCsv($capacityAtEndCsvFile, @resultsCapacityAtEnd);
		writeCapacityArrayToCsv($capacityAtEndCsvFileShort, @resultsCapacityShortAtEnd);
		
		# plot charts
		plotCapacityAtEnd($capacityAtEndPlotFile, $capacityAtEndPlotTitle, @resultsCapacityAtEnd);
		plotCapacityAtEnd($capacityAtEndPlotFileShort, $capacityAtEndPlotTitleShort, @resultsCapacityShortAtEnd);
	}
	
	# mode for creating data for study run and plot some charts
	case "studyCapacity" {	
		# get parameters
		shift;
		my $title = $ARGV[0];
		shift;
		my $dropoutInterval = $ARGV[0];
		shift;
		my $shortTime = $ARGV[0];
		shift;
		my $longTime = $ARGV[0];
		shift;
		my $decimalplaces = $ARGV[0];
		my @protocol = split("-", $title);
		
		# filenames
		my $capacityOriginalFile = "results/$title-CapacityOverTime.csv";
		my $capacityOverTimeCsvFile = "results/$title-CapacityOverTime-Clean.csv";
		my $capacityOverTimeCsvFileShort = "results/$title-CapacityOverTime-Clean-Short.csv";
		my $capacityAtEndCsvFile = "results/$title-CapacityAtEnd-Clean.csv";
		my $capacityAtEndCsvFileShort = "results/$title-CapacityAtEnd-Clean-Short.csv";
		my $capacityAtEndPlotFile = "export/$protocol[0]/CapacityAtEnd/Full/$title-CapacityAtEnd.png";
		my $capacityAtEndPlotFileShort = "export/$protocol[0]/CapacityAtEnd/Short/$title-CapacityAtEnd-Short.png";
		my $capacityAtEndPlotTitle = "$title (".$longTime."s)";
		my $capacityAtEndPlotTitleShort = "$title (".$shortTime."s)";
		
		# create csv for external plot
		my @resultsCapacity = getCapacityResults($capacityOriginalFile, $decimalplaces, $dropoutInterval);
		my @resultsCapacityShort = getCapacityResultsShort($shortTime, @resultsCapacity);
		my @resultsCapacityAtEnd = getMinimumCapacityValues(@resultsCapacity);
		my @resultsCapacityShortAtEnd = getMinimumCapacityValues(@resultsCapacityShort);
		
		# write data to csv files		
		writeCapacityArrayToCsv($capacityOverTimeCsvFile, @resultsCapacity);
		writeCapacityArrayToCsv($capacityOverTimeCsvFileShort, @resultsCapacityShort);
		writeCapacityArrayToCsv($capacityAtEndCsvFile, @resultsCapacityAtEnd);
		writeCapacityArrayToCsv($capacityAtEndCsvFileShort, @resultsCapacityShortAtEnd);
		
		# plot charts
		plotCapacityAtEnd($capacityAtEndPlotFile, $capacityAtEndPlotTitle, @resultsCapacityAtEnd);
		plotCapacityAtEnd($capacityAtEndPlotFileShort, $capacityAtEndPlotTitleShort, @resultsCapacityShortAtEnd);
	}
	
	# mode for creating data for a comparision of a single protocol and plot some charts
	case "compareProtocol" {
		# get parameters
		shift;
		my $protcolFamily = $ARGV[0];
		shift;
		my $numberOfRuns = $ARGV[0];
		shift;
		my $confidence = $ARGV[0];
		shift;
		my $shortTime = $ARGV[0];
		shift;
		my $longTime = $ARGV[0];
		shift;
		my @configurations = @ARGV;
		
		# create some variables
		my $xlabelAdd = "";
		my $labelcount = 1;
		foreach (@configurations) {
			$xlabelAdd .= " $labelcount:$_ ";
			$labelcount++;
		}
		
		# filenames
		my $capacityAtEndPlotFile = "export/Summary/CapacityAtEnd/Full/$protcolFamily-CapacityAtEndStatistics.png";
		my $capacityAtEndPlotFileShort = "export/Summary/CapacityAtEnd/Short/$protcolFamily-CapacityAtEndStatistics-Short.png";
		my $udpPacketLossFile = "export/Summary/UdpPacketLoss/Full/$protcolFamily-UdpPacketLossStatistics.png";
		my $rttFile = "export/Summary/RTT/Full/$protcolFamily-RTTStatistics.png";
		my $end2EndFile = "export/Summary/End2End/Full/$protcolFamily-End2EndStatistics.png";
		my $overheadFile = "export/Summary/Overhead/Full/$protcolFamily-OverheadStatistics.png";
		my $performanceLossFile = "export/Summary/Performance/Full/$protcolFamily-PerformanceStatistics.png";
		my $capacityAtEndPlotTitle = "$protcolFamily (".$longTime."s) ($numberOfRuns repetitions)";
		my $capacityAtEndPlotTitleShort = "$protcolFamily (".$shortTime."s) ($numberOfRuns repetitions)";
		my $udpPacketLossPlotTitle = "$protcolFamily (".$longTime."s) ($numberOfRuns repetitions)";
		my $rttPlotTitle = "$protcolFamily (".$longTime."s) ($numberOfRuns repetitions)";
		my $end2EndPlotTitle = "$protcolFamily (".$longTime."s) ($numberOfRuns repetitions)";
		my $overheadPlotTitle = "$protcolFamily (".$longTime."s) ($numberOfRuns repetitions)";
		my $performancePlotTitle = "$protcolFamily (".$longTime."s) ($numberOfRuns repetitions)";
		
		# read data
		my @capacityAtEndDataStatistics = getCapacityAtEndStatistic($numberOfRuns, 1, $confidence, @configurations);
		my @capacityAtEndDataStatisticsShort = getCapacityAtEndStatistic($numberOfRuns, 0, $confidence, @configurations);
		my @capacityAtEndData = getCapacityAtEndArray($numberOfRuns, 1, $confidence, @configurations);
		my @capacityAtEndDataShort = getCapacityAtEndArray($numberOfRuns, 0, $confidence, @configurations);		
		my @udpStats = getUdpPacketLossArray($numberOfRuns, $confidence, $protcolFamily, @configurations);
		my @udpStatsStatistics = getUdpPacketLossStatistics($numberOfRuns, $confidence, $protcolFamily, @configurations);
		my @rtt = getRttArray($numberOfRuns, $confidence, $protcolFamily, @configurations);
		my @rttStatistics = getRttStatistics($numberOfRuns, $confidence, $protcolFamily, @configurations);
		my @end2End = getEnd2EndArray($numberOfRuns, $confidence, $protcolFamily, @configurations);
		my @end2EndStatistics = getEnd2EndStatistics($numberOfRuns, $confidence, $protcolFamily, @configurations);
		my @overhead = getOverheadArray($numberOfRuns, $confidence, $protcolFamily, @configurations);
		my @overheadStatistics = getOverheadStatistics($numberOfRuns, $confidence, $protcolFamily, @configurations);
		
		# calculate confidence
		my @performanceArrayCarrier = ();
		push @{$performanceArrayCarrier[0]}, @capacityAtEndData;
		push @{$performanceArrayCarrier[1]}, @udpStats;
		my @performanceArray = getPerformanceArray($confidence, @performanceArrayCarrier);		
		my @performanceStatisticsCarrier = ();
		push @{$performanceStatisticsCarrier[0]}, @capacityAtEndDataStatistics;
		push @{$performanceStatisticsCarrier[1]}, @udpStatsStatistics;
		my @performanceStatistics = getPerformanceStatistics($confidence, @performanceStatisticsCarrier);

		# plot single charts
		plotCapacityAtEndStatistics($capacityAtEndPlotFile, $capacityAtEndPlotTitle, $confidence, @capacityAtEndDataStatistics);
		plotCapacityAtEndStatistics($capacityAtEndPlotFileShort, $capacityAtEndPlotTitleShort, $confidence, @capacityAtEndDataStatisticsShort);
		plotUdpPacketLossStatistics($udpPacketLossFile, $udpPacketLossPlotTitle, $confidence, @udpStatsStatistics);
		plotRttStatistics($rttFile, $rttPlotTitle, $confidence, @rttStatistics);
		plotEnd2EndStatistics($end2EndFile, $end2EndPlotTitle, $confidence, @end2EndStatistics);
		plotOverheadStatistics($overheadFile, $overheadPlotTitle, $confidence, @overheadStatistics);
		plotPerformanceStatistics($performanceLossFile, $performancePlotTitle, $confidence, $xlabelAdd, @performanceStatistics);
		
		# plot charts for each configuration
		my $position = 0;
		foreach (@configurations) {
			plotCapacityAtEndConfidence($confidence, 1, $longTime, $_, $position, @capacityAtEndData);
			plotCapacityAtEndConfidence($confidence, 0, $shortTime, $_, $position, @capacityAtEndDataShort);
			$position++;
		}		
		my $position = 0;
		foreach (@configurations) {
			plotUdpPacketLossConfidence($confidence, 1, $longTime, $_, $position, @udpStats);
			$position++;
		}		
		my $position = 0;
		foreach (@configurations) {
			plotRttConfidence($confidence, 1, $longTime, $_, $position, @rtt);
			$position++;
		}		
		my $position = 0;
		foreach (@configurations) {
			plotEnd2EndConfidence($confidence, 1, $longTime, $_, $position, @end2End);
			$position++;
		}		
		my $position = 0;
		foreach (@configurations) {
			plotOverheadConfidence($confidence, 1, $longTime, $_, $position, @overhead);
			$position++;
		}		
		my $position = 0;
		foreach (@configurations) {
			plotPerformanceConfidence($confidence, 1, $longTime, $_, $position, @performanceArray);
			$position++;
		}
	}
	
	# mode for creating data for a comparision of a given protocols and plot some charts
	case "compareProtocols" {
		# get parameters
		shift;
		my $protcolFamily = $ARGV[0];
		shift;
		my $numberOfRuns = $ARGV[0];
		shift;
		my $confidence = $ARGV[0];
		shift;
		my $shortTime = $ARGV[0];
		shift;
		my $longTime = $ARGV[0];
		shift;
		my @configurations = @ARGV;
		
		# create some variables
		my $xlabelAdd = "";
		my $labelcount = 1;
		foreach (@configurations) {
			$xlabelAdd .= " $labelcount:$_ ";
			$labelcount++;
		}
			
		# filenames
		my $capacityAtEndPlotFile = "export/Compare/CapacityAtEnd/Full/$protcolFamily-CapacityAtEndStatistics.png";
		my $capacityAtEndPlotFileShort = "export/Compare/CapacityAtEnd/Short/$protcolFamily-CapacityAtEndStatistics-Short.png";
		my $udpPacketLossFile = "export/Compare/UdpPacketLoss/Full/$protcolFamily-UdpPacketLossStatistics.png";
		my $rttFile = "export/Compare/RTT/Full/$protcolFamily-RTTStatistics.png";
		my $end2EndFile = "export/Compare/End2End/Full/$protcolFamily-End2EndStatistics.png";
		my $overheadFile = "export/Compare/Overhead/Full/$protcolFamily-OverheadStatistics.png";
		my $performanceLossFile = "export/Compare/Performance/Full/$protcolFamily-PerformanceStatistics.png";
		my $capacityAtEndPlotTitle = "$protcolFamily (".$longTime."s) ($numberOfRuns repetitions)";
		my $capacityAtEndPlotTitleShort = "$protcolFamily (".$shortTime."s) ($numberOfRuns repetitions)";
		my $udpPacketLossPlotTitle = "$protcolFamily (".$longTime."s) ($numberOfRuns repetitions)";
		my $rttPlotTitle = "$protcolFamily (".$longTime."s) ($numberOfRuns repetitions)";
		my $end2EndPlotTitle = "$protcolFamily (".$longTime."s) ($numberOfRuns repetitions)";
		my $overheadPlotTitle = "$protcolFamily (".$longTime."s) ($numberOfRuns repetitions)";
		my $performancePlotTitle = "$protcolFamily (".$longTime."s) ($numberOfRuns repetitions)";
		
		# read data
		my @capacityAtEndDataStatistics = getCapacityAtEndStatistic($numberOfRuns, 1, $confidence, @configurations);
		my @capacityAtEndDataStatisticsShort = getCapacityAtEndStatistic($numberOfRuns, 0, $confidence, @configurations);
		my @capacityAtEndData = getCapacityAtEndArray($numberOfRuns, 1, $confidence, @configurations);
		my @capacityAtEndDataShort = getCapacityAtEndArray($numberOfRuns, 0, $confidence, @configurations);		
		my @udpStats = getUdpPacketLossArray($numberOfRuns, $confidence, $protcolFamily, @configurations);
		my @udpStatsStatistics = getUdpPacketLossStatistics($numberOfRuns, $confidence, $protcolFamily, @configurations);
		my @rttStats = getRttArray($numberOfRuns, $confidence, $protcolFamily, @configurations);
		my @rttStatsStatistics = getRttStatistics($numberOfRuns, $confidence, $protcolFamily, @configurations);
		my @end2EndStats = getEnd2EndArray($numberOfRuns, $confidence, $protcolFamily, @configurations);
		my @end2EndStatsStatistics = getEnd2EndStatistics($numberOfRuns, $confidence, $protcolFamily, @configurations);
		my @overheadStats = getOverheadArray($numberOfRuns, $confidence, $protcolFamily, @configurations);
		my @overheadStatsStatistics = getOverheadStatistics($numberOfRuns, $confidence, $protcolFamily, @configurations);
		
		# calculate confidence
		my @performanceArrayCarrier = ();
		push @{$performanceArrayCarrier[0]}, @capacityAtEndData;
		push @{$performanceArrayCarrier[1]}, @udpStats;
		my @performanceArray = getPerformanceArray($confidence, @performanceArrayCarrier);		
		my @performanceStatisticsCarrier = ();
		push @{$performanceStatisticsCarrier[0]}, @capacityAtEndDataStatistics;
		push @{$performanceStatisticsCarrier[1]}, @udpStatsStatistics;
		my @performanceStatistics = getPerformanceStatistics($confidence, @performanceStatisticsCarrier);
		
		# plot single charts
		plotCapacityAtEndStatisticsCompare($capacityAtEndPlotFile, $capacityAtEndPlotTitle, $confidence, @capacityAtEndDataStatistics);
		plotCapacityAtEndStatisticsCompare($capacityAtEndPlotFileShort, $capacityAtEndPlotTitleShort, $confidence, @capacityAtEndDataStatisticsShort);		
		plotUdpPacketLossStatisticsCompare($udpPacketLossFile, $udpPacketLossPlotTitle, $confidence, @udpStatsStatistics);	
		plotRttStatisticsCompare($rttFile, $rttPlotTitle, $confidence, @rttStatsStatistics);	
		plotEnd2EndStatisticsCompare($end2EndFile, $end2EndPlotTitle, $confidence, @end2EndStatsStatistics);	
		plotOverheadStatisticsCompare($overheadFile, $overheadPlotTitle, $confidence, @overheadStatsStatistics);
		plotPerformanceStatistics($performanceLossFile, $performancePlotTitle, $confidence, $xlabelAdd, @performanceStatistics);
		
		# plot charts for each configuration
		my $position = 0;
		foreach (@configurations) {
			plotCapacityAtEndConfidenceCompare($confidence, 1, $longTime, $_, $position, @capacityAtEndData);
			plotCapacityAtEndConfidenceCompare($confidence, 0, $shortTime, $_, $position, @capacityAtEndDataShort);
			$position++;
		}
		my $position = 0;
		foreach (@configurations) {
			plotUdpPacketLossConfidenceCompare($confidence, 1, $longTime, $_, $position, @udpStats);
			$position++;
		}
		my $position = 0;
		foreach (@configurations) {
			plotRttConfidenceCompare($confidence, 1, $longTime, $_, $position, @rttStats);
			$position++;
		}
		my $position = 0;
		foreach (@configurations) {
			plotEnd2EndConfidenceCompare($confidence, 1, $longTime, $_, $position, @end2EndStats);
			$position++;
		}
		my $position = 0;
		foreach (@configurations) {
			plotOverheadConfidenceCompare($confidence, 1, $longTime, $_, $position, @overheadStats);
			$position++;
		}
		my $position = 0;
		foreach (@configurations) {
			plotPerformanceConfidenceCompare($confidence, 1, $longTime, $_, $position, @performanceArray);
			$position++;
		}
	}
	
	# mode for creating data for a comparision of a given protocols and plot some charts
	case "compareSending" {
		# get parameters
		shift;
		my $protcolFamily = $ARGV[0];
		shift;
		my $numberOfRuns = $ARGV[0];
		shift;
		my $confidence = $ARGV[0];
		shift;
		my $shortTime = $ARGV[0];
		shift;
		my $longTime = $ARGV[0];
		shift;
		my @configurations = @ARGV;
		
		# create some variables
		my $xlabelAdd = "";
		my $labelcount = 1;
		foreach (@configurations) {
			$xlabelAdd .= " $labelcount:$_ ";
			$labelcount++;
		}
			
		# filenames
		my $udpPacketLossFile = "export/CompareSending/UdpPacketLoss/Full/$protcolFamily-UdpPacketLossStatistics.png";
		my $udpPacketLossPlotTitle = "$protcolFamily (".$longTime."s) ($numberOfRuns repetitions)";
		my $capacityAtEndSumFile = "export/CompareSending/CapacityAtEndSum/Full/$protcolFamily-CapacityAtEndSum.png";
		my $capacityAtEndSumPlotTitle = "$protcolFamily (".$longTime."s) ($numberOfRuns repetitions)";
		my $capacityAtEndSumFileShort = "export/CompareSending/CapacityAtEndSum/Short/$protcolFamily-CapacityAtEndSum.png";
		my $capacityAtEndSumPlotTitleShort = "$protcolFamily (".$shortTime."s) ($numberOfRuns repetitions)";
		
		# read data	
		my @udpStats = getUdpPacketLossArrayMultiple($numberOfRuns, $confidence, $protcolFamily, @configurations);
		my @udpStatsStatistics = getUdpPacketLossStatisticsMultiple($numberOfRuns, $confidence, $protcolFamily, @configurations);
		my @capacityAtEndSum = getCapacityAtEndSumArrayMultiple($numberOfRuns, 1, $confidence, $protcolFamily, @configurations);
		my @capacityAtEndSumShort = getCapacityAtEndSumArrayMultiple($numberOfRuns, 0, $confidence, $protcolFamily, @configurations);
		my @capacityAtEndSumStatistics = getCapacityAtEndSumStatisticsMultiple($numberOfRuns, 1, $confidence, $protcolFamily, @configurations);
		my @capacityAtEndSumStatisticsShort = getCapacityAtEndSumStatisticsMultiple($numberOfRuns, 0, $confidence, $protcolFamily, @configurations);

		# plot single charts	
		plotUdpPacketLossStatisticsCompare($udpPacketLossFile, $udpPacketLossPlotTitle, $confidence, @udpStatsStatistics);
		plotCapacityAtEndSumStatisticsCompare($capacityAtEndSumFile, $capacityAtEndSumPlotTitle, $confidence, @capacityAtEndSumStatistics);
		plotCapacityAtEndSumStatisticsCompare($capacityAtEndSumFileShort, $capacityAtEndSumPlotTitleShort, $confidence, @capacityAtEndSumStatisticsShort);

		# plot charts for each configuration
		my $position = 0;
		foreach (@configurations) {
			plotUdpPacketLossConfidenceCompareMultiple($confidence, 1, $longTime, $_, $position, @udpStats);
			$position++;
		}
		my $position = 0;
		foreach (@configurations) {
			plotCapacityAtEndSumConfidenceCompareMultiple($confidence, 1, $longTime, $_, $position, @capacityAtEndSum);
			$position++;
		}
		my $position = 0;
		foreach (@configurations) {
			plotCapacityAtEndSumConfidenceCompareMultiple($confidence, 0, $shortTime, $_, $position, @capacityAtEndSumShort);
			$position++;
		}
	}
	
	case "studyCompare" {
		# get parameters
		shift;
			my $protcolFamily = $ARGV[0];
		shift;
			my $decimalplaces = $ARGV[0];
		
		# create some variables
		my $xValues = 0;
		my $yValues = 0;
		my @capacityAtEndDataX;
		my @capacityAtEndDataY;
		my @capacityAtEndDataZ;
		my @capacityAtEndDataShortX;
		my @capacityAtEndDataShortY;
		my @capacityAtEndDataShortZ;
		my @udpStatsDataX;
		my @udpStatsDataY;
		my @udpStatsDataZ;
		my @rttDataX;
		my @rttDataY;
		my @rttDataZ;
		my @end2EndDataX;
		my @end2EndDataY;
		my @end2EndDataZ;
		my @overheadDataX;
		my @overheadDataY;
		my @overheadDataZ;
		my @overheadCalculatedDataX;
		my @overheadCalculatedDataY;
		my @overheadCalculatedDataZ;
		my @sentBytesDataX;
		my @sentBytesDataY;
		my @sentBytesDataZ;
		my @performanceDataX;
		my @performanceDataY;
		my @performanceDataZ;
		my $runcounter = 0;

		# count repeats
		foreach (glob("./results/".$protcolFamily."POParameterStudy*#0*CapacityAtEnd-Clean.csv")) {
			my $newfile = $_;	
			$runcounter = 0;
			while ( -e $newfile ) {	
				my $newcounter = $runcounter + 1;
				$newfile =~ s/#$runcounter/#$newcounter/g;
				$runcounter++;				
			}
		}
		
		# create data arrays for long version
		foreach (glob("./results/".$protcolFamily."POParameterStudy*#0*CapacityAtEnd-Clean.csv")) {
			for ( my $run = 0; $run < $runcounter; $run++ ) {
				my $filename = $_;
				my $newcounter = $run + 1;
				$filename =~ s/#0/#$run/g;

				my @filename = split("-", $filename);
				my @parameters = split(",", $filename[1]);
				my ( $crap, $sensibility ) = split("=", $parameters[0]);
				my ( $crap, $trigger ) = split("=", $parameters[1]);
			
				my $capacityAtEndFilename = $filename;
				my $udpStatsFilename = $filename;
				$udpStatsFilename =~ s/CapacityAtEnd-Clean/UDPStats/g;
				my $rttFilename = $filename;
				$rttFilename =~ s/CapacityAtEnd-Clean/RTT/g;
				my $end2EndFilename = $filename;
				$end2EndFilename =~ s/CapacityAtEnd-Clean/End2End/g;
				my $overheadFilename = $filename;
				$overheadFilename =~ s/CapacityAtEnd-Clean/Overhead/g;
				my $sentBytesFilename = $filename;
				$sentBytesFilename =~ s/CapacityAtEnd-Clean/SentBytes/g;
			
				my @capacityAtEndArray = getCsvAsArray($capacityAtEndFilename);
				my @udpStatsArray = getCsvAsArray($udpStatsFilename);
				my @rttArray = getCsvAsArray($rttFilename);
				my @end2EndArray = getCsvAsArray($end2EndFilename);
				my @overheadArray = getCsvAsArray($overheadFilename);
				my @sentBytesArray = getCsvAsArray($sentBytesFilename);

				if ( $run == 0 ) {			
					push (@udpStatsDataX, $sensibility);
					push (@udpStatsDataY, $trigger);
					push (@rttDataX, $sensibility);
					push (@rttDataY, $trigger);	
					push (@end2EndDataX, $sensibility);
					push (@end2EndDataY, $trigger);	
					push (@sentBytesDataX, $sensibility);
					push (@sentBytesDataY, $trigger);	
					push (@overheadDataX, $sensibility);
					push (@overheadDataY, $trigger);	
					push (@overheadCalculatedDataX, $sensibility);
					push (@overheadCalculatedDataY, $trigger);	
					push (@capacityAtEndDataX, $sensibility);
					push (@capacityAtEndDataY, $trigger);
					push (@performanceDataX, $sensibility);
					push (@performanceDataY, $trigger);	
				}

				push (@{$udpStatsDataZ[$newcounter]}, ( $udpStatsArray[2][41] / ++$udpStatsArray[1][41]) * 100);

				push (@{$rttDataZ[$newcounter]}, 1 - $rttArray[1][41]);

				push (@{$end2EndDataZ[$newcounter]}, 1 - $end2EndArray[1][41]);

				push (@{$sentBytesDataZ[$newcounter]}, $sentBytesArray[1][41]);

				my $overheadDataArrayLength = @overheadArray;
				my $overheadDataSum = 0;
				for ( my $i = 1; $i < $overheadDataArrayLength; $i++ ) { $overheadDataSum += $overheadArray[$i][41]; }
				push (@{$overheadDataZ[$newcounter]}, $overheadDataSum);

				push (@{$overheadCalculatedDataZ[$newcounter]}, 100 - ($overheadDataSum / ($sentBytesArray[1][41] + 1) * 100) );
			
				push (@{$capacityAtEndDataZ[$newcounter]}, 1 - ( stddev(@{$capacityAtEndArray[1]}) + 0.0000000000000001) );
			
				push (@{$performanceDataZ[$newcounter]}, ( 1 - ( stddev(@{$capacityAtEndArray[1]}) + 0.0000000000000001 ) ) / ( ( ( 1 - ( $udpStatsArray[2][41] / ++$udpStatsArray[1][41] ) ) * 100 ) + 0.0000000000000001 ));
			}
		}
		
		# create data arrays for long version
		foreach (glob("./results/".$protcolFamily."POParameterStudy*#0*CapacityAtEnd-Clean-Short.csv")) {
			for ( my $run = 0; $run < $runcounter; $run++ ) {
				my $filename = $_;
				my $newcounter = $run + 1;
				$filename =~ s/#0/#$run/g;

				my @filename = split("-", $filename);
				my @parameters = split(",", $filename[1]);
				my ( $crap, $sensibility ) = split("=", $parameters[0]);
				my ( $crap, $trigger ) = split("=", $parameters[1]);
			
				my $capacityAtEndFilename = $filename;
			
				my @capacityAtEndArray = getCsvAsArray($capacityAtEndFilename);

				if ( $run == 0 ) {				
					push (@capacityAtEndDataShortX, $sensibility);
					push (@capacityAtEndDataShortY, $trigger);
				}
				push (@{$capacityAtEndDataShortZ[$newcounter]}, 1 - ( stddev(@{$capacityAtEndArray[1]}) + 0.0000000000000001) );
			}
		}

		# write mean data to array's first row
		my $udpStatsDataZLength = @{$udpStatsDataZ[1]};
		for ( my $column = 0; $column < $udpStatsDataZLength; $column++ ) {
			my @meanValues = ();
			for ( my $run = 0; $run < $runcounter; $run++ ) {
				push (@meanValues, $udpStatsDataZ[$run+1][$column]);
			}
			push (@{$udpStatsDataZ[0]}, mean(@meanValues));
		}
		my $rttDataZLength = @{$rttDataZ[1]};
		for ( my $column = 0; $column < $rttDataZLength; $column++ ) {
			my @meanValues = ();
			for ( my $run = 0; $run < $runcounter; $run++ ) {
				push (@meanValues, $rttDataZ[$run+1][$column]);
			}
			push (@{$rttDataZ[0]}, mean(@meanValues));
		}
		my $end2EndDataZLength = @{$end2EndDataZ[1]};
		for ( my $column = 0; $column < $end2EndDataZLength; $column++ ) {
			my @meanValues = ();
			for ( my $run = 0; $run < $runcounter; $run++ ) {
				push (@meanValues, $end2EndDataZ[$run+1][$column]);
			}
			push (@{$end2EndDataZ[0]}, mean(@meanValues));
		}
		my $overheadDataZLength = @{$overheadDataZ[1]};
		for ( my $column = 0; $column < $overheadDataZLength; $column++ ) {
			my @meanValues = ();
			for ( my $run = 0; $run < $runcounter; $run++ ) {
				push (@meanValues, $overheadDataZ[$run+1][$column]);
			}
			push (@{$overheadDataZ[0]}, mean(@meanValues));
		}
		my $overheadCalculatedDataZLength = @{$overheadCalculatedDataZ[1]};
		for ( my $column = 0; $column < $overheadCalculatedDataZLength; $column++ ) {
			my @meanValues = ();
			for ( my $run = 0; $run < $runcounter; $run++ ) {
				push (@meanValues, $overheadCalculatedDataZ[$run+1][$column]);
			}
			push (@{$overheadCalculatedDataZ[0]}, mean(@meanValues));
		}
		my $sentBytesDataZLength = @{$sentBytesDataZ[1]};
		for ( my $column = 0; $column < $sentBytesDataZLength; $column++ ) {
			my @meanValues = ();
			for ( my $run = 0; $run < $runcounter; $run++ ) {
				push (@meanValues, $sentBytesDataZ[$run+1][$column]);
			}
			push (@{$sentBytesDataZ[0]}, mean(@meanValues));
		}
		my $capacityAtEndDataZLength = @{$capacityAtEndDataZ[1]};
		for ( my $column = 0; $column < $capacityAtEndDataZLength; $column++ ) {
			my @meanValues = ();
			for ( my $run = 0; $run < $runcounter; $run++ ) {
				push (@meanValues, $capacityAtEndDataZ[$run+1][$column]);
			}
			push (@{$capacityAtEndDataZ[0]}, mean(@meanValues));
		}
		my $performanceDataZLength = @{$performanceDataZ[1]};
		for ( my $column = 0; $column < $performanceDataZLength; $column++ ) {
			my @meanValues = ();
			for ( my $run = 0; $run < $runcounter; $run++ ) {
				push (@meanValues, $performanceDataZ[$run+1][$column]);
			}
			push (@{$performanceDataZ[0]}, mean(@meanValues));
		}
		my $capacityAtEndDataShortZLength = @{$capacityAtEndDataShortZ[1]};
		for ( my $column = 0; $column < $capacityAtEndDataShortZLength; $column++ ) {
			my @meanValues = ();
			for ( my $run = 0; $run < $runcounter; $run++ ) {
				push (@meanValues, $capacityAtEndDataShortZ[$run+1][$column]);
			}
			push (@{$capacityAtEndDataShortZ[0]}, mean(@meanValues));
		}
		
		# write datafiles
		my @capacityAtEndDataShort = ();
		push (@{$capacityAtEndDataShort[0]}, @capacityAtEndDataShortX);
		push (@{$capacityAtEndDataShort[1]}, @capacityAtEndDataShortY);
		push (@{$capacityAtEndDataShort[2]}, @{$capacityAtEndDataShortZ[0]});
		writeGnuplotDatafile("./results/".$protcolFamily."POParameterStudy-CapacityAtEnd-Short.dat", $decimalplaces, @capacityAtEndDataShort);		
		my @capacityAtEndData = ();
		push (@{$capacityAtEndData[0]}, @capacityAtEndDataX);
		push (@{$capacityAtEndData[1]}, @capacityAtEndDataY);
		push (@{$capacityAtEndData[2]}, @{$capacityAtEndDataZ[0]});
		writeGnuplotDatafile("./results/".$protcolFamily."POParameterStudy-CapacityAtEnd.dat", $decimalplaces, @capacityAtEndData);		
		my @udpStatsData = ();
		push (@{$udpStatsData[0]}, @udpStatsDataX);
		push (@{$udpStatsData[1]}, @udpStatsDataY);
		push (@{$udpStatsData[2]}, @{$udpStatsDataZ[0]});
		writeGnuplotDatafile("./results/".$protcolFamily."POParameterStudy-UDPStats.dat", $decimalplaces, @udpStatsData);		
		my @rttData = ();
		push (@{$rttData[0]}, @rttDataX);
		push (@{$rttData[1]}, @rttDataY);
		push (@{$rttData[2]}, @{$rttDataZ[0]});
		writeGnuplotDatafile("./results/".$protcolFamily."POParameterStudy-RTT.dat", $decimalplaces, @rttData);			
		my @end2EndData = ();
		push (@{$end2EndData[0]}, @end2EndDataX);
		push (@{$end2EndData[1]}, @end2EndDataY);
		push (@{$end2EndData[2]}, @{$end2EndDataZ[0]});
		writeGnuplotDatafile("./results/".$protcolFamily."POParameterStudy-End2End.dat", $decimalplaces, @end2EndData);			
		my @overheadData = ();
		push (@{$overheadData[0]}, @overheadDataX);
		push (@{$overheadData[1]}, @overheadDataY);
		push (@{$overheadData[2]}, @{$overheadDataZ[0]});
		writeGnuplotDatafile("./results/".$protcolFamily."POParameterStudy-Overhead.dat", $decimalplaces, @overheadData);			
		my @overheadCalculatedData = ();
		push (@{$overheadCalculatedData[0]}, @overheadCalculatedDataX);
		push (@{$overheadCalculatedData[1]}, @overheadCalculatedDataY);
		push (@{$overheadCalculatedData[2]}, @{$overheadCalculatedDataZ[0]});
		writeGnuplotDatafile("./results/".$protcolFamily."POParameterStudy-OverheadCalculated.dat", $decimalplaces, @overheadCalculatedData);			
		my @sentBytesData = ();
		push (@{$sentBytesData[0]}, @sentBytesDataX);
		push (@{$sentBytesData[1]}, @sentBytesDataY);
		push (@{$sentBytesData[2]}, @{$sentBytesDataZ[0]});
		writeGnuplotDatafile("./results/".$protcolFamily."POParameterStudy-SentBytes.dat", $decimalplaces, @sentBytesData);		
		my @performanceData = ();
		push (@{$performanceData[0]}, @performanceDataX);
		push (@{$performanceData[1]}, @performanceDataY);
		push (@{$performanceData[2]}, @{$performanceDataZ[0]});
		writeGnuplotDatafile("./results/".$protcolFamily."POParameterStudy-Performance.dat", $decimalplaces, @performanceData);
	}
	
	# create html stuff
	case "createHTML" {
		htmlIndex();
		htmlSimulation("AODV", "aodv", "AODV");
		htmlSimulation("AODVPO", "aodvpo", "AODVPO");
		htmlSimulation("AODVPO Trigger Happy", "aodvpotriggerhappy", "AODVPOTriggerHappy");
		htmlSimulation("AODVPO Trigger Sloppy", "aodvpotriggersloppy", "AODVPOTriggerSloppy");
		htmlSimulation("AODV/AODVPO Mixed", "aodvpomixed", "AODVPOMixed");
		htmlSimulation("AODV Multiple", "aodvmultiple", "AODVMultiple");
		htmlSimulation("AODVPO Multiple", "aodvpomultiple", "AODVPOMultiple");
		htmlSimulation("AODV MultiHop", "aodvmultihop", "AODVMultiHop");
		htmlSimulation("AODVPO MultiHop", "aodvpomultihop", "AODVPOMultiHop");
		htmlSimulation("AODV Different Charge", "aodvdiffcharge", "AODVDifferentCapacity");
		htmlSimulation("AODVPO Different Charge", "aodvpodiffcharge", "AODVPODifferentCapacity");
		htmlSimulation("OLSR", "olsr", "OLSR");
		htmlSimulation("OLSRPO", "olsrpo", "OLSRPO");
		htmlSimulation("OLSRPO Trigger Happy", "olsrpotriggerhappy", "OLSRPOTriggerHappy");
		htmlSimulation("OLSRPO Trigger Sloppy", "olsrpotriggersloppy", "OLSRPOTriggerSloppy");
		htmlSimulation("OLSR/OLSRPO Mixed", "olsrpomixed", "OLSRPOMixed");
		htmlSimulation("OLSR Multiple", "olsrmultiple", "OLSRMultiple");
		htmlSimulation("OLSRPO Multiple", "olsrpomultiple", "OLSRPOMultiple");
		htmlSimulation("OLSR MultiHop", "olsrmultihop", "OLSRMultiHop");
		htmlSimulation("OLSRPO MultiHop", "olsrpomultihop", "OLSRPOMultiHop");
		htmlSimulation("OLSR Different Charge", "olsrdiffcharge", "OLSRDifferentCapacity");
		htmlSimulation("OLSRPO Different Charge", "olsrpodiffcharge", "OLSRPODifferentCapacity");
		htmlStudy("AODVPO", "aodvstudy", "AODVPOParameterStudy");
		htmlStudy("OLSRPO", "olsrstudy", "OLSRPOParameterStudy");
		htmlCompare("compare", "Compare");
		htmlSummary("summary", "Summary");
	}
	
	# if no mode given, print help
	else {
		print "\n";
		print "plot.pl - converts data and creates charts with GNUPLOT\n";
		print "    usage: plot.pl [mode] (options)\n";
		print "\n";
		print "    plot.pl singleCapacity RESULTNAME DROPOUT SHORTTIME LONGTIME\n";
		print "        generate capacity charts and data for given \n";
		print "    plot.pl compareProtocols TITLE REPETITIONS CONFIDENCE SHORTTIME LONGTIME CONFIG1 CONFIG2 ...\n";
		print "        generate multiprotocol-comparision for given configurations\n";
		print "    plot.pl compareSending TITLE REPETITIONS CONFIDENCE SHORTTIME LONGTIME CONFIG1 CONFIG2 ...\n";
		print "        generate multiprotocol-comparision for given configurations on random recipients\n";
		print "    plot.pl compareProtocol [AODV|OLSR] REPETITIONS CONFIDENCE SHORTTIME LONGTIME CONFIG1 CONFIG2 ...\n";
		print "        generate comparision for given configurations\n";
		print "    plot.pl studyCompare [AODV|OLSR]\n";
		print "        generate comparision for given parameter study\n";
		print "    plot.pl studyCapacity RESULTNAME DROPOUT SHORTTIME LONGTIME\n";
		print "        generate capacity charts and data for given parameter study result\n";
		print "    plot.pl createHTML\n";
		print "        creates HTML reports\n";
		print "    plot.pl help\n";
		print "        print this help\n";
		print "\n";
	}
}

