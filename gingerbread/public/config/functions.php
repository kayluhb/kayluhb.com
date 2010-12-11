<?php
function lookup_cookie($uniqueurl){
	$sql = "SELECT * FROM cookies WHERE url = '" . $uniqueurl . "' || admin_url = '" . $uniqueurl . "'";	
	$r = mysql_fetch_object(mysql_query($sql));	
	return $r;	
}

function purchase_cookie(){
	/*$_POST["yourName"] = 'asdf';
	$_POST["yourEmail"] = 'asdf';
	$_POST["recipientName"] = 'asdf';
	$_POST["recipientEmail"] = 'asdf';
	$_POST["address"] = 'asdf';
	$_POST["city"] = 'asdf';
	$_POST["state"] = 'asdf';
	$_POST["zip"] = 11211;
	$_POST["message"] = 'asdf';*/
	
	$sql = "INSERT INTO orders (
			yourName,
			yourEmail,
			recipientName, 
			recipientEmail, 
			address, 
			city, 
			state, 
			zip, 
			message,
			cookie_id
		) VALUES (
			'".$_POST["yourName"]."',
			'".$_POST["yourEmail"]."',
			'".$_POST["recipientName"]."',
			'".$_POST["recipientEmail"]."',
			'".$_POST["address"]."',
			'".$_POST["city"]."',
			'".$_POST["state"]."',
			".$_POST["zip"].",
			'".$_POST["message"]."',
			".$_POST["id"]."
		)";	
	mysql_query($sql);
	$id = mysql_insert_id();
	setcookie("gingerBread",$id,time()+3600);	
	die("id=".$id);
	
}

function save_cookie(){		
	if ($GLOBALS[ 'HTTP_RAW_POST_DATA' ] == "")
		header("LOCATION: /");
	$file = date("ymdhms");
	$fp = fopen( BASE.'/gingerbreadmen/'.$file.'.png', 'wb' );
  	fwrite( $fp, $GLOBALS[ 'HTTP_RAW_POST_DATA' ] );
  	fclose( $fp );  	  	
  	
  	$admin = $file."admin";  	
  	$sql = "INSERT INTO cookies (url,admin_url,file) VALUES ('".md5($file)."','".md5($admin)."','".$file."')";
  	mysql_query($sql);
  	die("id=".mysql_insert_id());
  	
}

function email_cookie(){
/*	$_POST["yourName"] = 'mike';
	$_POST["yourEmail"] = 'mcalhoun@blenderbox.com';
	$_POST["recipientName"] = 'mdc';
	$_POST["recipientEmail"] = mikedcalhoun@gmail.com';
	$_POST["address"] = 'asdf';
	$_POST["city"] = 'asdf';
	$_POST["state"] = 'asdf';
	$_POST["zip"] = 11211;
	$_POST["message"] = 'asdf';
	$_POST["id"] = 144;*/
	
	$sql = "SELECT * FROM cookies WHERE id = " . $_POST["id"];	
	
	$cookie = mysql_fetch_object(mysql_query($sql));	
	$to = $_POST["recipientEmail"];		
	$subject = $_POST['yourName'] . " has sent you a cookie";
	
	$sql = "INSERT INTO forwards (cookie_id,sender,recipient) VALUES (".$_POST['id'].",'".$_POST['yourEmail']."','".$_POST['recipientEmail']."')";	
	mysql_query($sql);
	
	$handle = fopen( BASE.'/emails/send.html', 'r+' );
	$contents = fread($handle,filesize(BASE.'/emails/send.html'));

	//$_POST['message'] = str_replace("\r\n","<br />",$_POST['message']);
	//$_POST['message'] = str_replace("\n","<br />",$_POST['message']);		
	//$_POST['message'] = str_replace("\r","<br />",$_POST['message']);		
	$_POST['message'] = nl2br($_POST['message']);
	$_POST['message'] = str_replace("undefined","",$_POST['message']);
	$_POST['message'] = stripslashes($_POST['message']);
	$message = str_replace("!!MESSAGE!!",$_POST['message'],$contents);
	$message = str_replace("!!FROM!!",$_POST['yourName'],$message);
	$message = str_replace("!!RECIP!!",$_POST['recipientName'],$message);
	$message = str_replace("!!COOKIE!!",'http://gingerbread.blenderbox.com/gingerbreadmen/'.$cookie->file.'.png',$message);

	$headers  = 'From: ' . $_POST['yourEmail'] . ";\r\n";
	$headers .= 'MIME-Version: 1.0' . "\r\n";
	$headers .= 'Content-type: text/html; charset=iso-8859-1' . "\r\n";		
	die("success=".mail($to, $subject, $message,$headers));  	
}

function send_cookie_confirm($id){

	$sql = "SELECT * FROM orders WHERE id = " . $id;		
	$cookie = mysql_fetch_object(mysql_query($sql));	
	$sql = "SELECT * FROM cookies WHERE id = ". $cookie->cookie_id;
	$man = mysql_fetch_object(mysql_query($sql));	
	$to = $cookie->recipientEmail;		
	$cc = $cookie->yourEmail;
	$subject = $cookie->yourName . " has sent you a cookie";
	$handle = fopen( '../emails/purchase.html', 'r+' );
	$contents = fread($handle,filesize('../emails/purchase.html'));

	//$cookie->message = str_replace("\r\n","<br />",$cookie->message);
	//$cookie->message = str_replace("\n","<br />",$cookie->message);	

	$cookie->message = nl2br($cookie->message);
	$cookie->message = str_replace("undefined","",$cookie->message);
	$cookie->message = stripslashes($cookie->message);

	$message = str_replace("!!MESSAGE!!",$cookie->message,$contents);
	$message = str_replace("!!FROM!!",$cookie->yourName,$message);
	$message = str_replace("!!RECIP!!",$cookie->recipientName,$message);
	$message = str_replace("!!COOKIE!!",'http://gingerbread.blenderbox.com/gingerbreadmen/'.$man->file.'.png',$message);	
	$headers  = 'From: ' . $cookie->yourEmail . ";\r\n";
	$headers .= 'CC: ' . $cookie->yourEmail . "\r\n";
	//$headers .= 'CC:mikedcalhoun@gmail.com\r\n';
	$headers .= 'MIME-Version: 1.0' . "\r\n";
	$headers .= 'Content-type: text/html; charset=iso-8859-1' . "\r\n";		
	$headers .= 'CC: ' . $cookie->yourEmail . "\r\n";
	mail($to, $subject, $message,$headers);
}

function send_nocookie_confirm($conf){			
	$to = "technlogy@blenderbox.com";		
	$subject = "Cookie purchase without cookies enable";		
	$message = "A cookie with confirmation number " . $conf ." was purcahsed at ". date('d/m/y : H:i:s', time()) . ".  This orderer did not have cookies enabled.";
	$headers  = 'From: gingerbreadmen@blenderbox.com;\r\n';	
	die("success=".mail($to, $subject, $message,$headers));  	
}


function dump($r){
	print_r($r);
	die();
}
?>