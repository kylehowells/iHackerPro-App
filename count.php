<?php
/*$directory = "/i";
if (glob("$directory*jpg") != false)
{
 $filecount = count(glob("$directory*jpg"));
 echo $filecount;
}
else
{
 echo 0;
}*/

function count_files($path) {
 
    // (Ensure that the path contains an ending slash)
 
    $file_count = 0;
 
    $dir_handle = opendir($path);
 
    if (!$dir_handle) return -1;
 
    while ($file = readdir($dir_handle)) {
 
        if ($file == '.' || $file == '..') continue;
 
        if (is_dir($path . $file)){      
            $file_count += count_files($path . $file . DIRECTORY_SEPARATOR);
        }
        else {
            $file_count++; // increase file count
        }
    }
 
    closedir($dir_handle);
 
    return $file_count;
}

echo count_files('./uploads/2011/01/');

?>