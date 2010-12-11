<?php

define('BASE',getcwd().'/');
$showPage = false;
$dir =  $url[0];

switch($dir) {
	case 'send':
		email_cookie();
		break;
	default:
		$showPage = true;
}
if ($showPage) {
?><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="content-Type" content="text/html;charset=utf-8" />
	<title>Happy Holidays!</title>
    <meta id="description" name="description" content="" />
    <meta name="keyWords" content="holiday, gingerbread man" />
    <link rel="shortcut icon" href="images/favicon.ico" type="image/x-icon" />
	<link href="stylesheets/global.css" media="all" rel="stylesheet" type="text/css" />
    <script src="http://www.google.com/jsapi" type="text/javascript"></script>
	<script type="text/javascript">
//		google.load("jquery", "1.2.6");
		google.load("swfobject", "2.1");
	</script>
	<script type="text/javascript" src="javascripts/application.js"></script>
	<script type="text/javascript">
		var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
		document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
	</script>
	<script type="text/javascript">
		try {
		var pageTracker = _gat._getTracker("UA-592045-1");
		pageTracker._trackPageview();
		} catch(err) {}</script>
    <script type="text/javascript" src="javascripts/swfobject/swfaddress.js?tracker=pageTracker._trackPageview"></script>
    <script type="text/javascript">
        var vars = { xmlFile: '/gingerbread/xml/Main.xml' };
        var params = { bgcolor: '#ffffff' };
        var attributes = { id: 'holiday', name: 'holiday' };
        swfobject.embedSWF('swfs/Main.swf', 'flashContent', '100%', '100%', '9.0.45', 'swfs/expressinstall.swf', vars, params, attributes);
    </script>
</head>
<body>
	<div id="flashWrapper">
		<div id="flashContent">
			<div id="header">
				<img id="logo" src="images/logo.gif" height="12" width="77" alt="blenderbox" />
				<img id="sweeten" src="images/sweeten.gif" height="37" width="306" alt="Sweeten Someone's Holiday" />
			</div>
			<div id="headerDS"></div>
			<div id="noFlashContentWrapper">
				<div id="noFlashContent">
					<img src="images/noflash/before.gif" width="397" height="76" alt="Before we get started" /><br/>
					<p>In order to view this page correctly you need Flash Player 9+ support, as well as javascript turned on. </p>
					<p>Download the player for free by clicking on the image below.</p>
					 <p>
              <a href="http://www.adobe.com/go/getflashplayer" target="_blank"><img src="http://www.adobe.com/images/shared/download_buttons/get_flash_player.gif" alt="Get Adobe Flash player" /></a>
          </p>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
<?php } ?>