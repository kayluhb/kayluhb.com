<?php

define('BASE',getcwd().'/');
include_once (BASE.'config/config.php');
$showPage = false;
$dir =  $url[0];

switch($dir) {
	case 'save':
		save_cookie();
		break;
	case 'send':
		email_cookie();
		break;
	case 'purchase':
		purchase_cookie();
		break;
	case 'paypal':
		print '
		
		<form action="https://www.paypal.com/cgi-bin/webscr" method="post" name="order">
		<input type="hidden" name="cmd" value="_s-xclick">
		<input type="hidden" name="hosted_button_id" value="1955499">
		<input type="hidden" name="on0" value="item_number">
		<input type="hidden" name="os0" value="'. $_GET["id"] . '">
		<input type="image" src="https://www.paypal.com/en_US/i/btn/btn_buynowCC_LG.gif" border="0" name="submit" alt="">
		<img alt="" border="0" src="https://www.paypal.com/en_US/i/scr/pixel.gif" width="1" height="1">
		</form>
		<script type="text/javascript" language="JavaScript">
		 //submit form
		  document.order.submit();
	</script>';
	default:
		$showPage = true;
}
if ($showPage) {
?><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="content-Type" content="text/html;charset=utf-8" />
	<title>Happy Holidays from Blenderbox</title>
    <meta id="description" name="description" content="Blenderbox Holiday Card.  Create a virtual gingerbread man." />
    <meta name="keyWords" content="holiday, gingerbread man, blenderbox, new york, new york city, design, holiday card" />
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
		var pageTracker = _gat._getTracker("UA-592025-18");
		pageTracker._trackPageview();
		} catch(err) {}</script>
    <script type="text/javascript" src="javascripts/swfobject/swfaddress.js?tracker=pageTracker._trackPageview"></script>
    <script type="text/javascript">
        var vars = {xmlFile: 'xml/Main.xml'};
        var params = { bgcolor: '#ffffff' };
        var attributes = { id: 'holiday', name: 'holiday' };
        swfobject.embedSWF('swfs/Main.swf', 'flashContent', '100%', '100%', '9.0.45', '/swfs/expressinstall.swf', vars, params, attributes);
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