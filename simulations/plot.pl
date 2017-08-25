# PowerRouting for OMNeT++ - plot.pl
# Marcel Ebbrecht, marcel.ebbrecht@googlemail.com
# free software, see LICENSE.md for details

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
		my @protocol = split("-", $title);
		
		# filenames
		my $capacityOriginalFile = "results/$title-CapacityOverTime.csv";
		my $capacityOverTimeCsvFile = "results/$title-CapacityOverTime-Clean.csv";
		my $capacityOverTimeCsvFileShort = "results/$title-CapacityOverTime-Clean-Short.csv";
		my $capacityAtEndCsvFile = "results/$title-CapacityAtEnd-Clean.csv";
		my $capacityAtEndCsvFileShort = "results/$title-CapacityAtEnd-Clean-Short.csv";
		my $capacityAtEndPlotFile = "export/$protocol[0]/$title-CapacityAtEnd.png";
		my $capacityAtEndPlotFileShort = "export/$protocol[0]/$title-CapacityAtEnd-Short.png";
		my $capacityAtEndPlotTitle = "$title (".$longTime."s)";
		my $capacityAtEndPlotTitleShort = "$title (".$shortTime."s)";
		
		# create csv for external plot
		my @resultsCapacity = getCapacityResults($capacityOriginalFile, $dropoutInterval);
		my @resultsCapacityShort = getCapacityResultsShort($shortTime, @resultsCapacity);
		my @resultsCapacityAtEnd = getMinimumCapacityValues(@resultsCapacity);
		my @resultsCapacityShortAtEnd = getMinimumCapacityValues(@resultsCapacityShort);
		writeCapacityArrayToCsv($capacityOverTimeCsvFile, @resultsCapacity);
		writeCapacityArrayToCsv($capacityOverTimeCsvFileShort, @resultsCapacityShort);
		writeCapacityArrayToCsv($capacityAtEndCsvFile, @resultsCapacityAtEnd);
		writeCapacityArrayToCsv($capacityAtEndCsvFileShort, @resultsCapacityShortAtEnd);
		
		# plot charts
		plotCapacityAtEnd($capacityAtEndPlotFile, $capacityAtEndPlotTitle, @resultsCapacityAtEnd);
		plotCapacityAtEnd($capacityAtEndPlotFileShort, $capacityAtEndPlotTitleShort, @resultsCapacityShortAtEnd);
	}
	
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
		
		# filenames
		my $capacityAtEndPlotFile = "export/Summary/$protcolFamily-CapacityAtEndStatistics.png";
		my $capacityAtEndPlotFileShort = "export/Summary/$protcolFamily-CapacityAtEndStatistics-Short.png";
		my $udpPacketLossFile = "export/Summary/$protcolFamily-UdpPacketLossStatistics-Short.png";
		my $capacityAtEndPlotTitle = "$protcolFamily (".$longTime."s) ($numberOfRuns repetitions)";
		my $capacityAtEndPlotTitleShort = "$protcolFamily (".$shortTime."s) ($numberOfRuns repetitions)";
		my $udpPacketLossPlotTitle = "$protcolFamily (".$longTime."s) ($numberOfRuns repetitions)";
		
		# read data
		my @capacityAtEndDataStatistics = getCapacityAtEndStatistic($numberOfRuns, 1, $confidence, @configurations);
		my @capacityAtEndDataStatisticsShort = getCapacityAtEndStatistic($numberOfRuns, 0, $confidence, @configurations);
		my @capacityAtEndData = getCapacityAtEndArray($numberOfRuns, 1, $confidence, @configurations);
		my @capacityAtEndDataShort = getCapacityAtEndArray($numberOfRuns, 0, $confidence, @configurations);		
		my @udpStats = getUdpPacketLossArray($numberOfRuns, $confidence, $protcolFamily, @configurations);
		my @udpStatsStatistics = getUdpPacketLossStatistics($numberOfRuns, $confidence, $protcolFamily, @configurations);
			
		plotCapacityAtEndStatistics($capacityAtEndPlotFile, $capacityAtEndPlotTitle, $confidence, @capacityAtEndDataStatistics);
		plotCapacityAtEndStatistics($capacityAtEndPlotFileShort, $capacityAtEndPlotTitleShort, $confidence, @capacityAtEndDataStatisticsShort);
		plotUdpPacketLossStatistics($udpPacketLossFile, $udpPacketLossPlotTitle, $confidence, @udpStatsStatistics);
		
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
		
		my @performanceArrayCarrier = ();
		push @performanceArrayCarrier, @capacityAtEndData;
		push @performanceArrayCarrier, @udpStats;
		my @performanceArray = getPerformanceArray(@performanceArrayCarrier);
		
		my @performanceStatisticsCarrier = ();
		push @performanceStatisticsCarrier, @capacityAtEndDataStatistics;
		push @performanceStatisticsCarrier, @udpStatsStatistics;
		my @performanceStatistics = getPerformanceStatistics(@performanceStatisticsCarrier);
	}
}

