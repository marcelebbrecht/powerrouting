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
		my $performanceLossFile = "export/Summary/Performance/Full/$protcolFamily-PerformanceStatistics.png";
		my $capacityAtEndPlotTitle = "$protcolFamily (".$longTime."s) ($numberOfRuns repetitions)";
		my $capacityAtEndPlotTitleShort = "$protcolFamily (".$shortTime."s) ($numberOfRuns repetitions)";
		my $udpPacketLossPlotTitle = "$protcolFamily (".$longTime."s) ($numberOfRuns repetitions)";
		my $performancePlotTitle = "$protcolFamily (".$longTime."s) ($numberOfRuns repetitions)";
		
		# read data
		my @capacityAtEndDataStatistics = getCapacityAtEndStatistic($numberOfRuns, 1, $confidence, @configurations);
		my @capacityAtEndDataStatisticsShort = getCapacityAtEndStatistic($numberOfRuns, 0, $confidence, @configurations);
		my @capacityAtEndData = getCapacityAtEndArray($numberOfRuns, 1, $confidence, @configurations);
		my @capacityAtEndDataShort = getCapacityAtEndArray($numberOfRuns, 0, $confidence, @configurations);		
		my @udpStats = getUdpPacketLossArray($numberOfRuns, $confidence, $protcolFamily, @configurations);
		my @udpStatsStatistics = getUdpPacketLossStatistics($numberOfRuns, $confidence, $protcolFamily, @configurations);
		
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
		my $performanceLossFile = "export/Compare/Performance/Full/$protcolFamily-PerformanceStatistics.png";
		my $capacityAtEndPlotTitle = "$protcolFamily (".$longTime."s) ($numberOfRuns repetitions)";
		my $capacityAtEndPlotTitleShort = "$protcolFamily (".$shortTime."s) ($numberOfRuns repetitions)";
		my $udpPacketLossPlotTitle = "$protcolFamily (".$longTime."s) ($numberOfRuns repetitions)";
		my $performancePlotTitle = "$protcolFamily (".$longTime."s) ($numberOfRuns repetitions)";
		
		# read data
		my @capacityAtEndDataStatistics = getCapacityAtEndStatistic($numberOfRuns, 1, $confidence, @configurations);
		my @capacityAtEndDataStatisticsShort = getCapacityAtEndStatistic($numberOfRuns, 0, $confidence, @configurations);
		my @capacityAtEndData = getCapacityAtEndArray($numberOfRuns, 1, $confidence, @configurations);
		my @capacityAtEndDataShort = getCapacityAtEndArray($numberOfRuns, 0, $confidence, @configurations);		
		my @udpStats = getUdpPacketLossArray($numberOfRuns, $confidence, $protcolFamily, @configurations);
		my @udpStatsStatistics = getUdpPacketLossStatistics($numberOfRuns, $confidence, $protcolFamily, @configurations);
		
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
			plotPerformanceConfidenceCompare($confidence, 1, $longTime, $_, $position, @performanceArray);
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
			
				my @capacityAtEndArray = getCsvAsArray($capacityAtEndFilename);
				my @udpStatsArray = getCsvAsArray($udpStatsFilename);

				if ( $run == 0 ) {			
					push (@udpStatsDataX, $sensibility);
					push (@udpStatsDataY, $trigger);	
					push (@capacityAtEndDataX, $sensibility);
					push (@capacityAtEndDataY, $trigger);
					push (@performanceDataX, $sensibility);
					push (@performanceDataY, $trigger);	
				}

				push (@{$udpStatsDataZ[$newcounter]}, ( $udpStatsArray[2][41] / ++$udpStatsArray[1][41]) * 100);
			
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
		htmlSimulation("OLSR", "olsr", "OLSR");
		htmlSimulation("OLSRPO", "olsrpo", "OLSRPO");
		htmlSimulation("OLSRPO Trigger Happy", "olsrpotriggerhappy", "OLSRPOTriggerHappy");
		htmlSimulation("OLSRPO Trigger Sloppy", "olsrpotriggersloppy", "OLSRPOTriggerSloppy");
		htmlSimulation("OLSR/OLSRPO Mixed", "olsrpomixed", "OLSRPOMixed");
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

