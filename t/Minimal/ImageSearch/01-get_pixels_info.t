use Test::More;

use Minimal::ImageSearch::Image;

my $img = Minimal::ImageSearch::Image->new('t/resources/nasa.png');

my $level = 4;
my $p =  $img->get_pixels_info($level);

ok(1);
done_testing;
