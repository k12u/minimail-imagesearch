#!/usr/bin/env perl

use strict;
use Imager;
use Data::Dump qw/dump/;

die "Usage: $0 filename\n" if !-f $ARGV[0];
my ($file, $loop_max) = @ARGV;
$loop_max ||= 5;

my $img = Imager->new(file=>$file) or die Imager->errstr;

for (1..$loop_max) {
  process($_);
}

sub process {
  my $level = shift;
  my $copy = $img->copy;
  $copy->filter(type=>"postlevels", levels=>$level) or die $img->errstr;
  $copy->write("/tmp/output$level.bmp");
  print "level: $level\n";
  print dump($copy->getcolorusagehash);
  print "\n";
}
