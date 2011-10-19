package Minimal::ImageSearch;

use Data::Dump qw/dump/;
use base qw/Class::Accessor::Fast/;
__PACKAGE__->mk_accessors(qw/repository dictionary feature_strategy correlation_method sample_level/);

sub DEFAULT_FEATURE_STRATEGY   { 'plain'  }
sub DEFAULT_CORRELATION_METHOD { 'cosine' }
sub DEFAULT_SAMPLE_LEVEL       { 5 }

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
        print dump($_);
    }
}

sub _search {
    my ( $self, $query_image ) = @_;
    my $query = $self->_init_query($query_image);
    return sort { $self->get_correlation($query, $_) } @{ $self->repository };
}

sub _init_query {
    my ( $self, $image ) = @_;
    my $query_image = Minimal::ImageSearch::Image->new($image);
    $query_image->extract_feature( $self->feature_strategy, $self->sample_level );
    return $query_image;
}

sub add_image {
    my ( $self, $image, $feature_strategy ) = @_;
    _confirm_init_repository();
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
    my ( $self, $query_image, $target_image, $correlation_method ) = @_;

    if ($correlation_method eq "cosine") {
        return $self->get_cosine( $query_image, $target_image);
    }
    # 宿題
    # elsif () {
    # ...
    # }
}

sub get_cosine {
    my ($self, $query_image, $target_image ) = @_;
    my $cosine = 0;
    for my $k (keys %$query_image) {
        $cosine += $query_image->{$k} * $target_image->{$k};
    }
    return $cosine;
}

1;
