package Minimal::ImageSearch;

use strict;
use warnings;

use Imager;
use base qw/Class::Accessor::Fast/;
__PACKAGE__->mk_accessors(qw/image sample width height colorusage/);

sub new {
    my ( $klass, $imager_or_filename ) = @_;
    my $img = undef;
    if (ref $imager_or_filename eq "Imager") {
        $img = $imager_or_filename;
    }
    else {
        $img = Imager->new(file => $imager_or_filename) or die Imager->errstr;
    }
    return bless +{
        image      => $img,
        sample     => undef,
        width      => undef,
        height     => undef,
        colorusage => +{},
    }, $klass;
}

sub get_color_distribution_stat {
    my ($self, $level, $output_file) = @_;

    my $sample = $self->sample($self->image->copy);

    $sample->filter(type=>"postlevels", levels=>$level) or die $self->sample->errstr;
    $sample->write("$output_file") if(defined $output_file);

    $self->colorusage($sample->getcolorusagehash);
}

sub get_pixels_info {
    my ($self) = @_;
    
}



1;
