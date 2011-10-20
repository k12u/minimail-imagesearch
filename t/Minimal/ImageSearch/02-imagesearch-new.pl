use Test::More;

use Minimal::ImageSearch;

my $o = Minimal::ImageSearch->new();
is($o->feature_strategy, 'plain');
is($o->correlation_method, 'cosine');
is($o->sample_level, 5);

done_testing;

