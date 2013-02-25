User stories:

* on startup, local disk is searched for images.
* when images are found in "Pictures" directories, and the image has EXIF headers and is large enough, import.

## Backend

* simplest thing that could possibly work:
  * if the sha matches, make sure the original file still exists,
    then move the new file into the trash

* on startup, process all the root directories

* importing files:
  * close dupes (orig image - new image delta is small, or after rotations)
    get moved into root/Modified/YYYY/mm/dd/hhmmss_#{orig_name}
  * auto-rotate (if setting is set)

* cron job for processing? rufus-scheduler?
* remove auto-built tags when we re-process an image, to make tagging idempotent
* FAM integration with guard

## Frontend

* hook up TwBS: http://appscrolls.org/
* use https://github.com/bartaz/impress.js (3-d presentations?)
* http://warpspire.com/experiments/history-api/ to infinity!
* decompose page ajax requests
* http://boedesign.com/demos/gritter/ for growl notification of async stuff
* add https://github.com/rails/jquery-ujs ?
* UI to edit the settings table

## Installation
* http://pow.cx/
* rails vm? auto upgrades?

## Features

* do asset tombstoning, not deleting (in the case of moving photos to different directories)?
* add auth (devise? diy?)
* asset rating
* GPS location interpolation (if you have gps from recent photo stream, let the dSLR adopt that location)
* event grouping
  (look for temporal gaps in images that are statistically relevant or geotagged in different places)
* piling (similar images taken within seconds of each other, only show largest one, let user choose the "best")
* similar images to current
* find images that are similar to your starred images
* try to auto-panorama if photos are taken within 10 seconds of each other
* try to auto-hdr if jpeg blows out
* transcode/upload to flickr/vimeo?
* download from flickr
* large image uploaded to S3 for backup?
* OpenCV face detection: http://www.cognotics.com/opencv/servo_2007_series/part_5/index.html
* Bootstrap the training of OpenCV by using picasa/iPhoto face tags
* "good" photo prediction:
libsvm/SVR, random forests, lin regression of very simple features(time of day, season, colors?)
  https://github.com/febeling/rb-libsvm
  https://github.com/tomz/libsvm-ruby-swig
  http://creativemachines.cornell.edu/eureqa
* lossless rotation from UI
* ditch rails?
  http://www.padrinorb.com/
  https://github.com/bbwharris/examples/tree/master/sinatra/test/
  http://carlosgabaldon.com/articles/singing-with-sinatra/


https://github.com/rsms/cocui

## Done

* no dupe settings
* clean EXIF make/model
* sidekiq for background processing
* small, medium, large images are created
* Use Procfile/foreman to manage multiple processes on start?
* use STI for tags, so we can have DateTag, FileTag, UrlTag, ...?
* Support gm or imagemagick http://www.graphicsmagick.org/FAQ.html
* write file_iterator
* what iterates directories (findler)
* only import files with EXIF headers (exiftoolr)
* extract out Picasa EXIF face tags (research EXIF-RDF)
* geotag labeling extraction
