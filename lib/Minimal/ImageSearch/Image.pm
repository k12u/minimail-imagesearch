package Minimal::ImageSearch::Image;

use strict;
use warnings;

use Imager;
use base qw/Class::Accessor::Fast/;
__PACKAGE__->mk_accessors(qw/image sample width height color_stat pixels_info/);

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
        color_stat => +{},
    }, $klass;
}

# 画像の特徴検出：とてもシンプルな実装方法
sub get_color_distribution_stat {
    my ($self, $level, $output_file) = @_;
    $self->_confirm_init_sample($level, $output_file);
    $self->color_stat($self->sample->getcolorusagehash);
}

# 画像の特徴検出：細かい制御を入れる場合の実装
sub get_pixels_info {
    my ($self, $level, $output_file) = @_;
    $self->_confirm_init_sample($level, $output_file);
    $self->_confirm_init_pixel_info();

    my $pixels_info = $self->pixels_info(+[]);

    for my $x ( 0..$self->width -1) {
        $pixels_info->[$x] = $self->sample->getpixel( x => $x );
    }

    # # Imagerは行/列単位でデータを取得できるが、できない場合のよくある書き方
    # for my $x ( 0..$self->width -1) {
    #     for my $y ( 0..$self->width -1) {
    #         my $color = $self->sample->getpixel( x => $x, y => $y );
    #     }
    # }
}

sub _confirm_init_pixel_info {
    my $self = shift;
    $self->height( $self->sample->getheight) unless defined $self->height;
    $self->width(  $self->sample->getwidth)  unless defined $self->width;
    return 1;
}

sub _confirm_init_sample {
    my ($self, $level, $output_file) = @_;
    my $sample = $self->sample($self->image->copy);
    $sample->filter(type=>"postlevels", levels=>$level) or die $self->sample->errstr;
    $sample->write("$output_file") if(defined $output_file);
    return 1;
}



1;
