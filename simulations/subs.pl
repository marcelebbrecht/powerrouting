# PowerRouting for OMNeT++ - perl subs for plot.pl
# Marcel Ebbrecht, marcel.ebbrecht@googlemail.com
# free software, see LICENSE.md for details

# Warning, written by a "dont-care" bash-hacker with
# a bad attitude - dirty but worky, sorry guys, I
# don't like bash - I love it! So dont study the 
# following code, it will harm your coding skills.
# You habe been warned ;)

### settings
my $gnuplotPath = "gnuplot";

### includes
use Statistics::Lite qw(:all);
use Statistics::PointEstimation;
use Chart::Gnuplot;
use strict;

### subroutines
# get capacity results width (column-count, aka number of hosts)
# 1: filename as string
# R: number of columns as integer
sub getCapacityResultsWidth {
	# get parameters
	my $filename = $_[0];
	
	open(FILE, "<", $filename);
	my $line = <FILE>;
	my @line = split("," , $line);
	my $resultsWidth = @line;
	close FILE;
	return $resultsWidth;
}

# get capacity results length (line-count, aka number of datasets)
# 1: filename as string
# R: number of lines as integer
sub getCapactityResultsLength {
	# get parameters
	my $filename = $_[0];
	
	open(FILE, "<", $filename);
	my $resultsLength = 0;
	while (my $line = <FILE>) {
		$resultsLength++;
	}
	close FILE;
	return $resultsLength;
}

# get capacity results array (reads file and return)
# 1: filename as string
# 2: dropout interval as integer
# R: two dimensional array with complete logfile
sub getCapacityResults {
	# get parameters
	my $filename = $_[0];
	shift;
	my $interval = $_[0];
	shift;
	my $decimalplaces = $_[0];
	
	# get information
	my $resultsLength = getCapactityResultsLength($filename) / $interval + $interval;
	my $resultsWidth = getCapacityResultsWidth($filename);
	
	# create array
	my @results = ();
	foreach my $i ( 0 .. $resultsLength-1 ) {
		foreach my $j ( 0 .. $resultsWidth-1 ) {
			push @{ $results[$i] }, $j;
		}
	}

	# read file by line and write to new file and array
	open(FILE, "<", $filename);
	my @lastValues;
	my $actualLine = 0;
	my $actualFile = 0;
	while (my $line = <FILE>) {
		if ( $actualFile < $interval || $actualFile % $interval == 0 ) {
			my @line = split("," , $line);
			my $actualColumn = 0;
			foreach (@line) { 
				chomp $_;
				if ( "$_" =~ "[a-zA-Z0-9]" ) { 
					if ( $actualLine == 0 ) {
						$lastValues[$actualColumn] = $_;
						$results[$actualLine][$actualColumn] = $_;
					} else {
						$lastValues[$actualColumn] = sprintf("%.".$decimalplaces."f", $_);
						$results[$actualLine][$actualColumn] = sprintf("%.".$decimalplaces."f", $_);
					}
					
				} else {
					$results[$actualLine][$actualColumn] = $lastValues[$actualColumn];
				}
				$actualColumn++;
			}
			$actualLine++;
		}
		$actualFile++;
	}
	close FILE;
	
	# remove last element of array
	my $length = @results;
	splice(@results, $length-1, 1);
	
	# rename hostname entries
	$results[0][0] = "t";
	for (my $actualColumn = 1; $actualColumn < $resultsWidth; $actualColumn++) {
		my $string = $results[0][$actualColumn];
		my @fullname = split('\.', $string);
		$results[0][$actualColumn] = $fullname[1];
	}
	
	return @results;
}

# get cs as array (reads file and return)
# 1: filename as string
# R: two dimensional array with complete logfile
sub getCsvAsArray {
	# get parameters
	my $filename = $_[0];
	
	# get information
	my $resultsWidth = getCapacityResultsWidth($filename);
	
	# create array
	my @results = ();
	foreach my $i ( 0 .. 1 ) {
		foreach my $j ( 0 .. $resultsWidth-1 ) {
			push @{ $results[$i] }, $j;
		}
	}

	# read file by line and write to new file and array
	open(FILE, "<", $filename);
	my $actualLine = 0;
	while (my $line = <FILE>) {
		my @line = split("," , $line);
		my $actualColumn = 0;
		foreach (@line) { 
			chomp $_;
			$results[$actualLine][$actualColumn] = $_;
			$actualColumn++;
		}
		$actualLine++;
	}
	close FILE;
	
	return @results;
}

# convert capacity results array to shorter one
# 1: time in seconds
# 2: two dimensional array with complete logfile
# R: shorter two dimensional array with complete logfile
sub getCapacityResultsShort {
	# get parameters
	my $timelimit = $_[0];
	shift;
	my @capacityResults = @_;
	
	# fill new array until timelimit
	my @capacityResultsShort = ();
	$capacityResultsShort[0] = $capacityResults[0];
	my $timelimitRow = 1;
	while ( $capacityResults[$timelimitRow][0] < $timelimit ) {
		$capacityResultsShort[$timelimitRow] = $capacityResults[$timelimitRow];
		$timelimitRow++;
	}	
	
	return @capacityResultsShort;	
}

# write new capacity file
# 1: filename as string
# 2: results as array
# R: void
sub writeCapacityArrayToCsv {
	# get parameters
	my $filename = $_[0];
	shift;
	my @results = @_;
	
	# get information
	my $resultsLength = @results;
	my $resultsWidth = @{$results[0]};
	
	# create capacity file
	open(FILE, ">", $filename);
	for (my $row = 0; $row < $resultsLength; $row++) {
		foreach my $column ( 0 .. $resultsWidth-1 ) {
			print FILE "$results[$row][$column]";
			if ( $column < $resultsWidth-1 ) {
				print FILE ",";
			}
		}
		print FILE "\n";
	}
	close FILE;
}

# write new gnuplot data file
# 1: filename as string
# 2: decimal places as integer
# 3: results as array
# R: void
sub writeGnuplotDatafile {
	# get parameters
	my $filename = $_[0];
	shift;
	my $decimalplaces = $_[0];
	shift;
	my @resultsX = @{$_[0]};
	my @resultsY = @{$_[1]};
	my @resultsZ = @{$_[2]};
		
	# create capacity file
	open(FILE, ">", $filename);
	
	my $x=0;
	foreach (@resultsX) {
		print FILE $_." ".$resultsY[$x]." ".sprintf("%.".$decimalplaces."f", $resultsZ[$x])."\n";
		$x++;
	}
	close FILE;
}

# create array with minumum values
# 1: array with results
# R: array with minimum values
sub getMinimumCapacityValues {
	# get parameters
	my @results = @_;
	
	# get information
	my $resultsLength = @results;
	my $resultsWidth = @{$results[0]};
	
	# create array for minimum values
	my @minArray = ();
	foreach my $i ( 0 .. 1 ) {
		foreach my $j ( 0 .. $resultsWidth-2 ) {
			push @{ $minArray[$i] }, $j;
		}
	}
	
	# fill array with minimum values
	for ( my $hostNumber = 1; $hostNumber < $resultsWidth; $hostNumber++) {
		my @tempArray = ();
		for ( my $actualLine = 1; $actualLine < $resultsLength; $actualLine++ ) {
			$tempArray[$actualLine-1] = @{$results[$actualLine]}[$hostNumber];
		}
		$minArray[0][$hostNumber-1] = $results[0][$hostNumber];
		$minArray[0][$hostNumber-1] =~ s/[a-zA-Z]//g;
		$minArray[1][$hostNumber-1] = min(@tempArray);
	}
	
	return @minArray;
}

# create capacity at end array
# 1: number of runs as integer
# 2: long version = 1, short version = 0
# 3: confidence as integer
# 4: configurations as array
# R: array with statistical data
#	row(n) -> stddev, row(n+1) -> min, row(n+2) -> max, 
#	row(n+3) -> lower-clm, row(n+4) -> upper-clm, row(n+5) -> error
sub getCapacityAtEndArray {
	my $numberOfRuns = $_[0];
	shift;
	my $longVersion = $_[0];
	shift;
	my $confidence = $_[0];
	shift;
	my @configurations = @_;
	
	# first: create capacity stddev
	my $capacityAtEndDataWidth = $numberOfRuns;
	my $capacityAtEndDataLength = @configurations;
	
	# create array for minimum values
	my @capacityAtEndData = ();

	# iterate over configurations
	my $configuration = 0;
	foreach (@configurations) {
	    # write stddev to subarrays
		for ( my $run = 0; $run < $numberOfRuns; $run++) {
			my @results;
			if ( $longVersion == 1 ) {
				@results = getCsvAsArray("results/$_-#$run-CapacityAtEnd-Clean.csv", 1);
			} else {
				@results = getCsvAsArray("results/$_-#$run-CapacityAtEnd-Clean-Short.csv", 1);
			}
			$capacityAtEndData[$configuration][$run] = stddev(@{$results[1]});
		}
		
		# calculate statistical data and write end of array
		my $configurationMean = mean(@{$capacityAtEndData[$configuration]});
		my $configurationMin = min(@{$capacityAtEndData[$configuration]});
		my $configurationMax = max(@{$capacityAtEndData[$configuration]});						
		my $stats = new Statistics::PointEstimation;
		$stats->set_significance($confidence);
		$stats->add_data(@{$capacityAtEndData[$configuration]});
		push @{$capacityAtEndData[$configuration]}, $configurationMean;
		push @{$capacityAtEndData[$configuration]}, $configurationMin;
		push @{$capacityAtEndData[$configuration]}, $configurationMax;
		push @{$capacityAtEndData[$configuration]}, $stats->lower_clm();
		push @{$capacityAtEndData[$configuration]}, $stats->upper_clm();
		push @{$capacityAtEndData[$configuration]}, $stats->upper_clm() - $configurationMean;
			
		$configuration++;
	}
	
	return @capacityAtEndData;	
}

# create capacity at end statistic
# 1: number of runs as integer
# 2: long version = 1, short version = 0
# 3: confidence as integer
# 4: configurations as array
# R: array with statistical data
#	row0 -> name, row1 -> stddev, row2 -> min, row3 -> max, 
#	row4 -> lower-clm, row5 -> upper-clm, row6 -> error
sub getCapacityAtEndStatistic {
	my $numberOfRuns = $_[0];
	shift;
	my $longVersion = $_[0];
	shift;
	my $confidence = $_[0];
	shift;
	my @configurations = @_;
	
	# first: create capacity stddev
	my $capacityAtEndDataWidth = $numberOfRuns;
	my $capacityAtEndDataLength = @configurations;
	
	# create array for minimum values
	my @capacityAtEndData = ();

	# iterate over configurations
	my $configuration = 0;
	foreach (@configurations) {
	    # write stddev to subarrays
		for ( my $run = 0; $run < $numberOfRuns; $run++) {
			my @results;
			if ( $longVersion == 1 ) {
				@results = getCsvAsArray("results/$_-#$run-CapacityAtEnd-Clean.csv", 1);
			} else {
				@results = getCsvAsArray("results/$_-#$run-CapacityAtEnd-Clean-Short.csv", 1);
			}
			$capacityAtEndData[$configuration][$run] = stddev(@{$results[1]});
		}
		
		# calculate statistical data and write end of array
		my $configurationMean = mean(@{$capacityAtEndData[$configuration]});
		my $configurationMin = min(@{$capacityAtEndData[$configuration]});
		my $configurationMax = max(@{$capacityAtEndData[$configuration]});						
		my $stats = new Statistics::PointEstimation;
		$stats->set_significance($confidence);
		$stats->add_data(@{$capacityAtEndData[$configuration]});
		push @{$capacityAtEndData[$configuration]}, $configurationMean;
		push @{$capacityAtEndData[$configuration]}, $configurationMin;
		push @{$capacityAtEndData[$configuration]}, $configurationMax;
		push @{$capacityAtEndData[$configuration]}, $stats->lower_clm();
		push @{$capacityAtEndData[$configuration]}, $stats->upper_clm();
		push @{$capacityAtEndData[$configuration]}, $stats->upper_clm() - $configurationMean;
			
		$configuration++;
	}
	
	# rerun, write final statistics array
	my @capacityAtEndDataStatistics = ();
		
	my $configuration = 0;
	foreach (@configurations) {
		push @{$capacityAtEndDataStatistics[0]}, $_;
		push @{$capacityAtEndDataStatistics[1]}, $capacityAtEndData[$configuration][$numberOfRuns];
		push @{$capacityAtEndDataStatistics[2]}, $capacityAtEndData[$configuration][$numberOfRuns+1];
		push @{$capacityAtEndDataStatistics[3]}, $capacityAtEndData[$configuration][$numberOfRuns+2];
		push @{$capacityAtEndDataStatistics[4]}, $capacityAtEndData[$configuration][$numberOfRuns+3];
		push @{$capacityAtEndDataStatistics[5]}, $capacityAtEndData[$configuration][$numberOfRuns+4];
		push @{$capacityAtEndDataStatistics[6]}, $capacityAtEndData[$configuration][$numberOfRuns+5];
		$configuration++;
	}
	
	return @capacityAtEndDataStatistics;
}

# create udp packet loss array
# 1: number of runs as integer
# 2: confidence as integer
# 3: protocol as string
# 4: configurations as array
# R: array with statistical data
#	row(n) -> stddev, row(n+1) -> min, row(n+2) -> max, 
#	row(n+3) -> lower-clm, row(n+4) -> upper-clm, row(n+5) -> error
sub getUdpPacketLossArray {
	# get parameters
	my $numberOfRuns = $_[0];
	shift;
	my $confidence = $_[0];
	shift;
	my $protocol = $_[0];
	shift;
	my @configurations = @_;
		
	# create UdpPacketLoss data
	my $filename = "results/$protocol-UDPStats.csv";
	my $udpPacketLossDataWidth = $numberOfRuns;
	my $udpPacketLossDataLength = @configurations;
	
	# read file by line and write to new file and array
	my @udpPacketLossData = ();
	my $configuration = 0;
	my $firstvalue = 0;
	foreach (@configurations) {
		open(FILE, "<", $filename);
		while (my $line = <FILE>) {
			my @actline = split("," , $line);
			if ( "$actline[2]" eq "$_") {
			    if ( $firstvalue == 0 ) {
					$firstvalue = $actline[18];
				} else {
					push @{$udpPacketLossData[$configuration]}, (1 - ($actline[18]/++$firstvalue))*100;
					$firstvalue = 0;
				}
			}
		}
		my $configurationMean = mean(@{$udpPacketLossData[$configuration]});
		my $configurationMin = min(@{$udpPacketLossData[$configuration]});
		my $configurationMax = max(@{$udpPacketLossData[$configuration]});	
		my $stats = new Statistics::PointEstimation;
		$stats->set_significance($confidence);
		$stats->add_data(@{$udpPacketLossData[$configuration]});
		push @{$udpPacketLossData[$configuration]}, $configurationMean;
		push @{$udpPacketLossData[$configuration]}, $configurationMin;
		push @{$udpPacketLossData[$configuration]}, $configurationMax;
		push @{$udpPacketLossData[$configuration]}, $stats->lower_clm();
		push @{$udpPacketLossData[$configuration]}, $stats->upper_clm();
		push @{$udpPacketLossData[$configuration]}, $stats->upper_clm() - $configurationMean;
		$configuration++;
		close FILE;
	}
	return @udpPacketLossData;	
}

# create udp packet loss array
# 1: number of runs as integer
# 2: confidence as integer
# 3: protocol as string
# 4: configurations as array
# R: array with statistical data
#	row(n) -> stddev, row(n+1) -> min, row(n+2) -> max, 
#	row(n+3) -> lower-clm, row(n+4) -> upper-clm, row(n+5) -> error
sub getUdpPacketLossArrayMultiple {
	# get parameters
	my $numberOfRuns = $_[0];
	shift;
	my $confidence = $_[0];
	shift;
	my $protocol = $_[0];
	shift;
	my @configurations = @_;
		
	# create UdpPacketLoss data
	my $udpPacketLossDataWidth = $numberOfRuns;
	my $udpPacketLossDataLength = @configurations;
	
	# read file by line and write to new file and array
	my @udpPacketLossData = ();
	my $configuration = 0;
	foreach (@configurations) {
		my $firstvalue = 0;
		my $oldexperiment = "";
		my $sendcount = 0;
		my $recvcount = 0;
		my $firstrun = 0;
		my $filename = "results/$_-UDPStats.csv";
		open(FILE, "<", $filename);
		while (my $line = <FILE>) {
			my @actline = split("," , $line);
			my $actexperiment = $actline[15];

			if ( $firstrun < 2 && "$_" =~ "Multiple" ) {
				$firstrun++;
				$oldexperiment = $actexperiment;
			} elsif ( $firstrun < 1 ) {
				$firstrun++;
				$oldexperiment = $actexperiment;
			} else {
	
				if ( $actexperiment != $oldexperiment ) {
					push @{$udpPacketLossData[$configuration]}, (1 - ($recvcount/++$sendcount))*100;
					$sendcount = 0;
					$recvcount = 0;
					$oldexperiment = $actexperiment;
				}

				if ( "$actline[17]" eq "rcvdPk:count" ) {
					$recvcount += $actline[18];
				} else {
					$sendcount += $actline[18];
				}
			}
		}


		my $configurationMean = mean(@{$udpPacketLossData[$configuration]});
		my $configurationMin = min(@{$udpPacketLossData[$configuration]});
		my $configurationMax = max(@{$udpPacketLossData[$configuration]});	
		my $stats = new Statistics::PointEstimation;
		$stats->set_significance($confidence);
		$stats->add_data(@{$udpPacketLossData[$configuration]});
		push @{$udpPacketLossData[$configuration]}, $configurationMean;
		push @{$udpPacketLossData[$configuration]}, $configurationMin;
		push @{$udpPacketLossData[$configuration]}, $configurationMax;
		push @{$udpPacketLossData[$configuration]}, $stats->lower_clm();
		push @{$udpPacketLossData[$configuration]}, $stats->upper_clm();
		push @{$udpPacketLossData[$configuration]}, $stats->upper_clm() - $configurationMean;
		$configuration++;
		close FILE;
	}
	return @udpPacketLossData;	
}

# create udp packet loss array
# 1: number of runs as integer
# 2: long version = 1, short version = 0
# 3: confidence as integer
# 4: protocol as string
# 5: configurations as array
# R: array with statistical data
#	row(n) -> stddev, row(n+1) -> min, row(n+2) -> max, 
#	row(n+3) -> lower-clm, row(n+4) -> upper-clm, row(n+5) -> error
sub getCapacityAtEndSumArrayMultiple {
	# get parameters
	my $numberOfRuns = $_[0];
	shift;
	my $long = $_[0];
	shift;
	my $confidence = $_[0];
	shift;
	my $protocol = $_[0];
	shift;
	my @configurations = @_;
		
	# create CapacityAtEndSum data
	my $capacityAtEndSumDataWidth = $numberOfRuns;
	my $capacityAtEndSumDataLength = @configurations;
	
	# read file by line and write to new file and array
	my @capacityAtEndSumData = ();
	my $configuration = 0;
	foreach (@configurations) {
	
		my @files = ();
		if ( $long == 1 ) {
		        @files = glob("./results/$_-*CapacityAtEnd-Clean.csv");
		} else {
		        @files = glob("./results/$_-*CapacityAtEnd-Clean-Short.csv");
		}
	        foreach my $file (@files) {
			my $firstrun = 0;
			open(FILE, "<", $file);
			while (my $line = <FILE>) {
				if ( $firstrun == 0 ) {
					$firstrun++;
				} else {
					my @actline = split("," , $line);
					push @{$capacityAtEndSumData[$configuration]}, sum(@actline);
				}
			}
		}

		my $configurationMean = mean(@{$capacityAtEndSumData[$configuration]});
		my $configurationMin = min(@{$capacityAtEndSumData[$configuration]});
		my $configurationMax = max(@{$capacityAtEndSumData[$configuration]});	
		my $stats = new Statistics::PointEstimation;
		$stats->set_significance($confidence);
		$stats->add_data(@{$capacityAtEndSumData[$configuration]});
		push @{$capacityAtEndSumData[$configuration]}, $configurationMean;
		push @{$capacityAtEndSumData[$configuration]}, $configurationMin;
		push @{$capacityAtEndSumData[$configuration]}, $configurationMax;
		push @{$capacityAtEndSumData[$configuration]}, $stats->lower_clm();
		push @{$capacityAtEndSumData[$configuration]}, $stats->upper_clm();
		push @{$capacityAtEndSumData[$configuration]}, $stats->upper_clm() - $configurationMean;
		$configuration++;
		close FILE;
	}
	return @capacityAtEndSumData;	
}

# create udp packet loss statistics
# 1: number of runs as integer
# 2: confidence as integer
# 3: protocol as string
# 4: configurations as array
# R: array with statistical data
#	row(n) -> stddev, row(n+1) -> min, row(n+2) -> max, 
#	row(n+3) -> lower-clm, row(n+4) -> upper-clm, row(n+5) -> error
sub getUdpPacketLossStatistics {
	# get parameters
	my $numberOfRuns = $_[0];
	shift;
	my $confidence = $_[0];
	shift;
	my $protocol = $_[0];
	shift;
	my @configurations = @_;
		
	# create UdpPacketLoss data
	my $filename = "results/$protocol-UDPStats.csv";
	my $udpPacketLossDataWidth = $numberOfRuns;
	my $udpPacketLossDataLength = @configurations;
	
	# read file by line and write to new file and array
	my @udpPacketLossData = ();
	my $configuration = 0;
	my $firstvalue = 0;
	foreach (@configurations) {
		open(FILE, "<", $filename);
		while (my $line = <FILE>) {
			my @actline = split("," , $line);
			if ( "$actline[2]" eq "$_") {
			    if ( $firstvalue == 0 ) {
					$firstvalue = $actline[18];
				} else {
					push @{$udpPacketLossData[$configuration]}, (1 - ($actline[18]/++$firstvalue))*100;
					$firstvalue = 0;
				}
			}
		}
		my $configurationMean = mean(@{$udpPacketLossData[$configuration]});
		my $configurationMin = min(@{$udpPacketLossData[$configuration]});
		my $configurationMax = max(@{$udpPacketLossData[$configuration]});	
		my $stats = new Statistics::PointEstimation;
		$stats->set_significance($confidence);
		$stats->add_data(@{$udpPacketLossData[$configuration]});
		push @{$udpPacketLossData[$configuration]}, $configurationMean;
		push @{$udpPacketLossData[$configuration]}, $configurationMin;
		push @{$udpPacketLossData[$configuration]}, $configurationMax;
		push @{$udpPacketLossData[$configuration]}, $stats->lower_clm();
		push @{$udpPacketLossData[$configuration]}, $stats->upper_clm();
		push @{$udpPacketLossData[$configuration]}, $stats->upper_clm() - $configurationMean;
		$configuration++;
		close FILE;
	}
	
	# rerun, write final statistics array
	my @udpPacketLossDataStatistics = ();
		
	my $configuration = 0;
	foreach (@configurations) {
		push @{$udpPacketLossDataStatistics[0]}, $_;
		push @{$udpPacketLossDataStatistics[1]}, $udpPacketLossData[$configuration][$numberOfRuns];
		push @{$udpPacketLossDataStatistics[2]}, $udpPacketLossData[$configuration][$numberOfRuns+1];
		push @{$udpPacketLossDataStatistics[3]}, $udpPacketLossData[$configuration][$numberOfRuns+2];
		push @{$udpPacketLossDataStatistics[4]}, $udpPacketLossData[$configuration][$numberOfRuns+3];
		push @{$udpPacketLossDataStatistics[5]}, $udpPacketLossData[$configuration][$numberOfRuns+4];
		push @{$udpPacketLossDataStatistics[6]}, $udpPacketLossData[$configuration][$numberOfRuns+5];
		$configuration++;
	}
	
	return @udpPacketLossDataStatistics;	
}

# create udp packet loss statistics
# 1: number of runs as integer
# 2: confidence as integer
# 3: protocol as string
# 4: configurations as array
# R: array with statistical data
#	row(n) -> stddev, row(n+1) -> min, row(n+2) -> max, 
#	row(n+3) -> lower-clm, row(n+4) -> upper-clm, row(n+5) -> error
sub getUdpPacketLossStatisticsMultiple {
	# get parameters
	my $numberOfRuns = $_[0];
	shift;
	my $confidence = $_[0];
	shift;
	my $protocol = $_[0];
	shift;
	my @configurations = @_;
		
	# create UdpPacketLoss data
	my $filename = "results/$protocol-UDPStats.csv";
	my $udpPacketLossDataWidth = $numberOfRuns;
	my $udpPacketLossDataLength = @configurations;
	
	# read file by line and write to new file and array
	my @udpPacketLossData = ();
	my $configuration = 0;
	my $firstvalue = 0;
	foreach (@configurations) {
		my $firstvalue = 0;
		my $oldexperiment = "";
		my $sendcount = 0;
		my $recvcount = 0;
		my $firstrun = 0;
		my $filename = "results/$_-UDPStats.csv";
		open(FILE, "<", $filename);
		while (my $line = <FILE>) {
			my @actline = split("," , $line);
			my $actexperiment = $actline[15];

			if ( $firstrun < 2 && "$_" =~ "Multiple" ) {
				$firstrun++;
				$oldexperiment = $actexperiment;
			} elsif ( $firstrun < 1 ) {
				$firstrun++;
				$oldexperiment = $actexperiment;
			} else {
	
				if ( $actexperiment != $oldexperiment ) {
					push @{$udpPacketLossData[$configuration]}, (1 - ($recvcount/++$sendcount))*100;
					$sendcount = 0;
					$recvcount = 0;
					$oldexperiment = $actexperiment;
				}

				if ( "$actline[17]" eq "rcvdPk:count" ) {
					$recvcount += $actline[18];
				} else {
					$sendcount += $actline[18];
				}
			}
		}

		my $configurationMean = mean(@{$udpPacketLossData[$configuration]});
		my $configurationMin = min(@{$udpPacketLossData[$configuration]});
		my $configurationMax = max(@{$udpPacketLossData[$configuration]});

		my $stats = new Statistics::PointEstimation;
		$stats->set_significance($confidence);
		$stats->add_data(@{$udpPacketLossData[$configuration]});

		push @{$udpPacketLossData[$configuration]}, $configurationMean;
		push @{$udpPacketLossData[$configuration]}, $configurationMin;
		push @{$udpPacketLossData[$configuration]}, $configurationMax;
		push @{$udpPacketLossData[$configuration]}, $stats->lower_clm();
		push @{$udpPacketLossData[$configuration]}, $stats->upper_clm();
		push @{$udpPacketLossData[$configuration]}, $stats->upper_clm() - $configurationMean;

		$configuration++;
		close FILE;
	}
	
	# rerun, write final statistics array
	my @udpPacketLossDataStatistics = ();
		
	my $configuration = 0;
	foreach (@configurations) {
		push @{$udpPacketLossDataStatistics[0]}, $_;
		push @{$udpPacketLossDataStatistics[1]}, $udpPacketLossData[$configuration][$numberOfRuns-1];
		push @{$udpPacketLossDataStatistics[2]}, $udpPacketLossData[$configuration][$numberOfRuns];
		push @{$udpPacketLossDataStatistics[3]}, $udpPacketLossData[$configuration][$numberOfRuns+1];
		push @{$udpPacketLossDataStatistics[4]}, $udpPacketLossData[$configuration][$numberOfRuns+2];
		push @{$udpPacketLossDataStatistics[5]}, $udpPacketLossData[$configuration][$numberOfRuns+3];
		push @{$udpPacketLossDataStatistics[6]}, $udpPacketLossData[$configuration][$numberOfRuns+4];
		$configuration++;
	}
	
	return @udpPacketLossDataStatistics;	
}

# create udp packet loss statistics
# 1: number of runs as integer
# 2: long version = 1, short version = 0
# 3: confidence as integer
# 4: protocol as string
# 5: configurations as array
# R: array with statistical data
#	row(n) -> stddev, row(n+1) -> min, row(n+2) -> max, 
#	row(n+3) -> lower-clm, row(n+4) -> upper-clm, row(n+5) -> error
sub getCapacityAtEndSumStatisticsMultiple {
	# get parameters
	my $numberOfRuns = $_[0];
	shift;
	my $long = $_[0];
	shift;
	my $confidence = $_[0];
	shift;
	my $protocol = $_[0];
	shift;
	my @configurations = @_;
		
	# create UdpPacketLoss data
	my $capacityAtEndSumDataWidth = $numberOfRuns;
	my $capacityAtEndSumDataLength = @configurations;
	
	# read file by line and write to new file and array
	my @capacityAtEndSumData = ();
	my $configuration = 0;
	foreach (@configurations) {
	
		my @files = ();
		if ( $long == 1 ) {
		        @files = glob("./results/$_-*CapacityAtEnd-Clean.csv");
		} else {
		        @files = glob("./results/$_-*CapacityAtEnd-Clean-Short.csv");
		}
	        foreach my $file (@files) {
			my $firstrun = 0;
			open(FILE, "<", $file);
			while (my $line = <FILE>) {
				if ( $firstrun == 0 ) {
					$firstrun++;
				} else {
					my @actline = split("," , $line);
					push @{$capacityAtEndSumData[$configuration]}, sum(@actline);
				}
			}
		}

		my $configurationMean = mean(@{$capacityAtEndSumData[$configuration]});
		my $configurationMin = min(@{$capacityAtEndSumData[$configuration]});
		my $configurationMax = max(@{$capacityAtEndSumData[$configuration]});

		my $stats = new Statistics::PointEstimation;
		$stats->set_significance($confidence);
		$stats->add_data(@{$capacityAtEndSumData[$configuration]});

		push @{$capacityAtEndSumData[$configuration]}, $configurationMean;
		push @{$capacityAtEndSumData[$configuration]}, $configurationMin;
		push @{$capacityAtEndSumData[$configuration]}, $configurationMax;
		push @{$capacityAtEndSumData[$configuration]}, $stats->lower_clm();
		push @{$capacityAtEndSumData[$configuration]}, $stats->upper_clm();
		push @{$capacityAtEndSumData[$configuration]}, $stats->upper_clm() - $configurationMean;

		$configuration++;
		close FILE;
	}
	
	# rerun, write final statistics array
	my @capacityAtEndSumDataStatistics = ();
		
	my $configuration = 0;
	foreach (@configurations) {
		push @{$capacityAtEndSumDataStatistics[0]}, $_;
		push @{$capacityAtEndSumDataStatistics[1]}, $capacityAtEndSumData[$configuration][$numberOfRuns-1];
		push @{$capacityAtEndSumDataStatistics[2]}, $capacityAtEndSumData[$configuration][$numberOfRuns];
		push @{$capacityAtEndSumDataStatistics[3]}, $capacityAtEndSumData[$configuration][$numberOfRuns+1];
		push @{$capacityAtEndSumDataStatistics[4]}, $capacityAtEndSumData[$configuration][$numberOfRuns+2];
		push @{$capacityAtEndSumDataStatistics[5]}, $capacityAtEndSumData[$configuration][$numberOfRuns+3];
		push @{$capacityAtEndSumDataStatistics[6]}, $capacityAtEndSumData[$configuration][$numberOfRuns+4];
		$configuration++;
	}
	
	return @capacityAtEndSumDataStatistics;	
}

# calculate performance array
# 1: confidence as integer
# 2: 3dim array with stddev-array and packetloss-array as elements
# R: 2dim array with performance
sub getPerformanceArray {
	# get parameters
	my $confidence = $_[0];
	shift;
	my @capacityArray = @{$_[0]};
	my @udpArray = @{$_[1]};
	my $columns = @{$capacityArray[0]};
	
	# calculate performance
	my @performanceArray = ();
	my $row = 0;
	foreach (@capacityArray) {
		for (my $column = 0; $column < $columns -6; $column++) {
			$performanceArray[$row][$column] =  ( 1 - ( $capacityArray[$row][$column]  + 0.0000000000000001 ) ) / ( $udpArray[$row][$column] + 0.0000000000000001 );
		}
		my $configurationMean = mean(@{$performanceArray[$row]});
		my $configurationMin = min(@{$performanceArray[$row]});
		my $configurationMax = max(@{$performanceArray[$row]});	
		my $stats = new Statistics::PointEstimation;
		$stats->set_significance($confidence);
		$stats->add_data(@{$performanceArray[$row]});
		push @{$performanceArray[$row]}, $configurationMean;
		push @{$performanceArray[$row]}, $configurationMin;
		push @{$performanceArray[$row]}, $configurationMax;
		push @{$performanceArray[$row]}, $stats->lower_clm();
		push @{$performanceArray[$row]}, $stats->upper_clm();
		push @{$performanceArray[$row]}, $stats->upper_clm() - $configurationMean;		
		$row++;
	}
	return @performanceArray;
}

# calculate performance array
# 1: confidence as integer
# 2: 3dim array with stddev-array and packetloss-array as elements
# R: 2dim array with performance
sub getPerformanceStatistics {
	# get parameters
	my $confidence = $_[0];
	shift;
	my @capacityArray = @{$_[0]};
	my @udpArray = @{$_[1]};
	my $columns = @{$capacityArray[0]};
	
	# calculate performance
	my @performanceArray = ();
	my $row = 0;
	foreach (@capacityArray) {
		for (my $column = 0; $column < $columns; $column++) {
			$performanceArray[$row][$column] =  ( 1 - ( $capacityArray[$row][$column]  + 0.0000000000000001 ) ) / ( $udpArray[$row][$column] + 0.0000000000000001 );
		}
		$row++;
	}
	return @performanceArray;
}

# create capacityAtEnd chart
# 1: filename as string
# 2: title as string
# 3: minimum results as array
# R: void
sub plotCapacityAtEnd {
	# get parameters
	my $filename = $_[0];
	shift;
	my $title = $_[0];
	shift;
	my @minArray = @_;
	
	# plot chart
	my $minimumChart = Chart::Gnuplot->new(
		output => $filename,
		imagesize => '900.0, 600.0',
		timestamp => {
			fmt => '%Y-%m-%d %H:%I:%S',
			font => "Arial, 9",
		},
		terminal => "png",
		title => {
			text => "$title - CapacityAtEnd",
			font => "Arial, 9",
		},
		
		yrange => [0, max(@{$minArray[1]}) * 1.25 ],
  
		xlabel => {
			text => "Router",
			font => "Arial, 9",
		},
	
		ylabel => {
			text => "Capacity",
			font => "Arial, 9",
		},
	
		xtics => {
			font => "Arial, 9",
		},
	
		ytics => {
			font => "Arial, 9",
		},
	
		gnuplot => $gnuplotPath,
	);
	
	my $minimumDataSet = Chart::Gnuplot::DataSet->new(
		xdata => \@{$minArray[0]},
		ydata => \@{$minArray[1]},
		fill  => {density => 0.8},
		color => "dark-green",
		style => "histograms",
		font => "Arial, 9",
	);

	$minimumChart->plot2d($minimumDataSet);
}

# create capacityAtEnd statistics chart for all runs and one config
# 1: filename as string
# 2: title as string
# 3: confidence as integer
# 4: results as array
# R: void
sub plotCapacityAtEndStatistics {
	# get parameters
	my $filename = $_[0];
	shift;
	my $title = $_[0];
	shift;
	my $confidence = $_[0];
	shift;
	my @statistics = @_;
	
	# get columcount
	my $maxX = @{$statistics[0]};
	
	my $xlabel = "Configuration";
	my $labelcount = 1;
	foreach (@{$statistics[0]}) {
		$xlabel .= " $labelcount:$_ ";
		$labelcount++;
	}
	
	# plot chart
	my $statisticalChart = Chart::Gnuplot->new(
		output => $filename,
		imagesize => '900.0, 600.0',
		timestamp => {
			fmt => '%Y-%m-%d %H:%I:%S',
			font => "Arial, 9",
		},
		terminal => "png",
		title => {
			text => "$title - CapacityAtEndStatistics",
			font => "Arial, 9",
		},
		
		yrange => [0, max(@{$statistics[3]}) * 1.25 ],
		xrange => [0, $maxX+1],
  
		xlabel => {
			text => "$xlabel",
			font => "Arial, 9",
		},
	
		ylabel => {
			text => "Stddev",
			font => "Arial, 9",
		},
	
		xtics => {
			start => "1",
			end => "$maxX",
			font => "Arial, 9",
		},
	
		ytics => {
			font => "Arial, 9",
		},
	
		gnuplot => $gnuplotPath,
	);
	
	my @xstddev = (1 ... $maxX);
	my @stddev = @{$statistics[1]};
	
	my @xmin = (0, 0.5);
	for ( my $i = 1.5; $i < $maxX+1; $i++ ) {
		push @xmin, $i;
		push @xmin, $i;
		push @xmin, $i;
	}
	
	my @min = (0);
	for ( my $i = 0; $i < $maxX; $i++ ) {
		push @min, $statistics[2][$i];
		push @min, $statistics[2][$i];
		push @min, 0;
	}
	push @min, 0;
	
	my @max = (0);
	for ( my $i = 0; $i < $maxX; $i++ ) {
		push @max, $statistics[3][$i];
		push @max, $statistics[3][$i];
		push @max, 0;
	}
	push @max, 0;
	my @err = @{$statistics[6]};

	
	
	my $statisticalDataSet = Chart::Gnuplot::DataSet->new(
		xdata => [@xstddev],
		ydata => [[@stddev], [@err]],
		title => "mean with confidence $confidence%",
		fill => {
			pattern => 1,
		},
		style => "boxerrorbars",
		font => "Arial, 9",
		color => "dark-green",
	);
	
	my $statisticalDataSetMin = Chart::Gnuplot::DataSet->new(
		xdata => [@xmin],
		ydata => [@min],
		title => "minimum",
		style => "steps",
		font => "Arial, 9",
		color => "dark-red",
	);
	
	my $statisticalDataSetMax = Chart::Gnuplot::DataSet->new(
		xdata => [@xmin],
		ydata => [@max],
		title => "maximum",
		style => "steps",
		font => "Arial, 9",
		color => "dark-blue",
	);
	
	$statisticalChart->plot2d($statisticalDataSet, $statisticalDataSetMin, $statisticalDataSetMax);
}


# create capacityAtEnd statistics chart for all runs and one config
# 1: filename as string
# 2: title as string
# 3: confidence as integer
# 4: results as array
# R: void
sub plotCapacityAtEndStatisticsCompare {
	# get parameters
	my $filename = $_[0];
	shift;
	my $title = $_[0];
	shift;
	my $confidence = $_[0];
	shift;
	my @statistics = @_;
	
	# get columcount
	my $maxX = @{$statistics[0]};
	
	my $xlabel = "Configuration";
	my $labelcount = 1;
	foreach (@{$statistics[0]}) {
		$xlabel .= " $labelcount:$_ ";
		$labelcount++;
	}
	
	# plot chart
	my $statisticalChart = Chart::Gnuplot->new(
		output => $filename,
		imagesize => '1200.0, 600.0',
		timestamp => {
			fmt => '%Y-%m-%d %H:%I:%S',
			font => "Arial, 9",
		},
		terminal => "png",
		title => {
			text => "$title - CapacityAtEndStatistics",
			font => "Arial, 9",
		},
		
		yrange => [0, max(@{$statistics[3]}) * 1.25 ],
		xrange => [0, $maxX+1],
  
		xlabel => {
			text => "$xlabel",
			font => "Arial, 9",
		},
	
		ylabel => {
			text => "Stddev",
			font => "Arial, 9",
		},
	
		xtics => {
			start => "1",
			end => "$maxX",
			font => "Arial, 9",
		},
	
		ytics => {
			font => "Arial, 9",
		},
	
		gnuplot => $gnuplotPath,
	);
	
	my @xstddev = (1 ... $maxX);
	my @stddev = @{$statistics[1]};
	
	my @xmin = (0, 0.5);
	for ( my $i = 1.5; $i < $maxX+1; $i++ ) {
		push @xmin, $i;
		push @xmin, $i;
		push @xmin, $i;
	}
	
	my @min = (0);
	for ( my $i = 0; $i < $maxX; $i++ ) {
		push @min, $statistics[2][$i];
		push @min, $statistics[2][$i];
		push @min, 0;
	}
	push @min, 0;
	
	my @max = (0);
	for ( my $i = 0; $i < $maxX; $i++ ) {
		push @max, $statistics[3][$i];
		push @max, $statistics[3][$i];
		push @max, 0;
	}
	push @max, 0;
	my @err = @{$statistics[6]};

	
	
	my $statisticalDataSet = Chart::Gnuplot::DataSet->new(
		xdata => [@xstddev],
		ydata => [[@stddev], [@err]],
		title => "mean with confidence $confidence%",
		fill => {
			pattern => 1,
		},
		style => "boxerrorbars",
		font => "Arial, 9",
		color => "dark-green",
	);
	
	my $statisticalDataSetMin = Chart::Gnuplot::DataSet->new(
		xdata => [@xmin],
		ydata => [@min],
		title => "minimum",
		style => "steps",
		font => "Arial, 9",
		color => "dark-red",
	);
	
	my $statisticalDataSetMax = Chart::Gnuplot::DataSet->new(
		xdata => [@xmin],
		ydata => [@max],
		title => "maximum",
		style => "steps",
		font => "Arial, 9",
		color => "dark-blue",
	);
	
	$statisticalChart->plot2d($statisticalDataSet, $statisticalDataSetMin, $statisticalDataSetMax);
}

# create capacityAtEnd chart show confidence
# 1: confidence as integer
# 2: long version = 1, short version = 0
# 3: runtime as integer
# 4: configuration as string
# 5: position in array as integer
# 6: results as array
# R: void
sub plotCapacityAtEndConfidenceCompare {
	# get parameters
	my $confidence = $_[0];
	shift;
	my $long = $_[0];
	shift;
	my $time = $_[0];
	shift;
	my $configuration = $_[0];
	shift;
	my $position = $_[0];
	shift;
	my @statsArray = @_;
	
	# collect data
	my $length = @{$statsArray[$position]};
	my $mean = $statsArray[$position][$length-6];
	my $min = $statsArray[$position][$length-3];
	my $max = $statsArray[$position][$length-2];
	my $filename;
	if ( $long == 1 ) {
	    $filename = "export/Compare/CapacityAtEndConfidence/Full/$configuration-CapacityAtEndConfidence.png";
	} else {
		$filename = "export/Compare/CapacityAtEndConfidence/Short/$configuration-CapacityAtEndConfidence-Short.png";
	}
	my $title = $configuration;
	my $offset = 10 / ( ($length - 6) * 1.25 );
	my $maxX = ($length - 6);
	
	# plot chart
	my $stddevChart = Chart::Gnuplot->new(
		output => $filename,
		imagesize => '900.0, 600.0',
		timestamp => {
			fmt => '%Y-%m-%d %H:%I:%S',
			font => "Arial, 9",
		},
		terminal => "png",
		title => {
			text => "$title - CapacityAtEndConfidence (".$time."s)",
			font => "Arial, 9",
		},
		
		yrange => [0, max(@{$statsArray[$position]}) * 1.25 ],
		xrange => [0, $length-4.5],
  
		xlabel => {
			text => "Run",
			font => "Arial, 9",
		},
	
		ylabel => {
			text => "Stddev",
			font => "Arial, 9",
		},
	
		xtics => {
			font => "Arial, 9",
			offset => "$offset",
			start => "1",
			end => "$maxX",
		},
	
		ytics => {
			font => "Arial, 9",
		},
	
		gnuplot => $gnuplotPath,
	);

	my @xData = (0);
	my @yData = (0);
	my @xmin = (0.5, $length-5);
	my @xmax = (0.5, $length-5);
	my @xmean = (0.5, $length-5);
	my @ymin = ($min, $min);
	my @ymax = ($max, $max);
	my @ymean = ($mean, $mean);
	for ( my $run = 1; $run < $length-5; $run++) {
	    push @xData, $run;
		push @yData, $statsArray[$position][$run-1];
	}
	
	my $minDataSet = Chart::Gnuplot::DataSet->new(
		xdata => [@xmin],
		ydata => [@ymin],
		title => "minimum, $confidence%",
		style => "steps",
		font => "Arial, 9",
		color => "dark-red",
	);
	
	my $maxDataSet = Chart::Gnuplot::DataSet->new(
		xdata => [@xmax],
		ydata => [@ymax],
		title => "maximum, $confidence%",
		style => "steps",
		font => "Arial, 9",
		color => "dark-blue",
	);
	
	my $stddevDataSet = Chart::Gnuplot::DataSet->new(
		xdata => \@xData,
		ydata => \@yData,
		fill  => {density => 0.8},
		color => "dark-green",
		style => "histograms",
		font => "Arial, 9",
	);
	
	my $meanDataSet = Chart::Gnuplot::DataSet->new(
		xdata => [@xmean],
		ydata => [@ymean],
		title => "mean",
		style => "steps",
		font => "Arial, 9",
		color => "green",
	);

	$stddevChart->plot2d($stddevDataSet, $minDataSet, $maxDataSet, $meanDataSet);
}

# create capacityAtEnd chart show confidence
# 1: confidence as integer
# 2: long version = 1, short version = 0
# 3: runtime as integer
# 4: configuration as string
# 5: position in array as integer
# 6: results as array
# R: void
sub plotCapacityAtEndConfidence {
	# get parameters
	my $confidence = $_[0];
	shift;
	my $long = $_[0];
	shift;
	my $time = $_[0];
	shift;
	my $configuration = $_[0];
	shift;
	my $position = $_[0];
	shift;
	my @statsArray = @_;
	
	# collect data
	my $length = @{$statsArray[$position]};
	my $mean = $statsArray[$position][$length-6];
	my $min = $statsArray[$position][$length-3];
	my $max = $statsArray[$position][$length-2];
	my $filename;
	if ( $long == 1 ) {
	    $filename = "export/Summary/CapacityAtEndConfidence/Full/$configuration-CapacityAtEndConfidence.png";
	} else {
		$filename = "export/Summary/CapacityAtEndConfidence/Short/$configuration-CapacityAtEndConfidence-Short.png";
	}
	my $title = $configuration;
	my $offset = 10 / ( ($length - 6) * 1.25 );
	my $maxX = ($length - 6);
	
	# plot chart
	my $stddevChart = Chart::Gnuplot->new(
		output => $filename,
		imagesize => '900.0, 600.0',
		timestamp => {
			fmt => '%Y-%m-%d %H:%I:%S',
			font => "Arial, 9",
		},
		terminal => "png",
		title => {
			text => "$title - CapacityAtEndConfidence (".$time."s)",
			font => "Arial, 9",
		},
		
		yrange => [0, max(@{$statsArray[$position]}) * 1.25 ],
		xrange => [0, $length-4.5],
  
		xlabel => {
			text => "Run",
			font => "Arial, 9",
		},
	
		ylabel => {
			text => "Stddev",
			font => "Arial, 9",
		},
	
		xtics => {
			font => "Arial, 9",
			offset => "$offset",
			start => "1",
			end => "$maxX",
		},
	
		ytics => {
			font => "Arial, 9",
		},
	
		gnuplot => $gnuplotPath,
	);

	my @xData = (0);
	my @yData = (0);
	my @xmin = (0.5, $length-5);
	my @xmax = (0.5, $length-5);
	my @xmean = (0.5, $length-5);
	my @ymin = ($min, $min);
	my @ymax = ($max, $max);
	my @ymean = ($mean, $mean);
	for ( my $run = 1; $run < $length-5; $run++) {
	    push @xData, $run;
		push @yData, $statsArray[$position][$run-1];
	}
	
	my $minDataSet = Chart::Gnuplot::DataSet->new(
		xdata => [@xmin],
		ydata => [@ymin],
		title => "minimum, $confidence%",
		style => "steps",
		font => "Arial, 9",
		color => "dark-red",
	);
	
	my $maxDataSet = Chart::Gnuplot::DataSet->new(
		xdata => [@xmax],
		ydata => [@ymax],
		title => "maximum, $confidence%",
		style => "steps",
		font => "Arial, 9",
		color => "dark-blue",
	);
	
	my $stddevDataSet = Chart::Gnuplot::DataSet->new(
		xdata => \@xData,
		ydata => \@yData,
		fill  => {density => 0.8},
		color => "dark-green",
		style => "histograms",
		font => "Arial, 9",
	);
	
	my $meanDataSet = Chart::Gnuplot::DataSet->new(
		xdata => [@xmean],
		ydata => [@ymean],
		title => "mean",
		style => "steps",
		font => "Arial, 9",
		color => "green",
	);

	$stddevChart->plot2d($stddevDataSet, $minDataSet, $maxDataSet, $meanDataSet);
}

# create UdpPacketLoss chart show confidence
# 1: confidence as integer
# 2: long version = 1, short version = 0
# 3: runtime as integer
# 4: configuration as string
# 5: position in array as integer
# 6: results as array
# R: void
sub plotUdpPacketLossConfidence {
	# get parameters
	my $confidence = $_[0];
	shift;
	my $long = $_[0];
	shift;
	my $time = $_[0];
	shift;
	my $configuration = $_[0];
	shift;
	my $position = $_[0];
	shift;
	my @statsArray = @_;
	
	# collect data
	my $length = @{$statsArray[$position]};
	my $mean = $statsArray[$position][$length-6];
	my $min = $statsArray[$position][$length-3];
	my $max = $statsArray[$position][$length-2];
	my $filename;
	if ( $long == 1 ) {
	    $filename = "export/Summary/UdpPacketLossConfidence/Full/$configuration-UdpPacketLossConfidence.png";
	} else {
		$filename = "export/Summary/UdpPacketLossConfidence/Short/$configuration-UdpPacketLossConfidence-Short.png";
	}
	my $title = $configuration;
	my $offset = 10 / ( ($length - 6) * 1.25 );
	my $maxX = ($length - 6);
	
	# plot chart
	my $stddevChart = Chart::Gnuplot->new(
		output => $filename,
		imagesize => '900.0, 600.0',
		timestamp => {
			fmt => '%Y-%m-%d %H:%I:%S',
			font => "Arial, 9",
		},
		terminal => "png",
		title => {
			text => "$title - UdpPacketLossConfidence (".$time."s)",
			font => "Arial, 9",
		},
		
		yrange => [0, max(@{$statsArray[$position]}) * 1.25 ],
		xrange => [0, $length-4.5],
  
		xlabel => {
			text => "Run",
			font => "Arial, 9",
		},
	
		ylabel => {
			text => "Percent",
			font => "Arial, 9",
		},
	
		xtics => {
			font => "Arial, 9",
			offset => "$offset",
			start => "1",
			end => "$maxX",
		},
	
		ytics => {
			font => "Arial, 9",
		},
	
		gnuplot => $gnuplotPath,
	);

	my @xData = (0);
	my @yData = (0);
	my @xmin = (0.5, $length-5);
	my @xmax = (0.5, $length-5);
	my @xmean = (0.5, $length-5);
	my @ymin = ($min, $min);
	my @ymax = ($max, $max);
	my @ymean = ($mean, $mean);
	for ( my $run = 1; $run < $length-5; $run++) {
	    push @xData, $run;
		push @yData, $statsArray[$position][$run-1];
	}
	
	my $minDataSet = Chart::Gnuplot::DataSet->new(
		xdata => [@xmin],
		ydata => [@ymin],
		title => "minimum, $confidence%",
		style => "steps",
		font => "Arial, 9",
		color => "dark-red",
	);
	
	my $maxDataSet = Chart::Gnuplot::DataSet->new(
		xdata => [@xmax],
		ydata => [@ymax],
		title => "maximum, $confidence%",
		style => "steps",
		font => "Arial, 9",
		color => "dark-blue",
	);
	
	my $meanDataSet = Chart::Gnuplot::DataSet->new(
		xdata => [@xmean],
		ydata => [@ymean],
		title => "mean",
		style => "steps",
		font => "Arial, 9",
		color => "green",
	);
	
	my $stddevDataSet = Chart::Gnuplot::DataSet->new(
		xdata => \@xData,
		ydata => \@yData,
		fill  => {density => 0.8},
		color => "dark-green",
		style => "histograms",
		font => "Arial, 9",
	);

	$stddevChart->plot2d($stddevDataSet, $minDataSet, $maxDataSet, $meanDataSet);
}

# create UdpPacketLoss chart show confidence
# 1: confidence as integer
# 2: long version = 1, short version = 0
# 3: runtime as integer
# 4: configuration as string
# 5: position in array as integer
# 6: results as array
# R: void
sub plotUdpPacketLossConfidenceCompare {
	# get parameters
	my $confidence = $_[0];
	shift;
	my $long = $_[0];
	shift;
	my $time = $_[0];
	shift;
	my $configuration = $_[0];
	shift;
	my $position = $_[0];
	shift;
	my @statsArray = @_;
	
	# collect data
	my $length = @{$statsArray[$position]};
	my $mean = $statsArray[$position][$length-6];
	my $min = $statsArray[$position][$length-3];
	my $max = $statsArray[$position][$length-2];
	my $filename;
	if ( $long == 1 ) {
	    $filename = "export/Compare/UdpPacketLossConfidence/Full/$configuration-UdpPacketLossConfidence.png";
	} else {
		$filename = "export/Compare/UdpPacketLossConfidence/Short/$configuration-UdpPacketLossConfidence-Short.png";
	}
	my $title = $configuration;
	my $offset = 10 / ( ($length - 6) * 1.25 );
	my $maxX = ($length - 6);
	
	# plot chart
	my $stddevChart = Chart::Gnuplot->new(
		output => $filename,
		imagesize => '1200.0, 600.0',
		timestamp => {
			fmt => '%Y-%m-%d %H:%I:%S',
			font => "Arial, 9",
		},
		terminal => "png",
		title => {
			text => "$title - UdpPacketLossConfidence (".$time."s)",
			font => "Arial, 9",
		},
		
		yrange => [0, max(@{$statsArray[$position]}) * 1.25 ],
		xrange => [0, $length-4.5],
  
		xlabel => {
			text => "Run",
			font => "Arial, 9",
		},
	
		ylabel => {
			text => "Percent",
			font => "Arial, 9",
		},
	
		xtics => {
			font => "Arial, 9",
			offset => "$offset",
			start => "1",
			end => "$maxX",
		},
	
		ytics => {
			font => "Arial, 9",
		},
	
		gnuplot => $gnuplotPath,
	);

	my @xData = (0);
	my @yData = (0);
	my @xmin = (0.5, $length-5);
	my @xmax = (0.5, $length-5);
	my @xmean = (0.5, $length-5);
	my @ymin = ($min, $min);
	my @ymax = ($max, $max);
	my @ymean = ($mean, $mean);
	for ( my $run = 1; $run < $length-5; $run++) {
	    push @xData, $run;
		push @yData, $statsArray[$position][$run-1];
	}
	
	my $minDataSet = Chart::Gnuplot::DataSet->new(
		xdata => [@xmin],
		ydata => [@ymin],
		title => "minimum, $confidence%",
		style => "steps",
		font => "Arial, 9",
		color => "dark-red",
	);
	
	my $maxDataSet = Chart::Gnuplot::DataSet->new(
		xdata => [@xmax],
		ydata => [@ymax],
		title => "maximum, $confidence%",
		style => "steps",
		font => "Arial, 9",
		color => "dark-blue",
	);
	
	my $meanDataSet = Chart::Gnuplot::DataSet->new(
		xdata => [@xmean],
		ydata => [@ymean],
		title => "mean",
		style => "steps",
		font => "Arial, 9",
		color => "green",
	);
	
	my $stddevDataSet = Chart::Gnuplot::DataSet->new(
		xdata => \@xData,
		ydata => \@yData,
		fill  => {density => 0.8},
		color => "dark-green",
		style => "histograms",
		font => "Arial, 9",
	);

	$stddevChart->plot2d($stddevDataSet, $minDataSet, $maxDataSet, $meanDataSet);
}

# create CapacityAtEndSum chart show confidence
# 1: confidence as integer
# 2: long version = 1, short version = 0
# 3: runtime as integer
# 4: configuration as string
# 5: position in array as integer
# 6: results as array
# R: void
sub plotCapacityAtEndSumConfidenceCompareMultiple {
	# get parameters
	my $confidence = $_[0];
	shift;
	my $long = $_[0];
	shift;
	my $time = $_[0];
	shift;
	my $configuration = $_[0];
	shift;
	my $position = $_[0];
	shift;
	my @statsArray = @_;
	
	# collect data
	my $length = @{$statsArray[$position]};
	my $mean = $statsArray[$position][$length-6];
	my $min = $statsArray[$position][$length-3];
	my $max = $statsArray[$position][$length-2];
	my $filename;
	if ( $long == 1 ) {
	    $filename = "export/CompareSending/CapacityAtEndSumConfidence/Full/$configuration-UdpPacketLossConfidence.png";
	} else {
		$filename = "export/CompareSending/CapacityAtEndSumConfidence/Short/$configuration-UdpPacketLossConfidence-Short.png";
	}
	my $title = $configuration;
	my $offset = 10 / ( ($length - 6) * 1.25 );
	my $maxX = ($length - 6);
	
	# plot chart
	my $stddevChart = Chart::Gnuplot->new(
		output => $filename,
		imagesize => '1200.0, 600.0',
		timestamp => {
			fmt => '%Y-%m-%d %H:%I:%S',
			font => "Arial, 9",
		},
		terminal => "png",
		title => {
			text => "$title - CapacityAtEndSumConfidence (".$time."s)",
			font => "Arial, 9",
		},
		
		yrange => [0, max(@{$statsArray[$position]}) * 1.25 ],
		xrange => [0, $length-4.5],
  
		xlabel => {
			text => "Run",
			font => "Arial, 9",
		},
	
		ylabel => {
			text => "Joule",
			font => "Arial, 9",
		},
	
		xtics => {
			font => "Arial, 9",
			offset => "$offset",
			start => "1",
			end => "$maxX",
		},
	
		ytics => {
			font => "Arial, 9",
		},
	
		gnuplot => $gnuplotPath,
	);

	my @xData = (0);
	my @yData = (0);
	my @xmin = (0.5, $length-5);
	my @xmax = (0.5, $length-5);
	my @xmean = (0.5, $length-5);
	my @ymin = ($min, $min);
	my @ymax = ($max, $max);
	my @ymean = ($mean, $mean);
	for ( my $run = 1; $run < $length-5; $run++) {
	    push @xData, $run;
		push @yData, $statsArray[$position][$run-1];
	}
	
	my $minDataSet = Chart::Gnuplot::DataSet->new(
		xdata => [@xmin],
		ydata => [@ymin],
		title => "minimum, $confidence%",
		style => "steps",
		font => "Arial, 9",
		color => "dark-red",
	);
	
	my $maxDataSet = Chart::Gnuplot::DataSet->new(
		xdata => [@xmax],
		ydata => [@ymax],
		title => "maximum, $confidence%",
		style => "steps",
		font => "Arial, 9",
		color => "dark-blue",
	);
	
	my $meanDataSet = Chart::Gnuplot::DataSet->new(
		xdata => [@xmean],
		ydata => [@ymean],
		title => "mean",
		style => "steps",
		font => "Arial, 9",
		color => "green",
	);
	
	my $stddevDataSet = Chart::Gnuplot::DataSet->new(
		xdata => \@xData,
		ydata => \@yData,
		fill  => {density => 0.8},
		color => "dark-green",
		style => "histograms",
		font => "Arial, 9",
	);

	$stddevChart->plot2d($stddevDataSet, $minDataSet, $maxDataSet, $meanDataSet);
}

# create UdpPacketLoss chart show confidence
# 1: confidence as integer
# 2: long version = 1, short version = 0
# 3: runtime as integer
# 4: configuration as string
# 5: position in array as integer
# 6: results as array
# R: void
sub plotUdpPacketLossConfidenceCompareMultiple {
	# get parameters
	my $confidence = $_[0];
	shift;
	my $long = $_[0];
	shift;
	my $time = $_[0];
	shift;
	my $configuration = $_[0];
	shift;
	my $position = $_[0];
	shift;
	my @statsArray = @_;
	
	# collect data
	my $length = @{$statsArray[$position]};
	my $mean = $statsArray[$position][$length-6];
	my $min = $statsArray[$position][$length-3];
	my $max = $statsArray[$position][$length-2];
	my $filename;
	if ( $long == 1 ) {
	    $filename = "export/CompareSending/UdpPacketLossConfidence/Full/$configuration-UdpPacketLossConfidence.png";
	} else {
		$filename = "export/CompareSending/UdpPacketLossConfidence/Short/$configuration-UdpPacketLossConfidence-Short.png";
	}
	my $title = $configuration;
	my $offset = 10 / ( ($length - 6) * 1.25 );
	my $maxX = ($length - 6);
	
	# plot chart
	my $stddevChart = Chart::Gnuplot->new(
		output => $filename,
		imagesize => '1200.0, 600.0',
		timestamp => {
			fmt => '%Y-%m-%d %H:%I:%S',
			font => "Arial, 9",
		},
		terminal => "png",
		title => {
			text => "$title - UdpPacketLossConfidence (".$time."s)",
			font => "Arial, 9",
		},
		
		yrange => [0, max(@{$statsArray[$position]}) * 1.25 ],
		xrange => [0, $length-4.5],
  
		xlabel => {
			text => "Run",
			font => "Arial, 9",
		},
	
		ylabel => {
			text => "Percent",
			font => "Arial, 9",
		},
	
		xtics => {
			font => "Arial, 9",
			offset => "$offset",
			start => "1",
			end => "$maxX",
		},
	
		ytics => {
			font => "Arial, 9",
		},
	
		gnuplot => $gnuplotPath,
	);

	my @xData = (0);
	my @yData = (0);
	my @xmin = (0.5, $length-5);
	my @xmax = (0.5, $length-5);
	my @xmean = (0.5, $length-5);
	my @ymin = ($min, $min);
	my @ymax = ($max, $max);
	my @ymean = ($mean, $mean);
	for ( my $run = 1; $run < $length-5; $run++) {
	    push @xData, $run;
		push @yData, $statsArray[$position][$run-1];
	}
	
	my $minDataSet = Chart::Gnuplot::DataSet->new(
		xdata => [@xmin],
		ydata => [@ymin],
		title => "minimum, $confidence%",
		style => "steps",
		font => "Arial, 9",
		color => "dark-red",
	);
	
	my $maxDataSet = Chart::Gnuplot::DataSet->new(
		xdata => [@xmax],
		ydata => [@ymax],
		title => "maximum, $confidence%",
		style => "steps",
		font => "Arial, 9",
		color => "dark-blue",
	);
	
	my $meanDataSet = Chart::Gnuplot::DataSet->new(
		xdata => [@xmean],
		ydata => [@ymean],
		title => "mean",
		style => "steps",
		font => "Arial, 9",
		color => "green",
	);
	
	my $stddevDataSet = Chart::Gnuplot::DataSet->new(
		xdata => \@xData,
		ydata => \@yData,
		fill  => {density => 0.8},
		color => "dark-green",
		style => "histograms",
		font => "Arial, 9",
	);

	$stddevChart->plot2d($stddevDataSet, $minDataSet, $maxDataSet, $meanDataSet);
}

# create UdpPacketLoss statistics chart for all runs and one config
# 1: filename as string
# 2: title as string
# 3: confidence as integer
# 4: results as array
# R: void
sub plotUdpPacketLossStatistics {
	# get parameters
	my $filename = $_[0];
	shift;
	my $title = $_[0];
	shift;
	my $confidence = $_[0];
	shift;
	my @statistics = @_;
	
	# get columcount
	my $maxX = @{$statistics[0]};
	
	my $xlabel = "Configuration";
	my $labelcount = 1;
	foreach (@{$statistics[0]}) {
		$xlabel .= " $labelcount:$_ ";
		$labelcount++;
	}
	
	# plot chart
	my $statisticalChart = Chart::Gnuplot->new(
		output => $filename,
		imagesize => '900.0, 600.0',
		timestamp => {
			fmt => '%Y-%m-%d %H:%I:%S',
			font => "Arial, 9",
		},
		terminal => "png",
		title => {
			text => "$title - UdpPacketLossStatistics",
			font => "Arial, 9",
		},
		
		yrange => [0, max(@{$statistics[3]}) * 1.25 ],
		xrange => [0, $maxX+1],
  
		xlabel => {
			text => "$xlabel",
			font => "Arial, 9",
		},
	
		ylabel => {
			text => "Percent",
			font => "Arial, 9",
		},
	
		xtics => {
			start => "1",
			end => "$maxX",
			font => "Arial, 9",
		},
	
		ytics => {
			font => "Arial, 9",
		},
	
		gnuplot => $gnuplotPath,
	);
	
	my @xstddev = (1 ... $maxX);
	my @stddev = @{$statistics[1]};
	
	my @xmin = (0, 0.5);
	for ( my $i = 1.5; $i < $maxX+1; $i++ ) {
		push @xmin, $i;
		push @xmin, $i;
		push @xmin, $i;
	}
	
	my @min = (0);
	for ( my $i = 0; $i < $maxX; $i++ ) {
		push @min, $statistics[2][$i];
		push @min, $statistics[2][$i];
		push @min, 0;
	}
	push @min, 0;
	
	my @max = (0);
	for ( my $i = 0; $i < $maxX; $i++ ) {
		push @max, $statistics[3][$i];
		push @max, $statistics[3][$i];
		push @max, 0;
	}
	push @max, 0;
	my @err = @{$statistics[6]};

	
	
	my $statisticalDataSet = Chart::Gnuplot::DataSet->new(
		xdata => [@xstddev],
		ydata => [[@stddev], [@err]],
		title => "mean with confidence $confidence%",
		fill => {
			pattern => 1,
		},
		style => "boxerrorbars",
		font => "Arial, 9",
		color => "dark-green",
	);
	
	my $statisticalDataSetMin = Chart::Gnuplot::DataSet->new(
		xdata => [@xmin],
		ydata => [@min],
		title => "minimum",
		style => "steps",
		font => "Arial, 9",
		color => "dark-red",
	);
	
	my $statisticalDataSetMax = Chart::Gnuplot::DataSet->new(
		xdata => [@xmin],
		ydata => [@max],
		title => "maximum",
		style => "steps",
		font => "Arial, 9",
		color => "dark-blue",
	);
	
	$statisticalChart->plot2d($statisticalDataSet, $statisticalDataSetMin, $statisticalDataSetMax);
}

# create CapacityAtEndSum statistics chart for all runs and one config
# 1: filename as string
# 2: title as string
# 3: confidence as integer
# 4: results as array
# R: void
sub plotCapacityAtEndSumStatisticsCompare {
	# get parameters
	my $filename = $_[0];
	shift;
	my $title = $_[0];
	shift;
	my $confidence = $_[0];
	shift;
	my @statistics = @_;
	
	# get columcount
	my $maxX = @{$statistics[0]};
	
	my $xlabel = "Configuration";
	my $labelcount = 1;
	foreach (@{$statistics[0]}) {
		$xlabel .= " $labelcount:$_ ";
		$labelcount++;
	}
	
	# plot chart
	my $statisticalChart = Chart::Gnuplot->new(
		output => $filename,
		imagesize => '1200.0, 600.0',
		timestamp => {
			fmt => '%Y-%m-%d %H:%I:%S',
			font => "Arial, 9",
		},
		terminal => "png",
		title => {
			text => "$title - CapacityAtEndSumStatistics",
			font => "Arial, 9",
		},
		
		#yrange => [0, max(@{$statistics[3]}) * 1.25 ],
		xrange => [0, $maxX+1],
  
		xlabel => {
			text => "$xlabel",
			font => "Arial, 9",
		},
	
		ylabel => {
			text => "Percent",
			font => "Arial, 9",
		},
	
		xtics => {
			start => "1",
			end => "$maxX",
			font => "Arial, 9",
		},
	
		ytics => {
			font => "Arial, 9",
		},
	
		gnuplot => $gnuplotPath,
	);
	
	my @xstddev = (1 ... $maxX);
	my @stddev = @{$statistics[1]};
	
	my @xmin = (0, 0.5);
	for ( my $i = 1.5; $i < $maxX+1; $i++ ) {
		push @xmin, $i;
		push @xmin, $i;
		push @xmin, $i;
	}
	
	my @min = (0);
	for ( my $i = 0; $i < $maxX; $i++ ) {
		push @min, $statistics[2][$i];
		push @min, $statistics[2][$i];
		push @min, 0;
	}
	push @min, 0;
	
	my @max = (0);
	for ( my $i = 0; $i < $maxX; $i++ ) {
		push @max, $statistics[3][$i];
		push @max, $statistics[3][$i];
		push @max, 0;
	}
	push @max, 0;
	my @err = @{$statistics[6]};

	
	
	my $statisticalDataSet = Chart::Gnuplot::DataSet->new(
		xdata => [@xstddev],
		ydata => [[@stddev], [@err]],
		title => "mean with confidence $confidence%",
		fill => {
			pattern => 1,
		},
		style => "boxerrorbars",
		font => "Arial, 9",
		color => "dark-green",
	);
	
	my $statisticalDataSetMin = Chart::Gnuplot::DataSet->new(
		xdata => [@xmin],
		ydata => [@min],
		title => "minimum",
		style => "steps",
		font => "Arial, 9",
		color => "dark-red",
	);
	
	my $statisticalDataSetMax = Chart::Gnuplot::DataSet->new(
		xdata => [@xmin],
		ydata => [@max],
		title => "maximum",
		style => "steps",
		font => "Arial, 9",
		color => "dark-blue",
	);
	
	$statisticalChart->plot2d($statisticalDataSet, $statisticalDataSetMin, $statisticalDataSetMax);
}

# create UdpPacketLoss statistics chart for all runs and one config
# 1: filename as string
# 2: title as string
# 3: confidence as integer
# 4: results as array
# R: void
sub plotUdpPacketLossStatisticsCompare {
	# get parameters
	my $filename = $_[0];
	shift;
	my $title = $_[0];
	shift;
	my $confidence = $_[0];
	shift;
	my @statistics = @_;
	
	# get columcount
	my $maxX = @{$statistics[0]};
	
	my $xlabel = "Configuration";
	my $labelcount = 1;
	foreach (@{$statistics[0]}) {
		$xlabel .= " $labelcount:$_ ";
		$labelcount++;
	}
	
	# plot chart
	my $statisticalChart = Chart::Gnuplot->new(
		output => $filename,
		imagesize => '1200.0, 600.0',
		timestamp => {
			fmt => '%Y-%m-%d %H:%I:%S',
			font => "Arial, 9",
		},
		terminal => "png",
		title => {
			text => "$title - UdpPacketLossStatistics",
			font => "Arial, 9",
		},
		
		#yrange => [0, max(@{$statistics[3]}) * 1.25 ],
		xrange => [0, $maxX+1],
  
		xlabel => {
			text => "$xlabel",
			font => "Arial, 9",
		},
	
		ylabel => {
			text => "Joule",
			font => "Arial, 9",
		},
	
		xtics => {
			start => "1",
			end => "$maxX",
			font => "Arial, 9",
		},
	
		ytics => {
			font => "Arial, 9",
		},
	
		gnuplot => $gnuplotPath,
	);
	
	my @xstddev = (1 ... $maxX);
	my @stddev = @{$statistics[1]};
	
	my @xmin = (0, 0.5);
	for ( my $i = 1.5; $i < $maxX+1; $i++ ) {
		push @xmin, $i;
		push @xmin, $i;
		push @xmin, $i;
	}
	
	my @min = (0);
	for ( my $i = 0; $i < $maxX; $i++ ) {
		push @min, $statistics[2][$i];
		push @min, $statistics[2][$i];
		push @min, 0;
	}
	push @min, 0;
	
	my @max = (0);
	for ( my $i = 0; $i < $maxX; $i++ ) {
		push @max, $statistics[3][$i];
		push @max, $statistics[3][$i];
		push @max, 0;
	}
	push @max, 0;
	my @err = @{$statistics[6]};

	
	
	my $statisticalDataSet = Chart::Gnuplot::DataSet->new(
		xdata => [@xstddev],
		ydata => [[@stddev], [@err]],
		title => "mean with confidence $confidence%",
		fill => {
			pattern => 1,
		},
		style => "boxerrorbars",
		font => "Arial, 9",
		color => "dark-green",
	);
	
	my $statisticalDataSetMin = Chart::Gnuplot::DataSet->new(
		xdata => [@xmin],
		ydata => [@min],
		title => "minimum",
		style => "steps",
		font => "Arial, 9",
		color => "dark-red",
	);
	
	my $statisticalDataSetMax = Chart::Gnuplot::DataSet->new(
		xdata => [@xmin],
		ydata => [@max],
		title => "maximum",
		style => "steps",
		font => "Arial, 9",
		color => "dark-blue",
	);
	
	$statisticalChart->plot2d($statisticalDataSet, $statisticalDataSetMin, $statisticalDataSetMax);
}

# create Performance chart show confidence
# 1: confidence as integer
# 2: long version = 1, short version = 0
# 3: runtime as integer
# 4: configuration as string
# 5: position in array as integer
# 6: results as array
# R: void
sub plotPerformanceConfidence {
	# get parameters
	my $confidence = $_[0];
	shift;
	my $long = $_[0];
	shift;
	my $time = $_[0];
	shift;
	my $configuration = $_[0];
	shift;
	my $position = $_[0];
	shift;
	my @statsArray = @_;
	
	# collect data
	my $length = @{$statsArray[$position]};
	my $mean = $statsArray[$position][$length-6];
	my $min = $statsArray[$position][$length-3];
	my $max = $statsArray[$position][$length-2];
	my $filename;
	if ( $long == 1 ) {
	    $filename = "export/Summary/PerformanceConfidence/Full/$configuration-PerformanceConfidence.png";
	} else {
		$filename = "export/Summary/PerformanceConfidence/Short/$configuration-PerformanceConfidence-Short.png";
	}
	my $title = $configuration;
	my $offset = 10 / ( ($length - 6) * 1.25 );
	my $maxX = ($length - 6);
	
	# plot chart
	my $stddevChart = Chart::Gnuplot->new(
		output => $filename,
		imagesize => '900.0, 600.0',
		timestamp => {
			fmt => '%Y-%m-%d %H:%I:%S',
			font => "Arial, 9",
		},
		terminal => "png",
		title => {
			text => "$title - PerformanceConfidence (".$time."s)",
			font => "Arial, 9",
		},
		
		#yrange => [0, max(@{$statsArray[$position]}) * 1.25 ],
		xrange => [0, $length-4.5],
  
		xlabel => {
			text => "Run",
			font => "Arial, 9",
		},
	
		ylabel => {
			text => "Points",
			font => "Arial, 9",
		},
	
		xtics => {
			font => "Arial, 9",
			offset => "$offset",
			start => "1",
			end => "$maxX",
		},
	
		ytics => {
			font => "Arial, 9",
		},
	
		gnuplot => $gnuplotPath,
	);

	my @xData = (0);
	my @yData = (0);
	my @xmin = (0.5, $length-5);
	my @xmax = (0.5, $length-5);
	my @xmean = (0.5, $length-5);
	my @ymin = ($min, $min);
	my @ymax = ($max, $max);
	my @ymean = ($mean, $mean);
	for ( my $run = 1; $run < $length-5; $run++) {
	    push @xData, $run;
		push @yData, $statsArray[$position][$run-1];
	}
	
	my $minDataSet = Chart::Gnuplot::DataSet->new(
		xdata => [@xmin],
		ydata => [@ymin],
		title => "minimum, $confidence%",
		style => "steps",
		font => "Arial, 9",
		color => "dark-red",
	);
	
	my $maxDataSet = Chart::Gnuplot::DataSet->new(
		xdata => [@xmax],
		ydata => [@ymax],
		title => "maximum, $confidence%",
		style => "steps",
		font => "Arial, 9",
		color => "dark-blue",
	);
	
	my $meanDataSet = Chart::Gnuplot::DataSet->new(
		xdata => [@xmean],
		ydata => [@ymean],
		title => "mean",
		style => "steps",
		font => "Arial, 9",
		color => "green",
	);
	
	my $stddevDataSet = Chart::Gnuplot::DataSet->new(
		xdata => \@xData,
		ydata => \@yData,
		fill  => {density => 0.8},
		color => "dark-green",
		style => "histograms",
		font => "Arial, 9",
	);

	$stddevChart->plot2d($stddevDataSet, $minDataSet, $maxDataSet, $meanDataSet);
}

# create Performance chart show confidence
# 1: confidence as integer
# 2: long version = 1, short version = 0
# 3: runtime as integer
# 4: configuration as string
# 5: position in array as integer
# 6: results as array
# R: void
sub plotPerformanceConfidenceCompare {
	# get parameters
	my $confidence = $_[0];
	shift;
	my $long = $_[0];
	shift;
	my $time = $_[0];
	shift;
	my $configuration = $_[0];
	shift;
	my $position = $_[0];
	shift;
	my @statsArray = @_;
	
	# collect data
	my $length = @{$statsArray[$position]};
	my $mean = $statsArray[$position][$length-6];
	my $min = $statsArray[$position][$length-3];
	my $max = $statsArray[$position][$length-2];
	my $filename;
	if ( $long == 1 ) {
	    $filename = "export/Compare/PerformanceConfidence/Full/$configuration-PerformanceConfidence.png";
	} else {
		$filename = "export/Compare/PerformanceConfidence/Short/$configuration-PerformanceConfidence-Short.png";
	}
	my $title = $configuration;
	my $offset = 10 / ( ($length - 6) * 1.25 );
	my $maxX = ($length - 6);
	
	# plot chart
	my $stddevChart = Chart::Gnuplot->new(
		output => $filename,
		imagesize => '1200.0, 600.0',
		timestamp => {
			fmt => '%Y-%m-%d %H:%I:%S',
			font => "Arial, 9",
		},
		terminal => "png",
		title => {
			text => "$title - PerformanceConfidence (".$time."s)",
			font => "Arial, 9",
		},
		
		#yrange => [0, max(@{$statsArray[$position]}) * 1.25 ],
		xrange => [0, $length-4.5],
  
		xlabel => {
			text => "Run",
			font => "Arial, 9",
		},
	
		ylabel => {
			text => "Points",
			font => "Arial, 9",
		},
	
		xtics => {
			font => "Arial, 9",
			offset => "$offset",
			start => "1",
			end => "$maxX",
		},
	
		ytics => {
			font => "Arial, 9",
		},
	
		gnuplot => $gnuplotPath,
	);

	my @xData = (0);
	my @yData = (0);
	my @xmin = (0.5, $length-5);
	my @xmax = (0.5, $length-5);
	my @xmean = (0.5, $length-5);
	my @ymin = ($min, $min);
	my @ymax = ($max, $max);
	my @ymean = ($mean, $mean);
	for ( my $run = 1; $run < $length-5; $run++) {
	    push @xData, $run;
		push @yData, $statsArray[$position][$run-1];
	}
	
	my $minDataSet = Chart::Gnuplot::DataSet->new(
		xdata => [@xmin],
		ydata => [@ymin],
		title => "minimum, $confidence%",
		style => "steps",
		font => "Arial, 9",
		color => "dark-red",
	);
	
	my $maxDataSet = Chart::Gnuplot::DataSet->new(
		xdata => [@xmax],
		ydata => [@ymax],
		title => "maximum, $confidence%",
		style => "steps",
		font => "Arial, 9",
		color => "dark-blue",
	);
	
	my $meanDataSet = Chart::Gnuplot::DataSet->new(
		xdata => [@xmean],
		ydata => [@ymean],
		title => "mean",
		style => "steps",
		font => "Arial, 9",
		color => "green",
	);
	
	my $stddevDataSet = Chart::Gnuplot::DataSet->new(
		xdata => \@xData,
		ydata => \@yData,
		fill  => {density => 0.8},
		color => "dark-green",
		style => "histograms",
		font => "Arial, 9",
	);

	$stddevChart->plot2d($stddevDataSet, $minDataSet, $maxDataSet, $meanDataSet);
}

# create Performance statistics chart for all runs and one config
# 1: filename as string
# 2: title as string
# 3: confidence as integer
# 4: xlabel as string
# 5: results as array
# R: void
sub plotPerformanceStatistics {
	# get parameters
	my $filename = $_[0];
	shift;
	my $title = $_[0];
	shift;
	my $confidence = $_[0];
	shift;
	my $xlabelAdd = $_[0];
	shift;
	my @statistics = @_;
	
	# get columcount
	my $maxX = @{$statistics[0]};
	
	my $xlabel = "Configuration $xlabelAdd";
	
	# plot chart
	my $statisticalChart = Chart::Gnuplot->new(
		output => $filename,
		imagesize => '900.0, 600.0',
		timestamp => {
			fmt => '%Y-%m-%d %H:%I:%S',
			font => "Arial, 9",
		},
		terminal => "png",
		title => {
			text => "$title - PerformanceStatistics",
			font => "Arial, 9",
		},
		
		#yrange => [0, max(@{$statistics[3]}) * 1.25 ],
		xrange => [0, $maxX+1],
  
		xlabel => {
			text => "$xlabel",
			font => "Arial, 9",
		},
	
		ylabel => {
			text => "Points",
			font => "Arial, 9",
		},
	
		xtics => {
			start => "1",
			end => "$maxX",
			font => "Arial, 9",
		},
	
		ytics => {
			font => "Arial, 9",
		},
	
		gnuplot => $gnuplotPath,
	);
	
	my @xstddev = (1 ... $maxX);
	my @stddev = @{$statistics[1]};
	
	my @xmin = (0, 0.5);
	for ( my $i = 1.5; $i < $maxX+1; $i++ ) {
		push @xmin, $i;
		push @xmin, $i;
		push @xmin, $i;
	}
	
	my @min = (0);
	for ( my $i = 0; $i < $maxX; $i++ ) {
		push @min, $statistics[2][$i];
		push @min, $statistics[2][$i];
		push @min, 0;
	}
	push @min, 0;
	
	my @max = (0);
	for ( my $i = 0; $i < $maxX; $i++ ) {
		push @max, $statistics[3][$i];
		push @max, $statistics[3][$i];
		push @max, 0;
	}
	push @max, 0;
	my @err = @{$statistics[6]};

	my $statisticalDataSet = Chart::Gnuplot::DataSet->new(
		xdata => [@xstddev],
		ydata => [[@stddev], [@err]],
		title => "mean with confidence $confidence%",
		fill => {
			pattern => 1,
		},
		style => "boxerrorbars",
		font => "Arial, 9",
		color => "dark-green",
	);
	
	my $statisticalDataSetMin = Chart::Gnuplot::DataSet->new(
		xdata => [@xmin],
		ydata => [@min],
		title => "minimum",
		style => "steps",
		font => "Arial, 9",
		color => "dark-red",
	);
	
	my $statisticalDataSetMax = Chart::Gnuplot::DataSet->new(
		xdata => [@xmin],
		ydata => [@max],
		title => "maximum",
		style => "steps",
		font => "Arial, 9",
		color => "dark-blue",
	);
	
	$statisticalChart->plot2d($statisticalDataSet, $statisticalDataSetMin, $statisticalDataSetMax);
}

# create html index file
# R: void
sub htmlIndex {
	# create variables
	system("cp ./style.css export/");
	my $filename = "export/index.html";
	
	# create capacity file
	open(FILE, ">", $filename);
	print FILE "<html>\n";
	print FILE "	<head>\n";
	print FILE "		<title>Powerrouting reports</title>\n";
	print FILE "		<link rel=\"stylesheet\" href=\"./style.css\" type=\"text/css\">\n";
	print FILE "	</head>\n";
	print FILE "	<body>\n";
	print FILE "		<h2>Powerrouting reports</h2>\n";
	print FILE "		<a href=\"aodv.html\">Simulation: AODV</a><br>\n";
	print FILE "		<a href=\"aodvpo.html\">Simulation: AODVPO</a><br>\n";
	print FILE "		<a href=\"aodvpotriggerhappy.html\">Simulation: AODVPO Trigger Happy</a><br>\n";
	print FILE "		<a href=\"aodvpotriggersloppy.html\">Simulation: AODVPO Trigger Sloppy</a><br>\n";
	print FILE "		<a href=\"aodvpomixed.html\">Simulation: AODV/AODVPO Mixed</a><br>\n";
	print FILE "		<a href=\"aodvmultiple.html\">Simulation: AODV Multiple</a><br>\n";
	print FILE "		<a href=\"aodvpomultiple.html\">Simulation: AODVPO Multiple</a><br><br>\n";
	print FILE "		<a href=\"olsr.html\">Simulation: OLSR</a><br>\n";
	print FILE "		<a href=\"olsrpo.html\">Simulation: OLSRPO</a><br>\n";
	print FILE "		<a href=\"olsrpotriggerhappy.html\">Simulation: OLSRPO Trigger Happy</a><br>\n";
	print FILE "		<a href=\"olsrpotriggersloppy.html\">Simulation: OLSRPO Trigger Sloppy</a><br>\n";
	print FILE "		<a href=\"olsrpomixed.html\">Simulation: OLSR/OLSRPO Mixed</a><br>\n";
	print FILE "		<a href=\"olsrmultiple.html\">Simulation: OLSR Multiple</a><br>\n";
	print FILE "		<a href=\"olsrpomultiple.html\">Simulation: OLSRPO Multiple</a><br><br>\n";
	print FILE "		<a href=\"aodvstudy.html\">Parameter Study: AODVPO</a><br>\n";
	print FILE "		<a href=\"olsrstudy.html\">Parameter Study: OLSRPO</a><br><br>\n";
	print FILE "		<a href=\"compare.html\">Comparision: AODV/OLSR</a><br>\n";
	print FILE "		<a href=\"summary.html\">Summary: AODV/OLSR</a><br><br>\n";
	print FILE "	</body>\n";
	print FILE "</html>\n";
	close FILE;
}

# create html simulation file
# 1: simulation name as string
# 2: filenamepart name as string
# 3: imagepath as string
# R: void
sub htmlSimulation {
	# get parameters
	my $simulation = $_[0];
	shift;
	my $filenamepart = $_[0];
	shift;
	my $imagepath = $_[0];
	shift;
	
	# create variables
	system("cp ./style.css export/");
	my $filename = "export/$filenamepart.html";
	
	# create capacity file
	open(FILE, ">", $filename);
	print FILE "<html>\n";
	print FILE "	<head>\n";
	print FILE "		<title>Powerrouting reports: Simulation $simulation</title>\n";
	print FILE "		<link rel=\"stylesheet\" href=\"./style.css\" type=\"text/css\">\n";
	print FILE "	</head>\n";
	print FILE "	<body>\n";
	print FILE "		<h2>Powerrouting reports: Simulation $simulation</h2>\n";
	print FILE "		<h3>Capacity over time (left full, right short time)</h3>\n";
	
	foreach my $image (glob("./export/$imagepath/CapacityOverTime/Full/*.png")) {
		$image =~ s/#/%23/g;
		$image =~ s/\/export//g;
		print FILE "		<img src=\"$image\" width=\"900\">";
		$image =~ s/Full/Short/g;
		$image =~ s/.png/-Short.png/g;
		print FILE "		<img src=\"$image\" width=\"900\"><br>\n";
	}
	
	print FILE "		<h3>Capacity at end of run (left full, right short time)</h3>\n";
	
	foreach my $image (glob("./export/$imagepath/CapacityAtEnd/Full/*.png")) {
		$image =~ s/#/%23/g;
		$image =~ s/\/export//g;
		print FILE "		<img src=\"$image\" width=\"900\">";
		$image =~ s/Full/Short/g;
		$image =~ s/.png/-Short.png/g;
		print FILE "		<img src=\"$image\" width=\"900\"><br>\n";
	}
		
	print FILE "	</body>\n";
	print FILE "</html>\n";
	close FILE;
}

# create html study file
# 1: simulation name as string
# 2: filenamepart name as string
# 3: imagepath as string
# R: void
sub htmlStudy {
	# get parameters
	my $simulation = $_[0];
	shift;
	my $filenamepart = $_[0];
	shift;
	my $imagepath = $_[0];
	shift;
	
	# create variables
	system("cp ./style.css export/");
	my $filename = "export/$filenamepart.html";
	
	# create capacity file
	open(FILE, ">", $filename);
	print FILE "<html>\n";
	print FILE "	<head>\n";
	print FILE "		<title>Powerrouting reports: Study $simulation</title>\n";
	print FILE "		<link rel=\"stylesheet\" href=\"./style.css\" type=\"text/css\">\n";
	print FILE "	</head>\n";
	print FILE "	<body>\n";
	print FILE "		<h2>Powerrouting reports: Study $simulation</h2>\n";
	print FILE "		<h3>Capacity at End (left full, right short time)</h3>\n";
	
	my $image = "./export/$imagepath/Full/".$simulation."ParameterStudy-CapacityAtEnd-3D.png";
	$image =~ s/#/%23/g;
	$image =~ s/\/export//g;
	print FILE "		<img src=\"$image\" width=\"900\">";
	$image =~ s/Full/Short/g;
	print FILE "		<img src=\"$image\" width=\"900\"><br>\n";
	
	print FILE "		<h3>Capacity at End (left full, right short time)</h3>\n";
	
	my $image = "./export/$imagepath/Full/".$simulation."ParameterStudy-CapacityAtEnd-Map.png";
	$image =~ s/#/%23/g;
	$image =~ s/\/export//g;
	print FILE "		<img src=\"$image\" width=\"900\">";
	$image =~ s/Full/Short/g;
	print FILE "		<img src=\"$image\" width=\"900\"><br>\n";
	
	print FILE "		<h3>UDP packets transmitted (full time)</h3>\n";		
	my $image = "./export/$imagepath/Full/".$simulation."ParameterStudy-UDPStats-3D.png";
	$image =~ s/#/%23/g;
	$image =~ s/\/export//g;
	print FILE "		<img src=\"$image\" width=\"900\">";
	my $image = "./export/$imagepath/Full/".$simulation."ParameterStudy-UDPStats-Map.png";
	$image =~ s/#/%23/g;
	$image =~ s/\/export//g;
	print FILE "		<img src=\"$image\" width=\"900\"><br>\n";
	
	print FILE "		<h3>Performance (full time)</h3>\n";		
	my $image = "./export/$imagepath/Full/".$simulation."ParameterStudy-Performance-3D.png";
	$image =~ s/#/%23/g;
	$image =~ s/\/export//g;
	print FILE "		<img src=\"$image\" width=\"900\">";
	my $image = "./export/$imagepath/Full/".$simulation."ParameterStudy-Performance-Map.png";
	$image =~ s/#/%23/g;
	$image =~ s/\/export//g;
	print FILE "		<img src=\"$image\" width=\"900\"><br>\n";
	
	my $image = "./$imagepath/UdpPacketLoss/Full/AODV-OLSR-UdpPacketLossStatistics.png";
	print FILE "		<img src=\"$image\"><br>\n";

	
	print FILE "		<h3>Capacity over time (left full, right short time)</h3>\n";
	
	foreach my $image (glob("./export/$imagepath/CapacityOverTime/Full/*.png")) {
		$image =~ s/#/%23/g;
		$image =~ s/\/export//g;
		print FILE "		<img src=\"$image\" width=\"900\">";
		$image =~ s/Full/Short/g;
		$image =~ s/.png/-Short.png/g;
		print FILE "		<img src=\"$image\" width=\"900\"><br>\n";
	}
	
	print FILE "		<h3>Capacity at end of run (left full, right short time)</h3>\n";
	
	foreach my $image (glob("./export/$imagepath/CapacityAtEnd/Full/*.png")) {
		$image =~ s/#/%23/g;
		$image =~ s/\/export//g;
		print FILE "		<img src=\"$image\" width=\"900\">";
		$image =~ s/Full/Short/g;
		$image =~ s/.png/-Short.png/g;
		print FILE "		<img src=\"$image\" width=\"900\"><br>\n";
	}
		
	print FILE "	</body>\n";
	print FILE "</html>\n";
	close FILE;
}

# create html study file
# 1: filenamepart name as string
# 2: imagepath as string
# R: void
sub htmlCompare {
	# get parameters
	my $filenamepart = $_[0];
	shift;
	my $imagepath = $_[0];
	shift;
	
	# create variables
	system("cp ./style.css export/");	
	my $filename = "export/$filenamepart.html";
	
	# create capacity file
	open(FILE, ">", $filename);
		print FILE "<html>\n";
	print FILE "	<head>\n";
	print FILE "		<title>Powerrouting reports: Comparision</title>\n";
	print FILE "		<link rel=\"stylesheet\" href=\"./style.css\" type=\"text/css\">\n";
	print FILE "	</head>\n";
	print FILE "	<body>\n";
	print FILE "		<h2>Powerrouting reports: Comparision</h2>\n";

	print FILE "		<h3>Capacity at end (full time)</h3>\n";	
	my $image = "./$imagepath/CapacityAtEnd/Full/AODV-OLSR-CapacityAtEndStatistics.png";
	print FILE "		<img src=\"$image\"><br>\n";
	
	print FILE "		<h3>Capacity at End (short time)</h3>\n";	
	my $image = "./$imagepath/CapacityAtEnd/Short/AODV-OLSR-CapacityAtEndStatistics-Short.png";
	print FILE "		<img src=\"$image\"><br>\n";

	print FILE "		<h3>UDP packet loss (full time)</h3>\n";	
	my $image = "./$imagepath/UdpPacketLoss/Full/AODV-OLSR-UdpPacketLossStatistics.png";
	print FILE "		<img src=\"$image\"><br>\n";
	
	print FILE "		<h3>Capacity at end sum (full time)</h3>\n";	
	my $image = "./".$imagepath."Sending/CapacityAtEndSum/Full/AODV-OLSR-Sending-CapacityAtEndSum.png";
	print FILE "		<img src=\"$image\"><br>\n";
	
	print FILE "		<h3>Capacity at end sum (short time)</h3>\n";	
	my $image = "./".$imagepath."Sending/CapacityAtEndSum/Short/AODV-OLSR-Sending-CapacityAtEndSum.png";
	print FILE "		<img src=\"$image\"><br>\n";

	print FILE "		<h3>UDP packet loss (full time)</h3>\n";	
	my $image = "./".$imagepath."Sending/UdpPacketLoss/Full/AODV-OLSR-Sending-UdpPacketLossStatistics.png";
	print FILE "		<img src=\"$image\"><br>\n";
	
	print FILE "		<h3>Capacity at end confidence (left full, right short time)</h3>\n";	
	foreach my $image (glob("./export/$imagepath/CapacityAtEndConfidence/Full/*.png")) {
		$image =~ s/#/%23/g;
		$image =~ s/\/export//g;
		print FILE "		<img src=\"$image\" width=\"900\">";
		$image =~ s/Full/Short/g;
		$image =~ s/.png/-Short.png/g;
		print FILE "		<img src=\"$image\" width=\"900\"><br>\n";
	}
	
	my $line = 0;
	print FILE "		<h3>UDP packet loss confidence (full time)</h3>\n";	
	foreach my $image (glob("./export/$imagepath/UdpPacketLossConfidence/Full/*.png")) {
		$image =~ s/#/%23/g;
		$image =~ s/\/export//g;
		print FILE "		<img src=\"$image\" width=\"900\">";
		if ( $line == 1) {
			print FILE "<br>\n";
			$line = 0;
		} else {
			$line = 1;
		}		
	}
			
	print FILE "		<h3>Capacity at end sum confidence (left full, right short time)</h3>\n";	
	foreach my $image (glob("./export/".$imagepath."Sending/CapacityAtEndSumConfidence/Full/*.png")) {
		$image =~ s/#/%23/g;
		$image =~ s/\/export//g;
		print FILE "		<img src=\"$image\" width=\"900\">";
		$image =~ s/Full/Short/g;
		$image =~ s/.png/-Short.png/g;
		print FILE "		<img src=\"$image\" width=\"900\"><br>\n";
	}
	
	my $line = 0;
	print FILE "		<h3>UDP packet loss confidence (full time)</h3>\n";	
	foreach my $image (glob("./export/".$imagepath."Sending/UdpPacketLossConfidence/Full/*.png")) {
		$image =~ s/#/%23/g;
		$image =~ s/\/export//g;
		print FILE "		<img src=\"$image\" width=\"900\">";
		if ( $line == 1) {
			print FILE "<br>\n";
			$line = 0;
		} else {
			$line = 1;
		}		
	}
			
	print FILE "	</body>\n";
	print FILE "</html>\n";
	close FILE;
}

# create html study file
# 1: filenamepart name as string
# 2: imagepath as string
# R: void
sub htmlSummary {
	# get parameters
	my $filenamepart = $_[0];
	shift;
	my $imagepath = $_[0];
	shift;
	
	# create variables
	system("cp ./style.css export/");	
	my $filename = "export/$filenamepart.html";
	
	# create capacity file
	open(FILE, ">", $filename);
		print FILE "<html>\n";
	print FILE "	<head>\n";
	print FILE "		<title>Powerrouting reports: Summary</title>\n";
	print FILE "		<link rel=\"stylesheet\" href=\"./style.css\" type=\"text/css\">\n";
	print FILE "	</head>\n";
	print FILE "	<body>\n";
	print FILE "		<h2>Powerrouting reports: Summary</h2>\n";

	print FILE "		<h3>Capacity at end (full time)</h3>\n";	
	my $image = "./$imagepath/CapacityAtEnd/Full/AODV-CapacityAtEndStatistics.png";
	print FILE "		<img src=\"$image\" width=\"900\">\n";
	my $image = "./$imagepath/CapacityAtEnd/Full/OLSR-CapacityAtEndStatistics.png";
	print FILE "		<img src=\"$image\" width=\"900\"><br>\n";

	print FILE "		<h3>Capacity at end (short time)</h3>\n";	
	my $image = "./$imagepath/CapacityAtEnd/Short/AODV-CapacityAtEndStatistics-Short.png";
	print FILE "		<img src=\"$image\" width=\"900\">\n";
	my $image = "./$imagepath/CapacityAtEnd/Short/OLSR-CapacityAtEndStatistics-Short.png";
	print FILE "		<img src=\"$image\" width=\"900\"><br>\n";

	print FILE "		<h3>UDP packet loss (full time)</h3>\n";	
	my $image = "./$imagepath/UdpPacketLoss/Full/AODV-UdpPacketLossStatistics.png";
	print FILE "		<img src=\"$image\">\n";
	my $image = "./$imagepath/UdpPacketLoss/Full/OLSR-UdpPacketLossStatistics.png";
	print FILE "		<img src=\"$image\"><br>\n";
	
	print FILE "		<h3>Capacity at end confidence (left full, right short time)</h3>\n";	
	foreach my $image (glob("./export/$imagepath/CapacityAtEndConfidence/Full/*.png")) {
		$image =~ s/#/%23/g;
		$image =~ s/\/export//g;
		print FILE "		<img src=\"$image\" width=\"900\">";
		$image =~ s/Full/Short/g;
		$image =~ s/.png/-Short.png/g;
		print FILE "		<img src=\"$image\" width=\"900\"><br>\n";
	}
	
	my $line = 0;
	print FILE "		<h3>UDP packet loss confidence (full time)</h3>\n";	
	foreach my $image (glob("./export/$imagepath/UdpPacketLossConfidence/Full/*.png")) {
		$image =~ s/#/%23/g;
		$image =~ s/\/export//g;
		print FILE "		<img src=\"$image\" width=\"900\">";
		if ( $line == 1) {
			print FILE "<br>\n";
			$line = 0;
		} else {
			$line = 1;
		}		
	}
			
	print FILE "	</body>\n";
	print FILE "</html>\n";
	close FILE;
}
1;
