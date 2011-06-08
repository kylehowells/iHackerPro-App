<?php
$date      = getdate();
$uploaddir = sprintf('uploads/%d/%02d/%02d/', $date['year'], $date['mon'], $date['mday']);

$file      = preg_replace('~[^\w-\.\,]+~', '-', basename($_FILES['userfile']['name']));
$extension = strtolower(pathinfo($file, PATHINFO_EXTENSION));

// is_uploaded_file() checks if the file has been uploaded through HTTP, and not if it was successfully uploaded/moved.
if (!is_uploaded_file($_FILES['userfile']['tmp_name']))
        exit('Invalid file');

// Check file size
if ($_FILES['userfile']['size'] > 1000000)
        exit("Your file is too large.");

// Check file extension
if (!in_array($extension, array('jpg', 'jpeg', 'png', 'gif')))
        exit('Invalid file type');

// Check image headers
if (!$info = @getimagesize($_FILES['userfile']['tmp_name']))
        exit('Cannot open temp file');

if (!in_array($info[2], array(
        IMAGETYPE_JPEG,
        IMAGETYPE_PNG,
        IMAGETYPE_GIF
), true))
        exit('Invalid image');

// Check upload dir
if (!is_dir($uploaddir) AND !@mkdir($uploaddir, 0755, true))
        exit('Cannot create upload directory');

// Generate unique name.
do
{
        $newName = sprintf('%s%d%s', $uploaddir, time(), $file);
}
while (is_file($newName));

// Move it...
if (@move_uploaded_file($_FILES['userfile']['tmp_name'], $newName))
{
        $postsize = ini_get('post_max_size');   //Not necessary, I was using these
        $canupload = ini_get('file_uploads');   //server variables to see what was 
        $tempdir = ini_get('upload_tmp_dir');   //going wrong.
        $maxsize = ini_get('upload_max_filesize');
        
        echo "\n[img]http://hacker-pro.com/upload/img/{$newName}[/img]";
}
else
        echo 'Error uploading the file';

?>