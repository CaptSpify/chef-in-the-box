<?php 

#################
# XSPF JUKEBOX PHP PLAYLIST GENERATOR
# LACY MORROW 2007
# FOR USE WITH THE XSPF JUKEBOX AND PLAYER AT
# http://blog.geekkid.net
# 
# Adapted from Automatic XSPF Playlist generator PHP Script v2.0
# dreden http://www.dreden.com
#################

//DIRECTORIES

// use individual track images? if true then images must have the same title as track, and be in the same folder
$image = false;

// use mp3 id3 tags or use the file/folder names to get artist and titles?
$useid3 = true;
$getid3file = "id3/getid3.php";
$id3version = 2; // either 1 or 2

// the directory that contains the music files
$musicdir = "music";

// the url path to the music directory
$path = "http://www.YOURDOMAIN.com/music/";


### NO NEED TO EDIT BELOW THIS LINE ###

$genList = false;
if(file_exists("xspf_generated_playlist.xml")){
if((date("z")-date("z", filemtime("xspf_generated_playlist.xml")) >= 7) || date("z") < 7){
$genList = true;
} else {
readfile("xspf_generated_playlist.xml");
}} else {
$genList = true;
}

if($genList == true){
$output = "";
if(substr($path, -1) != "/"){
	$path .= "/";
}
if ($useid3) {
	require_once($getid3file);
	$getID3 = new getID3;
	}
if (is_dir($musicdir)) {
	$i = 0;
	$output .= "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<playlist version=\"0\" xmlns = \"http://xspf.org/ns/0/\">\n";
	$output .= "<trackList>\n";
	if ($handle = opendir($musicdir)) {
		while (false !== ($file = readdir($handle))) {
			if ($file == "." || $file == "..") { $file = ""; }
		elseif (is_dir("$musicdir/$file")) {
			foreach (glob("$musicdir/$file/*.mp3") as $filename) {
			if (strpos($filename, '.mp3')){
			$audiofile[$i] = str_replace("$musicdir/", "", $filename);
			$i++;
}
			}
		} else {	
			if (strpos($file, '.mp3')){		
			$audiofile[$i] = $file;
			$i++;
			}
		}
	}
closedir($handle);
	}
sort($audiofile);
reset($audiofile);

for($j = 0; $j < count($audiofile); $j++) 
	{
		$filename = "$musicdir" . "/" . "$audiofile[$j]";
		$tempname = substr($filename, strrpos($filename, '/')+1);
		if ($image) {
			foreach (glob(dirname($filename)."/".substr($tempname, 0, strpos($tempname, '.mp3')).".*") as $tempfile) {
if (strpos($tempfile, '.jpg') || strpos($tempfile, '.bmp') || strpos($tempfile, '.gif') || strpos($tempfile, '.png')) {
			$audioimage[$j] = $tempfile;
}
			}
		}
		if($useid3) 
		{
		$fileinfo = $getID3->analyze($filename);
		if (!$fileinfo['tags']['id3v'.$id3version]['title']['0']){
			$filetitle = substr($tempname, 0, strpos($tempname, '.mp3'));
		} else {
			$filetitle = $fileinfo['tags']['id3v'.$id3version]['title']['0'];
}
		}
	$output .= "<track><location>" . $path . $audiofile[$j] . "</location>";

		if ($useid3) 
		{
		$output .= "<creator>" . $fileinfo['tags']['id3v'.$id3version]['artist']['0'] . "</creator><title>" . $filetitle . "</title>";
if ($audioimage[$j]){
		$output .= "<image>" . $audioimage[$j] . "</image>";
}
$output .= "</track>\n";
		} else {
if (!strrpos(dirname($filename), '/')){		
$tempcreator = substr(dirname($filename), 0);
} else {
$tempcreator = substr(dirname($filename), strrpos(dirname($filename), '/')+1);
}
		$output .= "<creator>" . $tempcreator . "</creator><title>" . substr($tempname, 0, strpos($tempname, '.mp3')) . "</title>";
if ($audioimage[$j]){
		$output .= "<image>" . $audioimage[$j] . "</image>";
}
$output .= "</track>\n";
}
	}
$output .= "</trackList>\n</playlist>\n";
print($output);
$fh = fopen("xspf_generated_playlist.xml", 'w') or die("can't open file");
fwrite($fh, $output);
fclose($fh);
}

else {
echo "<font color=\"red\"><center><h2>ERROR:<br>\nthe directory $musicdir cannot be found\n<br>please check your configuration</h2></center></font>";
}
}
?> 