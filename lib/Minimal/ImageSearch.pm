package Minimal::ImageSearch;

use strict;

use Data::Dump qw/dump/;
use base qw/Class::Accessor::Fast/;
__PACKAGE__->mk_accessors(qw/repository dictionary feature_strategy correlation_method sample_level/);

sub DEFAULT_FEATURE_STRATEGY   { 'plain'  }
sub DEFAULT_CORRELATION_METHOD { 'cosine' }
sub DEFAULT_SAMPLE_LEVEL       { 5; }

sub new {
    my ($klass, %opts) = @_;
    bless {
        feature_strategy   => DEFAULT_FEATURE_STRATEGY,
        correlation_method => DEFAULT_CORRELATION_METHOD,
        sample_level       => DEFAULT_SAMPLE_LEVEL,
        %opts,
    }, $klass;
}

sub search {
    my ( $self, $query_image ) = @_;
    my $result = $self->_search($query_image);
    
    print $self->_format_html( $result);
}

sub _format_html {
    my ($self, $data) = @_;

    for (@$data) {
        $_->confirm_init_pixel_info();
        printf qq{<img src="%s" width="%d" height="%s">%s : %d<br>\n},
            $_->file,$_->width/4, $_->height/4, $_->file, $_->correlation;
    }
}

sub _search {
    my ( $self, $query_image ) = @_;
    my $query = $self->_init_query($query_image);

    my %correlation = ();

    return [ $query, sort {
        ($correlation{$b} ||= $self->get_correlation($query, $b))
            <=>
                ($correlation{$a} ||= $self->get_correlation($query, $a))
            } @{ $self->repository }
           ];
}

sub _init_query {
    my ( $self, $image ) = @_;
    my $query_image = Minimal::ImageSearch::Image->new($image);
    $query_image->extract_feature( $self->feature_strategy, $self->sample_level );
    return $query_image;
}

sub add_image {
    my ( $self, $image ) = @_;
    $self->_confirm_init_repository();
    my $img_object = Minimal::ImageSearch::Image->new($image);
    $img_object->extract_feature( $self->feature_strategy, $self->sample_level  );
    push @{ $self->repository } , $img_object;
    $self->dictionary->{$image} = $img_object;
}

sub _confirm_init_repository {
    my ($self) = @_;
    $self->repository( +[] ) unless defined $self->repository;
    $self->dictionary( +{} ) unless defined $self->dictionary;;
}

sub get_correlation {
    my ( $self, $query_image, $target_image ) = @_;

    if ($self->correlation_method eq "cosine") {
        return $self->cosine( $query_image, $target_image);
    }
    if ($self->correlation_method eq "euclid") {
        return $self->euclid( $query_image, $target_image);
    }
    # 宿題
    # elsif () {
    # ...
    # }
}

sub cosine {
    my ($self, $query_image, $target_image ) = @_;
    my $cosine = 0;
    for my $k (keys %{ $query_image->color_stat } ) {
        $cosine += $query_image->{color_stat}{$k} * $target_image->{color_stat}{$k};
    }
    $target_image->confirm_init_pixel_info();
    $cosine /= ($target_image->width * $target_image->height);
    $target_image->correlation($cosine);
    return $cosine;
}

# 宿題
sub euclid {
    my ($self, $query_image, $target_image ) = @_;
    return 1;
}

1;
