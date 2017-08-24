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
		my $dropoutInterval = $ARGV[2];
		my $shortTime = $ARGV[3];
		
		# filenames
		my $capacityOriginalFile = "results/$ARGV[1]-CapacityOverTime.csv";
		my $capacityOverTimeCsvFile = "results/$ARGV[1]-CapacityOverTime-Clean.csv";
		my $capacityOverTimeCsvFileShort = "results/$ARGV[1]-CapacityOverTime-Clean-Short.csv";
		my $capacityAtEndCsvFile = "results/$ARGV[1]-CapacityAtEnd-Clean.csv";
		my $capacityAtEndCsvFileShort = "results/$ARGV[1]-CapacityAtEnd-Clean-Short.csv";
		my $capacityAtEndPlotFile = "export/$ARGV[1]-CapacityAtEnd.png";
		my $capacityAtEndPlotFileShort = "export/$ARGV[1]-CapacityAtEnd-Short.png";
		my $capacityAtEndPlotTitle = "$ARGV[1]";
		my $capacityAtEndPlotTitleShort = "$ARGV[1] (".$shortTime."s)";
		
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
		my @configurations = @ARGV;
		
		# filenames
		my $capacityAtEndPlotFile = "export/$protcolFamily-CapacityAtEndStatistics.png";
		my $capacityAtEndPlotFileShort = "export/$protcolFamily-CapacityAtEndStatistics-Short.png";
		my $capacityAtEndPlotTitle = "$protcolFamily ($numberOfRuns repetitions)";
		my $capacityAtEndPlotTitleShort = "$protcolFamily (".$shortTime."s) ($numberOfRuns repetitions)";
		
		# read data
		my @capacityAtEndDataStatistics = getCapacityAtEndStatistic($numberOfRuns, 1, $confidence, @configurations);
		my @capacityAtEndDataStatisticsShort = getCapacityAtEndStatistic($numberOfRuns, 0, $confidence, @configurations);
		my @capacityAtEndData = getCapacityAtEndArray($numberOfRuns, 1, $confidence, @configurations);
		my @capacityAtEndDataShort = getCapacityAtEndArray($numberOfRuns, 0, $confidence, @configurations);
	
		plotCapacityAtEndStatistics($capacityAtEndPlotFile, $capacityAtEndPlotTitle, $confidence, @capacityAtEndDataStatistics);
		plotCapacityAtEndStatistics($capacityAtEndPlotFileShort, $capacityAtEndPlotTitleShort, $confidence, @capacityAtEndDataStatisticsShort);
		
		my $position = 0;
		foreach (@configurations) {
			plotCapacityAtEndConfidence($confidence, $_, $position, @capacityAtEndData);
			plotCapacityAtEndConfidence($confidence, $_, $position, @capacityAtEndDataShort);
			$position++;
		}
		
		
	}
}

