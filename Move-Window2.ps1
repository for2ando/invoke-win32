#!/c/WINDOWS/system32/WindowsPowerShell/v1.0/powershell

## PowerShell function which calls the win32 API: MoveWindow().

. .\Invoke-Win32.ps1

## test suite
#function Main([Int32]$hWnd, [Int32]$x, [Int32]$y, [Int32]$nWidth, [Int32]$nHeight)
function Main2
{
  #MessageBox 0 "Hello, Win32 API(PowerShell)!" "Hello, World!" 0
  #$hWnd, $x, $y, $nWidth, $nHeight
  #$rc = Move-Window $hWnd $x $y $nWidth $nHeight $true
  $proc = @(ps|where {$_.name -eq "rxvt"})
  $proc0 = $proc[0]
  if ($proc0 -eq $null) { Write-Warning "No rxvt window."; return $false }
  $rect = New-Object RECT
  $rc1 = Get-WindowRect2 $(New-Object System.Runtime.InteropServices.HandleRef($proc0, $proc0.mainwindowhandle)) ([ref]$rect)
  $rc1
  Write-Output $rect.Left $rect.Top $rect.Right $rect.Bottom
  Write-Output ($rect.X, $rect.Y, $rect.Width, $rect.Height)
  $rc2 = Move-Window2 $proc0.mainwindowhandle 320 240 200 200 $true
}


Add-Type -Namespace Win32APIs -Name Window -MemberDefinition @"
  public struct Rect { public int left,top,right,bottom; }
  [DllImport("user32.dll")] public static extern int GetWindowRect(IntPtr hWnd, out Rect lpRect);
  [DllImport("user32.dll")] public static extern int MoveWindow(IntPtr hWnd, int x, int y, int nWidth, int nHeight, int bRepaint);
"@

## A PowerShell wrapper for win32 api: GetWindowRect().
function Get-WindowRect2([System.Runtime.InteropServices.HandleRef]$hWnd, [ref]$rect)
{ 
  [Win32APIs.Window]::GetWindowRect($hWnd, [Win32APIs.Window+Rect]$rect.value)
}

## A PowerShell wrapper for win32 api: MoveWindow().
function Move-Window2([Int32]$hWnd, [Int32]$x, [Int32]$y, [Int32]$nWidth, [Int32]$nHeight, [Bool]$bRepaint)
{ 
  [Win32APIs.Window]::MoveWindow($hWnd, $x, $y, $nWidth, $nHeight, $bRepaint)
}


#. Main2
