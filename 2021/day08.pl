use strict; use warnings;

use List::Util qw(first sum);

sub part_1 {
  my @input = @_;
  my @options = map { /\|(.*)/ } @input;
  my $matches = map { /\b(\w{2,4}|\w{7})\b/g } @options;
  return $matches;
}

sub part_2 {
  my @input = @_;
  return sum(map { solve($_) } @input);
}

sub solve {
  my ($line) = @_;
  my @samples = $line =~ /\b(\w+)\b(?=.*\|)/g;
  my @digits = $line =~ /\b(\w+)\b(?!.*\|)/g;

  my $one = first { length($_) == 2 } @samples;
  my $four = first { length($_) == 4 } @samples;

  my @out = map {
    my $l = length($_);

    if    ($l == 2) { "1" }
    elsif ($l == 4) { "4" }
    elsif ($l == 3) { "7" }
    elsif ($l == 7) { "8" }
    elsif ($l == 5) {
      if    (intersect($_, $one)  == 2) { "3" }
      elsif (intersect($_, $four) == 2) { "2" }
      else                              { "5" }
    }
    elsif ($l == 6) {
      if    (intersect($_, $one)  == 1) { "6" }
      elsif (intersect($_, $four) == 4) { "9" }
      else                              { "0" }
    }
  } @digits;

  return join("", @out);
}

sub intersect {
  return (my @elems = join("", @_) =~ /(\w)(?=.*\1)/g);
}

chomp(my @input = <>);
print("Part 1: ", part_1(@input), "\n");
print("Part 2: ", part_2(@input), "\n");
