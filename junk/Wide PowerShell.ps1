#
$winWidth = 132
$pswin = $(get-host).ui.rawui
$bufsiz = $pswin.buffersize
$bufsiz.width = $winWidth
$pswin.buffersize = $bufsiz
$winsiz = $pswin.windowsize
$winsiz.width = $winWidth
$pswin.windowsize = $winsiz
