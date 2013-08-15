#!/usr/bin/env perl

# Copyright (C) 2009,2010 Xyne
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.



=pod

ABOUT

This script will generate a semirandom background image using Perl and
ImageMagick. See the options section of the code for a list of available
options and a brief description of what they do.

DEPENDENCIES
- perl
- imagemagick
- tput (for the progress bar)

=cut

use strict;
use warnings;

use Image::Magick;

my $OPTIONS = {
  # the output file (file extension determines type))
  '--file'    => 'img.png',

  # background color (grid)
  '--bg'      => '#050505',

  # image to overlay
  '--image'   => undef,

  # palette for tiles (imagemagick colors)
  '--palette' => '#0f0f0f #101010 #121212 #0c0c0c #111111',

  # how to overlay image (0:normally, 1+2:blocky)
  '--blocky'  => 0,

  # size of final image
  '--size'    => undef,

  # size of tiles
  '--tile'    => 7,

  # gravity of overlaid image (imagemagick parameter)
  '--gravity' => 'Center'
};

my $option;
foreach my $arg (@ARGV)
{
  if (substr($arg,0,1) eq '-')
  {
    $option = $arg;
  }
  elsif (defined($option))
  {
    $OPTIONS->{$option} = $arg;
  }
}


my $width;
my $height;
if (defined($OPTIONS->{'--size'}) and $OPTIONS->{'--size'} =~ m/^(\d+)x(\d+)$/)
{
  $width = $1;
  $height = $2;
}
else
{
  print "error: no size given\nusage: \"--size <width>x<height>\"\n";
  exit 1;
}
my @palette = split(/\s+/,$OPTIONS->{'--palette'});
my $file = $OPTIONS->{'--file'};
my $bg = $OPTIONS->{'--bg'};

my $image = Image::Magick->new();
$image->Set(size=>"${width}x${height}");
$image->ReadImage('xc:none');

my $img = $OPTIONS->{'--image'};
my $logo = Image::Magick->new();
if (defined($img))
{
  $logo->Set(background=>'none');
  $logo->ReadImage($img);
}

my $gravity = $OPTIONS->{'--gravity'};
$image->Composite(image=>$logo,gravity=>$gravity) if $OPTIONS->{'--blocky'} > 0 and defined($img);
my $f = $OPTIONS->{'--tile'};
my $n = scalar(@palette);
my $prog = 0;
my $total = int($width*$height/($f**2));
my $cols = `tput cols` - 2;
system('tput civis');

for (my $i=0;$i<$width/$f;$i++)
{
  for (my $j=0;$j<$height/$f;$j++)
  {
    my ($x1,$y1) = ($i*$f,$j*$f);
    my ($x2,$y2) = ($x1+$f-2,$y1+$f-2);

    my $r = int(rand($n));
    my $color = $palette[$r];

    if ($OPTIONS->{'--blocky'} > 0 and defined($img))
    {
      my ($red,$green,$blue,$alpha) = (0,0,0,0);
      for (my $k=$x1;$k<=$x2;$k++)
      {
        for (my $l=$y1;$l<=$y2;$l++)
        {
          my ($r,$g,$b,$a) = $image->GetPixel(y=>$l,x=>$k,channel=>'All');
          $red += $r;
          $green += $g;
          $blue += $b;
          $alpha += $a;
        }

      }
      if ($alpha/(($f-1)**2) < 0.5)
      {
        my $d = ($f-1)**2;
        $d -= $alpha if $OPTIONS->{'--blocky'} > 1;
        $color = sprintf("rgba(%d,%d,%d,1)",int(0xFF*$red/$d),int(0xFF*$green/$d),int(0xFF*$blue/$d));
      }
    }
    my ($m,$n) = ($x2+1,$y2+1);
    $image->Draw(fill=>$bg, primitive=>'rectangle', points=>"$x2,$y1 $m,$n");
    $image->Draw(fill=>$bg, primitive=>'rectangle', points=>"$x1,$y2 $m,$n");
    $image->Draw(fill=>$color, primitive=>'rectangle', points=>"$x1,$y1 $x2,$y2");

    $|++;
    $prog++;
    my $disp = int($prog*$cols/$total);
    $disp = $cols if $disp>$cols;
    print "\r[".('=' x $disp).(' ' x ($cols-$disp)).']';
  }
}
system('tput cnorm');

$image->Composite(image=>$logo,gravity=>$gravity) if $OPTIONS->{'--blocky'} < 1 and defined($img);
$image->Write(filename=>$file);
print "\nsaved image as $file\n";
