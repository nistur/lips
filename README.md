# LIPS
Lego Instructions Processing Scripts

Some dirty Bash scripts hacked together to convert renders created by [Stud.io](http://stud.io) into something a little easier to follow.

This was written on macOS and uses imagemagick, installed via homebrew. It will probably work on Linux but of course Stud.io doesn't run on Linux (yet?) so getting the renders is a bit more problematic. I may continue working on this, I may rewrite bits of it in something more crossplatform to work on Windows. I may do nothing. Who knows.

Expects a [config.lips](config.lips) file in the directory with some settings to customise the project. Folder structure is as follows:

```
PROJECT/
    config.lips
    Raw/
        Step-01.png
	Step-02.png
	Step-03.png
	...
    Cover/
        BeautyShot.png
    Overlay/
        Step-03.png
    Parts/
        BrickLinkExport.xml
```

## USAGE
To use it, put the scripts somewhere you can run it (I have them in ${HOME}/lips with a symlink from ${HOME}/bin/lips to ${HOME}/lips/lips) and then just run lips from within the directory with `config.lips`


## Features
* Adds step numbers to images
* Adds background to renders which don't have backgrounds
* Combines 4 steps to page
* Creates cover page with title, fake logo, beauty shot etc

## TODO
* Create info page(s) prior to instructions
* Add submodels to steps
* Add final beauty shot after instructions

## Not sure if possible
* Display needed parts per step
* Display total parts list
