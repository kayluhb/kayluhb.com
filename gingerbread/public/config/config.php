<?php

include "functions.php";
error_reporting(1);
$dbhost = 'localhost';
$dbuser = 'gingerbread';
$dbpass = 'gumDr0p!@#';
$dbname = 'gingerbread';
$conn = mysql_connect($dbhost, $dbuser, $dbpass) 
or die('Error connecting to mysql');
mysql_select_db($dbname);

if (isset($_SERVER["REDIRECT_URL"]))
	$url = array_slice( explode("/",$_SERVER["REDIRECT_URL"]),1 ) ;


?>