#!/usr/bin/perl -w
use strict; use warnings;

use File::Path qw(make_path);

my $day = $ARGV[0] // die "Usage: $0 <day>\n";
my $sol_file = "day$day.pl";

open(my $fh, '>', $sol_file) or die $!;
print $fh <<'EOF';
#!/usr/bin/perl -w
use strict; use warnings;

use Data::Dumper;

sub part_1 {
  "?"
}

sub part_2 {
  "?"
}

my @input = map { chomp; $_ } <>;

print Dumper(\@input);

print("Part 1: ", part_1(@input), "\n");
print("Part 2: ", part_2(@input), "\n");
EOF
# Make solution file executable
chmod(0755, $sol_file);

make_path("inputs/$day");

print "Initialised day $day - happy coding!\n";
