using namespace System.Drawing
using namespace System.Windows.Forms
using namespace System.Drawing.Drawing2D

Add-Type -AssemblyName System.Windows.Forms

function points([Int32]$triangles) {
  end {
    [PointF[]]$points = @()

    for ($radius, $theta, $i = 1, 0, 1; $i -le $triangles + 1; $i++) {
      $points += [PointF]::new(
        (($radius = [Math]::Sqrt($i)) * [Math]::Cos($theta)),
        ($radius * [Math]::Sin($theta))
      )
      $theta -= [Math]::Atan2(1, $radius)
    }
    $points
  }
}

$lblTrgl = New-Object Label -Property @{
  Location = [Point]::new(12, 15)
  Size = [Size]::new(63, 17)
  Text = 'Triangles:'
}

$nudTrgl = New-Object NumericUpDown -Property @{
  Location = [Point]::new(81, 12)
  Minimum = 3
  Maximum = 110
  Size = [Size]::new(49, 20)
  TextAlign = [HorizontalAlignment]::Right
}

$btnDraw = New-Object Button -Property @{
  Location = [Point]::new(29, 45)
  Text = 'Draw'
}
$btnDraw.Add_Click({
  if ($bmp) { $bmp.Dispose() } # release previous image
  $points, $img = (points $nudTrgl.Value), $pbImage.ClientSize

  # points' bounds
  $xmin, $ymin = $points[0].X, $points[0].Y
  $xmax, $ymax = $xmin, $ymin

  foreach ($p in $points) {
    if ($xmin -gt $p.X) { $xmin = $p.X }
    if ($xmax -lt $p.X) { $xmax = $p.X }
    if ($ymin -gt $p.Y) { $ymin = $p.Y }
    if ($ymax -lt $p.Y) { $ymax = $p.Y }
  }

  $script:bmp = New-Object Bitmap($img.Width, $img.Height)
  $g = [Graphics]::FromImage($bmp)
  $g.SmoothingMode = [SmoothingMode]::AntiAlias
  $g.Clear([Color]::White)

  $rd = [RectangleF]::new($xmin, $ymin, ($xmax - $xmin), ($ymax - $ymin))
  $rt = [RectangleF]::new(5, 5, ($img.Width - 10), ($img.Height - 10))

  $g.ResetTransform()
  # center the drawing area
  $dcx, $dcy = (($rd.Left + $rd.Right) / 2), (($rd.Top + $rd.Bottom) / 2)
  $g.TranslateTransform(-$dcx, -$dcy)
  # scale factors for both directions
  $scx, $scy = ($rt.Width / $rd.Width), ($rt.Height / $rd.Height)
  $g.ScaleTransform($scx, $scy, [MatrixOrder]::Append)
  # translate to center over drawing area
  $gcx, $gcy = (($rt.Left + $rt.Right) / 2), (($rt.Top + $rt.Bottom) / 2)
  $g.TranslateTransform($gcx, $gcy, [MatrixOrder]::Append)
  # draw...
  $p = [Pen]::new([Color]::Gray, 0)
  $s = [SolidBrush]::new([Color]::LawnGreen)
  # ...each triangle
  for ($i = $points.Length - 1; $i -gt 0; $i--) {
    [PointF[]]$pf = [PointF]::new(0, 0), (
      [PointF]::new($points[$i].X, $points[$i].Y)
    ), [PointF]::new($points[$i - 1].X, $points[$i - 1].Y)
    $g.DrawPolygon($p, $pf)
    $g.FillPolygon($s, $pf)
  }
  # show spiral
  $pbImage.Image = $bmp
  # release resources
  ($s, $p, $g).ForEach{ $_.Dispose() }
})

$pbImage = New-Object PictureBox -Property @{
  BackColor = [Color]::White
  BorderStyle = [BorderStyle]::Fixed3D
  Location = [Point]::new(136, 12)
  Size = [Size]::new(237, 217)
  SizeMode = [PictureBoxSizeMode]::StretchImage
}

$frmMain = New-Object Form -Property @{
  BackColor = [Color]::LightGray
  FormBorderStyle = [FormBorderStyle]::FixedSingle
  Icon = ($ico = [Icon]::ExtractAssociatedIcon("$PSHome\pwsh.exe"))
  MaximizeBox = $false
  Size = [Size]::new(395, 285)
  StartPosition = [FormStartPosition]::CenterScreen
  Text = 'Spiral of Theodorus'
}
$frmMain.Controls.AddRange(@($lblTrgl, $nudTrgl, $btnDraw, $pbImage))
$frmMain.Add_Load({ $nudTrgl.Value = 110 })
$frmMain.Add_FormClosing({
  if ($bmp) { $bmp.Dispose() }
  if ($ico) { $ico.Dispose() }
  $this.Controls.ForEach{ $_.Dispose() }
})
[void]$frmMain.ShowDialog()
