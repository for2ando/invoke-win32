#!/c/WINDOWS/system32/WindowsPowerShell/v1.0/powershell

## PowerShell function which calls the win32 API: MoveWindow().

. .\Invoke-Win32.ps1

## test suite
#function Main([Int32]$hWnd, [Int32]$x, [Int32]$y, [Int32]$nWidth, [Int32]$nHeight)
function Main
{
  #MessageBox 0 "Hello, Win32 API(PowerShell)!" "Hello, World!" 0
  #$hWnd, $x, $y, $nWidth, $nHeight
  #$rc = Move-Window $hWnd $x $y $nWidth $nHeight $true
  $proc = @(ps|where {$_.name -eq "rxvt"})
  $proc0 = $proc[0]
  if ($proc0 -eq $null) { Write-Warning "No rxvt window."; return $false }
  $rect = New-Object RECT
  $rc1 = Get-WindowRect $(New-Object System.Runtime.InteropServices.HandleRef($proc0, $proc0.mainwindowhandle)) ([ref]$rect)
  $rc1
  ($rect.Left, $rect.Top, $rect.Right, $rect.Bottom)
  ($rect.X, $rect.Y, $rect.Width, $rect.Height)
  $rc2 = Move-Window $proc0.mainwindowhandle 320 240 200 200 $true
}

function Get-WindowHandles
{
  ps | Where-Object {$_.mainwindowtitle -ne ''} | select name,mainwindowhandle
}

Add-Type -ReferencedAssemblies "System.Drawing" -TypeDefinition @"
using System.Runtime.InteropServices;
[StructLayout(LayoutKind.Sequential)]
public struct RECT
{
   public int Left, Top, Right, Bottom;

   public RECT(int left, int top, int right, int bottom)
   {
     Left = left;
     Top = top;
     Right = right;
     Bottom = bottom;
   }

   public RECT(System.Drawing.Rectangle r) : this(r.Left, r.Top, r.Right, r.Bottom) { }

   public int X
   {
     get { return Left; }
     set { Right -= (Left - value); Left = value; }
   }

   public int Y
   {
     get { return Top; }
     set { Bottom -= (Top - value); Top = value; }
   }

   public int Height
   {
     get { return Bottom - Top; }
     set { Bottom = value + Top; }
   }

   public int Width
   {
     get { return Right - Left; }
     set { Right = value + Left; }
   }

   public System.Drawing.Point Location
   {
     get { return new System.Drawing.Point(Left, Top); }
     set { X = value.X; Y = value.Y; }
   }

   public System.Drawing.Size Size
   {
     get { return new System.Drawing.Size(Width, Height); }
     set { Width = value.Width; Height = value.Height; }
   }

   public static implicit operator System.Drawing.Rectangle(RECT r)
   {
     return new System.Drawing.Rectangle(r.Left, r.Top, r.Width, r.Height);
   }

   public static implicit operator RECT(System.Drawing.Rectangle r)
   {
     return new RECT(r);
   }

   public static bool operator ==(RECT r1, RECT r2)
   {
     return r1.Equals(r2);
   }

   public static bool operator !=(RECT r1, RECT r2)
   {
     return !r1.Equals(r2);
   }

   public bool Equals(RECT r)
   {
     return r.Left == Left && r.Top == Top && r.Right == Right && r.Bottom == Bottom;
   }

   public override bool Equals(object obj)
   {
     if (obj is RECT)
       return Equals((RECT)obj);
     else if (obj is System.Drawing.Rectangle)
       return Equals(new RECT((System.Drawing.Rectangle)obj));
     return false;
   }

   public override int GetHashCode()
   {
     return ((System.Drawing.Rectangle)this).GetHashCode();
   }

   public override string ToString()
   {
     return string.Format(System.Globalization.CultureInfo.CurrentCulture, "{{Left={0},Top={1},Right={2},Bottom={3}}}", Left, Top, Right, Bottom);
   }
}
"@

## A PowerShell wrapper for win32 api: GetWindowRect().
function Get-WindowRect([System.Runtime.InteropServices.HandleRef]$hWnd, [ref]$rect)
{ 
  $parameterTypes = [System.Runtime.InteropServices.HandleRef], [ref]
  $parameters = $hWnd, $rect
 
  Invoke-Win32 "user32.dll" ([Bool]) "GetWindowRect" $parameterTypes $parameters
}

## A PowerShell wrapper for win32 api: MoveWindow().
function Move-Window([Int32]$hWnd, [Int32]$x, [Int32]$y, [Int32]$nWidth, [Int32]$nHeight, [Bool]$bRepaint)
{ 
  $parameterTypes = [Int32], [Int32], [Int32], [Int32], [Int32], [Bool]
  $parameters = $hWnd, $x, $y, $nWidth, $nHeight, $bRepaint
 
  Invoke-Win32 "user32.dll" ([Int32]) "MoveWindow" $parameterTypes $parameters
}

function MessageBox([Int32] $hWnd, [String] $lpText, [String] $lpCaption, [Int32] $uType) 
{ 
   $parameterTypes = [Int32], [String], [String], [Int32]
   $parameters = $hWnd, $lpText, $lpCaption, $uType

   Invoke-Win32 "user32.dll" ([Int32]) "MessageBoxA" $parameterTypes $parameters
} 

#. Main
