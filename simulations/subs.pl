# PowerRouting for OMNeT++ - perl subs for plot.pl
# Marcel Ebbrecht, marcel.ebbrecht@googlemail.com
# free software, see LICENSE.md for details

### settings
my $gnuplotPath = "C:\\omnetpp\\gnuplot\\bin\\gnuplot.exe";

### includes
use Statistics::Lite qw(:all);
use Chart::Gnuplot;
use DateTime qw();
use Statistics::PointEstimation;

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
	my $interval = $_[1];
	
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
					$lastValues[$actualColumn] = $_;
					$results[$actualLine][$actualColumn] = $_;
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

# create capacity adt end statistic
# 1: number of runs as integer
# 2: long version = 1, short version = 0
# 3: configurations as array
# R: array with statistical data
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
# 3: configurations as array
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

# create capacityAtEnd chart
# 1: filename as string
# 2: title as string
# 3: minimum results as array
# R: void
sub plotCapacityAtEnd {
	# get parameters
	my $filename = $_[0];
	my $title = $_[1];
	shift;
	shift;
	my @statsArray = @_;
	
	# plot chart
	my $minimumChart = Chart::Gnuplot->new(
		output => $filename,
		timestamp => {
			fmt => '%Y-%m-%d %H:%I:%S',
			font => "Arial, 9",
		},
		terminal => "png",
		title => {
			text => "$title - CapacityAtEnd",
			font => "Arial, 9",
		},
		
		yrange => [0, max(@{$minArray[1]}) * 1.05 ],
  
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
			offset => "1",
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

# create capacityAtEnd chart show confidence
# 1: confidence as integer
# 2: configuration as string
# 3: position in array as integer
# 4: minimum results as array
# R: void
sub plotCapacityAtEndConfidence {
	# get parameters
	my $confidence = $_[0];
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
	my $filename = "export/$configuration-CapacityAtEndConfidence.png";
	my $title = $configuration;
	
	# plot chart
	my $stddevChart = Chart::Gnuplot->new(
		output => $filename,
		timestamp => {
			fmt => '%Y-%m-%d %H:%I:%S',
			font => "Arial, 9",
		},
		terminal => "png",
		title => {
			text => "$title - CapacityAtEndConfidence",
			font => "Arial, 9",
		},
		
		yrange => [0, max(@{$statsArray[$position]}) * 1.15 ],
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
			offset => "1",
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
	my @ymin = ($min, $min);
	my @ymax = ($max, $max);
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

	$stddevChart->plot2d($stddevDataSet, $minDataSet, $maxDataSet);
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
		timestamp => {
			fmt => '%Y-%m-%d %H:%I:%S',
			font => "Arial, 9",
		},
		terminal => "png",
		title => {
			text => "$title - CapacityAtEndStatistics",
			font => "Arial, 9",
		},
		
		yrange => [0, max(@{$statistics[3]}) * 1.15 ],
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

1;