

*****************
TO USE 'embed.php' TO EMBED JUKEBOX, OPEN IN A PLAIN TEXT EDITOR
EDIT SETTINGS, AND CALL FROM A PHP PAGE USING "require_once("embed.php");"
*****************
PHP Playlist Creator for XSPF Jukebox
Lacy Morrow
2007 http://blog.geekkid.net
*****************

To use, you must have php installed and activated on your server.
To speed up playlister, make sure'playlist.php' has write permissions.

************USAGE***********

* Open the 'playlist.php' file with a plain text editor. Edit the top portions of the code to match your server settings. 

If you need individual images for each track (as opposed to one image for all tracks, or an Amazon supplied image), Set '$image' to true. 

Set '$useid3' to true if you plan on using id3 tags. 

Set the '$id3version' to 1 or 2, depending on your mp3 files. If you are not sure what to put here, use 1, if it does not work properly, try 2. If it still fails to label your music correctly, reconvert your id3 tags using a capable program (iTunes).


* Place the 'playlist.php' file on your webserver, some servers may require that you place it in a directory higher than your music folder.

* Place the entire 'id3' folder on your webserver, if you plan to use id3 tags to label your music.

* If you do not plan on using id3 tags, sort your music into sub-folders based on artist name. Label each mp3 with the correct track name (eg. Everything to Everyone.mp3).

* If you need individual images for each track, place the image in the same folder as the corresponding track, with the same file name (eg. Everything to Everyone.jpg).

* Link your '.swf' file to the playlist file using the variable 'playlist_url'.