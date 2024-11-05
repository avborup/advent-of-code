package utils::ComplexNumberHash;

use strict;

use Tie::Hash;
use Carp;
use Math::Complex;

use vars qw(@ISA);
@ISA = qw(Tie::StdHash);

sub hash_cplx {
  my ($cplx) = @_;
  my ($x, $y) = (Re($cplx) + 1, Im($cplx) + 1);
  return (($x + $y) * ($x + $y + 1) / 2) + $y;
}

sub unhash {
  my ($n) = @_;
  my $w = int((sqrt(8*$n + 1) -1) /2);
  my $t = ($w*$w + $w)/2;
  my $y = $n - $t;
  my $x = $w - $y;
  return cplx(int($x) - 1, int($y) - 1);
}

sub TIEHASH {
  my $class = shift;

  my %hash;
  @hash{@_} = ();
  my $fields = {
    HASH => \%hash,
    KEY_ITER => undef,
  };

  bless $fields, $class;
}

sub STORE {
  my ($self, $key, $val) = @_;
  my $h = hash_cplx($key);
  $self->{HASH}->{$h} = $val;
}

sub FETCH {
  my ($self, $key) = @_;
  my $v = $self->{HASH}->{hash_cplx($key)};
  return $v;
}

sub EXISTS {
  my ($self, $key) = @_;
  return exists $self->{HASH}->{hash_cplx($key)};
}

sub DELETE {
  my ($self, $key) = @_;
  delete $self->{HASH}->{hash_cplx($key)};
}

sub FIRSTKEY {
  my $self = shift;
  $self->{KEY_ITER} = [ map { unhash($_) } keys %{$self->{HASH}} ];
  return $self->NEXTKEY;
};

sub NEXTKEY {
  my $self = shift;
  return shift @{$self->{KEY_ITER}};
}

sub SCALAR {
    my $self = shift;
    return scalar %{$self->{HASH}};
}
