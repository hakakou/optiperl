#Name: Random Color Coding
#Description: Selects random colors for box & line coding
#Icon: %opti%Tools.icl,147

use Win32::OLE;

sub Initialization {
 $optiperl = Win32::OLE->new('OptiPerl.Application');
 $plug_id = $_[0];

 @RGB = hex2rgb($optiperl -> GetColor("EditorColor"));

 if ($RGB[0]>128) {
  $lum = 220; # we have a light background
 }
 else
 {
  $lum = 40;  # we have a dark background
 }

 $sat = 235; # (0..240)

 sub DoColor {
  $hue=rand(240);
  $color=HSLRangeToRGB($hue,$sat,$lum);
  $optiperl -> SetColor($_[0],$color);
 }

 for (my $i=1; $i<=6; $i++)
 {
  DoColor("Line".$i."Color");
  DoColor("BoxBr".$i."Color");
  DoColor("BoxPar".$i."Color");
 }

 DoColor("BoxHereDocColor");
 DoColor("BoxPodColor");

 $optiperl -> UpdateOptions(1);
 $optiperl->EndPlugIn($plug_id);
}

sub Finalization {
}

sub HSLRangeToRGB
{
 ($R, $G, $B) =
  HSLtoRGB(($_[0]-1) / (240-1), $_[1] / 240, $_[2] / 240);
 return rgb2hex($R, $G, $B);
}


sub HSLtoRGB {

  sub HueToColourValue {
   my $V;
   my $Hue=$_[0];
   if ($Hue < 0) {
      $Hue = $Hue + 1
   }
    else
   {
      if ($Hue > 1) {
        $Hue = $Hue - 1;
      }
   }

   if ((6 * $Hue) < 1) {
      $V = $M1 + ($M2 - $M1) * $Hue * 6;
   }
    else
   {
      if ((2 * $Hue) < 1) {
        $V = $M2
      }
      else
      {
        if ((3 * $Hue) < 2) {
          $V = $M1 + ($M2 - $M1) * (2/3 - $Hue) * 6
        }
        else
        {  $V = $M1; }
      }
    }
    return int (255 * $V);
  }

 ($H, $S, $L) = @_;
 if ($S == 0)
 {
    $R = int (255 * $L);
    $G = $R;
    $B = $R;
 }
 else {
    if ($L <= 0.5)
      { $M2 = $L * (1 + $S) }
    else
      { $M2 = $L + $S - $L * $S }
    $M1 = 2 * $L - $M2;
    $R = HueToColourValue ($H + 1/3);
    $G = HueToColourValue ($H);
    $B = HueToColourValue ($H - 1/3)
  }

  return ($R, $G, $B);
}

sub hex2rgb {
    my $clr = shift;
    my @rgb = $clr =~ /^#([a-f0-9]{2})([a-f0-9]{2})([a-f0-9]{2})$/i;
    return unless @rgb;
    return map { hex $_ } @rgb;
}

sub rgb2hex {
    return unless @_ == 3;
    my $color = '#';
    foreach my $cc (@_)
    {
        $color .= sprintf("%02x", $cc);
    }
    return $color;
}

if (! defined $valid_plugin)
{
 Initialization;
}