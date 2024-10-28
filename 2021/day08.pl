use strict; use warnings;

use Data::Dumper;
use List::Util qw(any all first sum);
use experimental 'smartmatch';

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

  my @by_length = sort { @$a <=> @$b } map { [split //] } @samples;

  #  | 1  | 7  | 4  |    2, 3, 5   |    0, 6, 9   | 8  |
  my ($p1, $p2, $p3, $p4, $p5, $p6, $p7, $p8, $p9, $p10) = @by_length;

  my ($a) = grep { not contains($p1, $_) } @$p2;
  my $cf = $p1;
  my @bd = grep { not contains($cf, $_) } @$p3;
  my $five = first { my $v = $_; all { contains($v, $_) } @bd } ($p4, $p5, $p6);
  my ($c) = grep { not contains($five, $_) } @$cf;
  my ($f) = grep { $_ ne $c } @$cf;
  my $two = first { not contains($_, $f) } ($p4, $p5, $p6);
  my ($e) = grep { $_ ne $c && not contains($five, $_) } @$two;
  my ($b) = grep { $_ ne $f && not contains($two, $_) } @$five;
  my ($g) = grep { $_ ne $a && not contains($p3, $_) } @$five;
  my ($d) = grep { $_ ne $b && $_ ne $c && $_ ne $f } @$p3;

  my @mapping = ($a, $b, $c, $d, $e, $f, $g);

  return join("", map { digit_to_num(\@mapping, $_) } @digits);
}

sub contains {
  my ($array, $str) = @_;
  return any { $_ eq $str } @$array;
}

sub digit_to_num {
  my ($mapping, $digit) = @_;

  my @valid_masks = (
    # abcdefg
    0b1110111, # 0
    0b0010010, # 1
    0b1011101, # 2
    0b1011011, # 3
    0b0111010, # 4
    0b1101011, # 5
    0b1101111, # 6
    0b1010010, # 7
    0b1111111, # 8
    0b1111011, # 9
  );

  my $mask = 0;
  for my $c (split //, $digit) {
    my $i = first { $mapping->[$_] eq $c } 0..$#{$mapping};
    $mask |= 0b1000000 >> $i;
  }

  return first { $mask == $valid_masks[$_] } 0..$#valid_masks;
};

chomp(my @input = <>);
print("Part 1: ", part_1(@input), "\n");
print("Part 2: ", part_2(@input), "\n");
