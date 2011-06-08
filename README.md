# iHackerPro App #
----------------------------
##Overview##

iHackerPro is the name of my forum for jailbroken iOS devices. I planned from he start to give the site an app, however I had only just started learning ObjC at that point so a [ModMyi style completely native app](http://itunes.apple.com/us/app/modmyi/id381962819?mt=8 "ModMyi App in AppStore") was unattainable. So an [iHackMyi](http://ihackmyi.com "iHackMyi Forums") style UIWebView based app it was (I also developed the currently available version of their app).
Anyway I __LOVE__ Opensource stuff, I learn fastest and most easily by studying well formatted easily understandable code.
Now I can't promise this code is well: documented, formatted; or easily understandable throughout but I try to code neatly (honest ;).

---------------------------

## Features ##

#### Basic Features ####

*  Fadeout loading screen.
*  Basic UIWebView and UIToolBar as the default view.
*  Multiple UIViewControllers.
*  Example of how to use NSUserDefaults for settings.
*  Icon badges if the user has under messages (site specific).


#### More Advanced Features ####

*  Overrides the standard contextual menu.
*  The custom menu mimics the Safari one rather then the UIWebView one, provides support for saving images.
*  Uses CoreGraphics and custom drawing for some of the UI.
*  Implements a custom image uploader which converts the images to JPG format (for space saving on server), the upload.php file is included (as is a script for counting how many uploads are made each month).
*  Image uploader saves thumbnails of the images to the documents directory for the upload history.
*  Implements a Photos app/UIImagePickerController clone interface for uploads history.
*  Upload progress is shown by means of a UIProgressBar above the status bar.



---------------------------

## Screenshots ##

![Main Menu](http://modmyi.com/mmi/upload/4d8f81c590817.png "Main Menu")
![Image Uploader](http://modmyi.com/mmi/upload/4d8f81c5913d0.png "Image Uploader")