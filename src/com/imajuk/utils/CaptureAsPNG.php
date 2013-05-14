<?php 

$dir = $_POST["dir"];
$result = TRUE;

echo $_FILES;

foreach ($_FILES as $file)
{
	$fname = $file['name'];
echo $dir.$fname;
	$res = move_uploaded_file ($file['tmp_name'], $dir.$fname);
	$result = $result && $res;

	if (!$result) break;
}

if($result)
{
	echo("SUCCESS");
}
else
{
	echo("FAILED");
}


?>