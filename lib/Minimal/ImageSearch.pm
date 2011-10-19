package Minimal::ImageSearch;

use strict;
use warnings;

use Imager;

sub new {
    my ( $klass, $imager_or_filename ) = @_;
    my $img = undef;
    if (ref $imager_or_filename eq "Imager") {
        $img = $imager_or_filename;
    }
    else {
        $img = Imager->new(file => $imager_or_filename) or die Imager->errstr;
    }
    return bless +{ image => $img }, $klass;
}

sub get_color_distribution_stat {
    my ($self, $level, $output_file) = @_;

    my $copy = $self->{image}->copy;
    $copy->filter(type=>"postlevels", levels=>$level) or die $copy->errstr;
    $copy->write("$output_file") if(defined $output_file);

    return $copy->getcolorusagehash;
}

sub get_pixels_info {
    
}

1;
