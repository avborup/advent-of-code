use strict; use warnings;

use Data::Dumper;
use List::Util qw(any all first sum);
use Algorithm::Permute;

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

sub solve {
  my ($line) = @_;
  my @samples = $line =~ /\b(\w+)\b(?=.*\|)/g;
  my @digits = /\b(\w+)\b(?!.*\|)/g;

  my $permutations = Algorithm::Permute->new(["a" .. "g"]);
  my @mapping;
  while (@mapping = $permutations->next) {
      last if is_valid(\@mapping, \@samples);
  }

  my @out;
  for my $d (@digits) {
    my $m = mask_from_sample(\@mapping, $d);
    my $i = first { $valid_masks[$_] == $m } 0..$#valid_masks;
    push @out, $i;
  }

  return join("", @out);
}

sub mask_from_sample {
  my ($mapping, $sample) = @_;
  my $mask = 0;
  for my $c (split //, $sample) {
    my $i = first { $mapping->[$_] eq $c } 0..$#{$mapping};
    $mask |= 0b1000000 >> $i;
  }
  return $mask;
};

sub is_valid {
  my ($mapping, $samples) = @_;
  my $n = scalar @$mapping;
  my @masks = map { mask_from_sample($mapping, $_) } @$samples;

  return all { my $m = $_; any { $m == $_ } @valid_masks } @masks;
};

chomp(my @input = <>);
print("Part 1: ", part_1(@input), "\n");
print("Part 2: ", part_2(@input), "\n");
