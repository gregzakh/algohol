#requires -version 7
using namespace System.Drawing
using namespace System.Windows.Forms
using namespace System.Drawing.Drawing2D

Add-Type -AssemblyName System.Windows.Forms

function get_corners { # corners of pentagon
  param(
    [PointF]$center,
    [Single]$radius
  )

  end {
    [PointF[]]$points = @()
    $theta, $delta = (-[Math]::PI / 2.0), (2.0 * [Math]::PI / 5.0)
    (0..4).ForEach{
      $points += [PointF]::new(
        $radius * [Math]::Cos($theta) + $center.X,
        $radius * [Math]::Sin($theta) + $center.Y
      )
      $theta += $delta
    }
    $points
  }
}

function draw_pentagon {
  param(
    [Graphics]$g,
    [Brush]$b,
    [Int32]$depth,
    [PointF]$center,
    [Single]$radius
  )

  end {
    $depth -le 0 ? $g.FillPolygon($b, (get_corners $center $radius)) : $(
      (get_corners $center ($radius - $radius * $factor)).ForEach{
        draw_pentagon $g $b ($depth - 1) $_ ($radius * $factor)
      }
    )
  }
}

function draw_fractal {
  end {
    if ($bmp) { $bmp.Dispose() } # releasing previous image
    $script:bmp = [Bitmap]::new(
      $pbImage.ClientSize.Width, $pbImage.ClientSize.Height
    )

    $g = [Graphics]::FromImage($bmp)
    $g.Clear([Color]::White)
    $g.SmoothingMode = [SmoothingMode]::AntiAlias
    [PointF]$center = [PointF]::new($bmp.Width / 2, $bmp.Height / 2)
    [Single]$radius = [Math]::Min($center.X, $center.Y)
    # (re)draw pentagon(s)
    draw_pentagon $g ( # standard solid brush
      $b = [SolidBrush]::new([Color]::Magenta)
    ) $nudLvls.Value $center $radius
    $b.Dispose()
    $g.Dispose()
    # showing image
    $pbImage.Image = $bmp
  }
}

$lblLvls = New-Object Label -Property @{
  Location = [Point]::new(12, 17)
  Size = [Size]::new(36, 13)
  Text = 'Level:'
}

$nudLvls = New-Object NumericUpDown -Property @{
  Location = [Point]::new(49, 14)
  Size = [Size]::new(39, 20)
  Maximum = 5
  Minimum = 0
  TextAlign = [HorizontalAlignment]::Right
  Value = 3
}
$nudLvls.Add_ValueChanged({ draw_fractal })

$pbImage = New-Object PictureBox -Property @{
  Anchor = [AnchorStyles]'Top, Bottom, Left, Right'
  BackColor = [Color]::White
  BorderStyle = [BorderStyle]::Fixed3D
  Location = [Point]::new(12, 41)
  Size = [Size]::new(285, 208)
}

$frmMain = New-Object Form -Property @{
  ClientSize = [Size]::new(309, 261)
  FormBorderStyle = [FormBorderStyle]::FixedSingle
  Icon = ($ico = [Icon]::ExtractAssociatedIcon("$PSHome\pwsh.exe"))
  StartPosition = [FormStartPosition]::CenterScreen
  Text = 'Sierpinski Pentagon'
}
$frmMain.Controls.AddRange(@($lblLvls, $nudLvls, $pbImage))
$frmMain.Add_Load({
  # scale factor for moving to smaller pentagons
  $script:factor = 1.0 / (2.0 * ([Math]::Cos([Math]::PI / 180 * 72) + 1))
  # draw
  draw_fractal
})
$frmMain.Add_Resize({ draw_fractal })
$frmMain.Add_FormClosing({
  if ($bmp) { $bmp.Dispose() }
  if ($ico) { $ico.Dispose() }
  $this.Controls.ForEach{ $_.Dispose() }
})
[void]$frmMain.ShowDialog()
