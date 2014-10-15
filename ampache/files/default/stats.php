<?php
//This script is an example of advanced usage stats available through the XSPF Jukebox. To use, pass the variable "statsurl" to the xspf_jukebox.swf file with the location of this stats.php file. On every track change, the stats script is called and passed the variables "playSong" and "annotation", playSong being the currently playing track label, and annotation being the annotation included in the playlist file.
putenv("TZ=US/Eastern"); //~ Time Zone
$ip = getenv('REMOTE_ADDR'); //~ get ip address 
$song = $_POST["track"]; //	creator,title,track,comment,annotation
$time = date("m/d/y H:i:s");
$file = fopen("log.txt", "a");
$entry = $time.", ".$ip.", ".$song."\n";
fwrite($file, $entry);
fclose($file);
echo ($time.", ".$ip.", ".$song);
echo ("&output=processed...");
?>