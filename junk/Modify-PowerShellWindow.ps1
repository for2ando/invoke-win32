# usage: . .\Modify-PowerShellWindow.ps1
# effect: Current window in which powershell is running is modified as follows.

$pswin = $(get-host).ui.rawui

$winpos = $pswin.windowposition
$winpos.x = 0
$winpos.y = 88
$pswin.windowposition = $winpos

$winWidth = 132
$bufsiz = $pswin.buffersize
$bufsiz.width = $winWidth
$pswin.buffersize = $bufsiz
$winsiz = $pswin.windowsize
$winsiz.width = $winWidth
$pswin.windowsize = $winsiz

$pswin.backgroundcolor = 'darkblue'
$pswin.foregroundcolor = 'white'
cls
