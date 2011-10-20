use Test::More;

use Minimal::ImageSearch::Image;
use Data::Dump qw/dump/;

my $img = Minimal::ImageSearch::Image->new('t/resources/nasa.png');

my $level = 4;
my ($p) =  $img->get_color_distribution_stat($level);

is_deeply($p, +{
  "\0\0\0"       => 9851,
  "\0\0\@"       => 392,
  "\0\@\0"       => 26,
  "\0\@\@"       => 766,
  "\0\@\x80"     => 19,
  "\0\x80\@"     => 22,
  "\0\x80\x80"   => 100,
  "\0\x80\xC0"   => 5,
  "\0\xC0\x80"   => 2,
  "\0\xC0\xC0"   => 1,
  "\@\0\0"       => 1,
  "\@\@\0"       => 42,
  "\@\@\@"       => 1059,
  "\@\@\x80"     => 5,
  "\@\x80\@"     => 403,
  "\@\x80\x80"   => 762,
  "\@\x80\xC0"   => 348,
  "\@\x80\xFF"   => 1,
  "\@\xC0\x80"   => 50,
  "\@\xC0\xC0"   => 141,
  "\x80\@\0"     => 6,
  "\x80\@\@"     => 131,
  "\x80\x80\@"   => 1556,
  "\x80\x80\x80" => 2788,
  "\x80\x80\xC0" => 2707,
  "\x80\x80\xFF" => 5,
  "\x80\xC0\x80" => 87,
  "\x80\xC0\xC0" => 20,
  "\xC0\x80\@"   => 1195,
  "\xC0\x80\x80" => 1351,
  "\xC0\x80\xC0" => 57,
  "\xC0\xC0\@"   => 126,
  "\xC0\xC0\x80" => 2842,
  "\xC0\xC0\xC0" => 5,
  "\xFF\xC0\x80" => 8,
}) || dump $p;

done_testing;
