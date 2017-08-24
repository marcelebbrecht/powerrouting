# PowerRouting for OMNeT++ - perl subs for plot.pl
# Marcel Ebbrecht, marcel.ebbrecht@googlemail.com
# free software, see LICENSE.md for details

### settings
my $gnuplotPath = "C:\\omnetpp\\gnuplot\\bin\\gnuplot.exe";

### includes
use Statistics::Lite qw(:all);
use Chart::Gnuplot;
use DateTime qw();
use Switch;

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
	my @minArray = @_;
	
	# plot chart
	my $minimumChart = Chart::Gnuplot->new(
		output => $filename,
		terminal => "png",
		title => {
			text => "$title - CapacityAtEnd (".DateTime->now->strftime('%Y-%m-%d %H:%I:%S').")",
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

1;