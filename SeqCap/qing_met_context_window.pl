#!/bin/perl

my $INFILE = $ARGV[0];
my $WINDOW = $ARGV[1] || 100;

# perl ./met_context_window_lin.pl example_input.txt 100  

# HWI-ST261:400:B0A1EABXX:8:2208:11321:57205 1:N:0:ATCACG	-	7	16761635	1	x
# HWI-ST261:400:B0A1EABXX:8:2103:16659:181377 1:N:0:ATCACG	+	1	248757208	X

my %dat;
my $CGOUTFILE = "$INFILE.$WINDOW.CG.bed";
my $CHGOUTFILE = "$INFILE.$WINDOW.CHG.bed";
my $CHHOUTFILE = "$INFILE.$WINDOW.CHH.bed";

# Read in data
open (IN, $INFILE) or die;
open (CGOUT, ">$CGOUTFILE") or die;
open (CHGOUT, ">$CHGOUTFILE") or die;
open (CHHOUT, ">$CHHOUTFILE") or die;

print STDERR "Reading in report file...\n";
my $ts = localtime();
print STDERR $ts, "\n";

while (my $l = <IN>) {

	chomp($l);
	my @f = split(/\t/, $l);
	
	my $chr = $f[0];
	my $pos = $f[1];
	my $ccnt = $f[6];
	my $ctcnt = $f[7];
	my $context = $f[3];
	
	my $bin = int(($pos-1 )/ $WINDOW);
	
	#$dat{$chr}->{$bin}->{'total'}++;
	$dat{$chr}->{$bin}->{$context}->{'C'}+=$ccnt;
	$dat{$chr}->{$bin}->{$context}->{'CT'}+=$ctcnt;
	#print STDERR "$chr\t$bin\t$met\n";
	
}

print STDERR "Printing out window file...\n";
$ts = localtime();
print STDERR $ts, "\n";

# Emit window bigBed
print STDERR "Printout time\n";
for my $C (sort {$a <=> $b} keys %dat) {
	
	for my $W (sort {$a <=> $b} keys %{ $dat{$C} }) {
		# CG output
		if($dat{$C}->{$W}->{'CG'}->{'CT'}!=0){
			my $cgfrac = ($dat{$C}->{$W}->{'CG'}->{'C'} / $dat{$C}->{$W}->{'CG'}->{'CT'});
			print CGOUT $C, "\t", ($W * $WINDOW), "\t", (($W + 1) * $WINDOW) , "\t", $dat{$C}->{$W}->{'CG'}->{'C'}, "\t", $dat{$C}->{$W}->{'CG'}->{'CT'}, "\t", $cgfrac, "\n";
		}else{
			print CGOUT $C, "\t", ($W * $WINDOW), "\t", (($W + 1) * $WINDOW) , "\t", $dat{$C}->{$W}->{'CG'}->{'C'}, "\t", $dat{$C}->{$W}->{'CG'}->{'CT'}, "\tNA\n";
		}		
		# CHG output
		if($dat{$C}->{$W}->{'CHG'}->{'CT'}!=0){
			my $chgfrac = ($dat{$C}->{$W}->{'CHG'}->{'C'} / $dat{$C}->{$W}->{'CHG'}->{'CT'});
			print CHGOUT $C, "\t", ($W * $WINDOW), "\t", (($W + 1) * $WINDOW) , "\t", $dat{$C}->{$W}->{'CHG'}->{'C'}, "\t", $dat{$C}->{$W}->{'CHG'}->{'CT'}, "\t", $chgfrac, "\n";
		}else{
			print CHGOUT $C, "\t", ($W * $WINDOW), "\t", (($W + 1) * $WINDOW) , "\t", $dat{$C}->{$W}->{'CHG'}->{'C'}, "\t", $dat{$C}->{$W}->{'CHG'}->{'CT'}, "\tNA\n";
		}		

		# CHH output
		if($dat{$C}->{$W}->{'CHH'}->{'CT'}!=0){
			my $chhfrac = ($dat{$C}->{$W}->{'CHH'}->{'C'} / $dat{$C}->{$W}->{'CHH'}->{'CT'});
			print CHHOUT $C, "\t", ($W * $WINDOW), "\t", (($W + 1) * $WINDOW) , "\t", $dat{$C}->{$W}->{'CHH'}->{'C'}, "\t", $dat{$C}->{$W}->{'CHH'}->{'CT'}, "\t", $chhfrac, "\n";
		}else{
			print CHHOUT $C, "\t", ($W * $WINDOW), "\t", (($W + 1) * $WINDOW) , "\t", $dat{$C}->{$W}->{'CHH'}->{'C'}, "\t", $dat{$C}->{$W}->{'CHH'}->{'CT'}, "\tNA\n";
		}		

	}

}

close CGOUT;
close CHGOUT;
close CHHOUT;
close IN;


