using namespace System.Drawing
using namespace System.Windows.Forms
using namespace System.Drawing.Drawing2D

Add-Type -AssemblyName System.Windows.Forms

function draw_triangle {
  param (
    [Graphics]$g,
    [Int32]$level,
    [PointF]$top,
    [PointF]$left,
    [PointF]$right
  )

  end {
    $level -eq 0 ? $(
      $g.FillPolygon([Brushes]::DarkMagenta, [PointF[]]($top, $left, $right))
    ) : $(
      [PointF[]]$points = (
        [PointF]::new(($top.X + $left.X) / 2, ($top.Y + $left.Y) / 2),
        [PointF]::new(($top.X + $right.X) / 2, ($top.Y + $right.Y) / 2),
        [PointF]::new(($left.X + $right.X) / 2, ($left.Y + $right.Y) / 2)
      )
      # draw small triangles (recursive)
      draw_triangle $g ($level - 1) $top $points[0] $points[1]
      draw_triangle $g ($level - 1) $points[0] $left $points[2]
      draw_triangle $g ($level - 1) $points[1] $points[2] $right
    )
  }
}

function draw_fractal {
  end {
    if ($bmp) { $bmp.Dispose() } # releasing previous image
    $script:bmp = [Bitmap]::new($pbImage.ClientSize.Width, $pbImage.ClientSize.Height)

    $g = [Graphics]::FromImage($bmp)
    $g.Clear([Color]::White)
    $g.SmoothingMode = [SmoothingMode]::AntiAlias
    # top-level triangle points (top, left and right)
    [PointF[]]$points = (
      [PointF]::new($pbImage.ClientSize.Width / 2, 10),
      [PointF]::new(10, $pbImage.ClientSize.Height - 10),
      [PointF]::new($pbImage.ClientRectangle.Right - 10, $pbImage.ClientRectangle.Bottom - 10)
    )
    draw_triangle $g $nudLvls.Value $points[0] $points[1] $points[2]
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
  Maximum = 9
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
  Text = 'Sierpinski Triangle'
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
