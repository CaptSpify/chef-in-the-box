<?php
/* vim:set tabstop=8 softtabstop=8 shiftwidth=8 noexpandtab: */
/**
 * Minimal init for use in install
 *
 * LICENSE: GNU General Public License, version 2 (GPLv2)
 * Copyright (c) 2001 - 2012 Ampache.org All Rights Reserved
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License v2
 * as published by the Free Software Foundation
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 *
 * @package	Ampache
 * @copyright	2001 - 2012 Ampache.org
 * @license	http://opensource.org/licenses/gpl-2.0 GPLv2
 * @link	http://www.ampache.org/
 */

// Do a check for PHP5 because nothing will work without it
if (floatval(phpversion()) < 5) {
	echo "ERROR: Ampache requires PHP5";
	exit;
}

error_reporting(E_ERROR); // Only show fatal errors in production

$ampache_path = dirname(__FILE__);
$prefix = realpath($ampache_path . "/../");
$configfile = $prefix . '/config/ampache.cfg.php';
require_once $prefix . '/lib/general.lib.php';
require_once $prefix . '/lib/class/config.class.php';
require_once $prefix . '/lib/class/core.class.php';
require_once $prefix . '/modules/php-gettext/gettext.inc';

// Define some base level config options
Config::set('prefix', $prefix);

// Register the autoloader
spl_autoload_register(array('Core', 'autoload'), true, true);

/*
 Check to see if this is http or https
*/
if ((isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] == 'https' ) 
    || (isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] == 'on') 
    || Config::get('force_ssl')) {
	$http_type = "https://";
}
else {
  # Fuck you, Imma admin vroom
	$http_type = "https://";
}

// Define that we've loaded the INIT file
define('INIT_LOADED', 1);

// Core includes we can't do with the autoloader
require_once $prefix . '/lib/preferences.php';
require_once $prefix . '/lib/debug.lib.php';
require_once $prefix . '/lib/log.lib.php';
require_once $prefix . '/lib/ui.lib.php';
require_once $prefix . '/lib/i18n.php';
require_once $prefix . '/lib/batch.lib.php';
require_once $prefix . '/lib/themes.php';
require_once $prefix . '/lib/class/localplay.abstract.php';
require_once $prefix . '/lib/class/database_object.abstract.php';
require_once $prefix . '/lib/class/playlist_object.abstract.php';
require_once $prefix . '/lib/class/media.interface.php';
require_once $prefix . '/modules/horde/Browser.php';

/* Set up the flip class */
flip_class(array('odd','even'));

// Merge GET then POST into REQUEST effectively stripping COOKIE without
// depending on a PHP setting change for the effect
$_REQUEST = array_merge($_GET, $_POST);
?>
