#requires -version 7
using namespace System.Drawing
using namespace System.Windows.Forms
using namespace System.Drawing.Drawing2D

Add-Type -AssemblyName System.Windows.Forms

function draw_rectangle {
  param(
    [Graphics]$g,
    [Brush]$b,
    [Int32]$level,
    [RectangleF]$r
  )

  end {
    $level -eq 0 ? $g.FillRectangle($b, $r) : $(
      $h, $w = ($r.Height / 3), ($r.Width / 3)

      $x0, $y0 = $r.Left, $r.Top
      $x1, $y1 = ($x0 + $w), ($y0 + $h)
      $x2, $y2 = ($x0 + $w * 2), ($y0 + $h * 2)

      (($x0, $y0), ($x1, $y0), ($x2, $y0), ($x0, $y1),
       ($x2, $y1), ($x0, $y2), ($x1, $y2), ($x2, $y2)).ForEach{
         draw_rectangle $g $b ($level - 1) ([RectangleF]::new($_[0], $_[1], $w, $h))
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
    [Single]$margin = 10
    [RectangleF]$r = [RectangleF]::new(
      $margin, $margin, $bmp.Width - 2 * $margin, $bmp.Height - 2 * $margin
    )
    # (re)draw carpet
    draw_rectangle $g (
      $b = [SolidBrush]::new([Color]::Magenta)
    ) $nudLvls.Value $r
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
  Size = [Size]::new(285, 257)
}

$frmMain = New-Object Form -Property @{
  ClientSize = [Size]::new(309, 310)
  FormBorderStyle = [FormBorderStyle]::FixedSingle
  Icon = ($ico = [Icon]::ExtractAssociatedIcon("$PSHome\pwsh.exe"))
  StartPosition = [FormStartPosition]::CenterScreen
  Text = 'Sierpinski Carpet'
}
$frmMain.Controls.AddRange(@($lblLvls, $nudLvls, $pbImage))
$frmMain.Add_Load({ draw_fractal })
$frmMain.Add_Resize({ draw_fractal })
$frmMain.Add_FormClosing({
  if ($bmp) { $bmp.Dispose() }
  if ($ico) { $ico.Dispose() }
  $this.Controls.ForEach{ $_.Dispose() }
})
[void]$frmMain.ShowDialog()
