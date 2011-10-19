#!/usr/bin/env perl

use strict;
use Imager;
use Data::Dump qw/dump/;

use Minimal::ImageSearch;

die "Usage: $0 filename\n" if !-f $ARGV[0];
my ($file, $loop_max) = @ARGV;
$loop_max ||= 5;

my $img = Minimal::ImageSearch->new($file) or die Imager->errstr;

for (1..$loop_max) {
    #print dump($img->get_color_distribution_stat($_, "/private/tmp/output$_.bmp"));
    print dump($img->get_color_distribution_stat($_, "./output$_.bmp"));
}
