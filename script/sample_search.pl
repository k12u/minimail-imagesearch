#!/usr/bin/env perl

use strict;
use Imager;
use Data::Dump qw/dump/;

use Minimal::ImageSearch;
use Minimal::ImageSearch::Image;
use File::Zglob;

my ($query_image, $given_sample_level) = @ARGV;

die "Usage: $0 query_image_path sample_level" unless $given_sample_level;

my $minimal_search = Minimal::ImageSearch->new(
    feature_strategy => 'plain',
    correlation_method => 'cosine',
    sample_level => $given_sample_level,
);

my @files = zglob('images/*');
for my $file (@files) {
    $minimal_search->add_image($file);
}

$minimal_search->search($query_image);
