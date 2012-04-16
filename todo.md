## Backend

* move files into root/YYYY/yyyy-mm-dd/ automatically
  * what to do with dupes? shove into dupe dir?
* cron job for processing? rufus-scheduler?
* remove auto-built tags when we re-process an image, to make tagging idempotent
* FAM integration with guard
* verify hire-fire (and integrate with guard daemon?)
* get background processing working (assume there's a restart event thanks to monit/unicorn/passenger?)
* https://github.com/maccman/juggernaut, and use resque instead?

## Frontend

* http://warpspire.com/experiments/history-api/ to infinity!
* decompose page ajax requests
* http://boedesign.com/demos/gritter/ for growl notification of async stuff
* add https://github.com/rails/jquery-ujs ?

## Features

* do asset tombstoning, not deleting (in the case of moving photos to different directories)?
* add auth (devise? diy?)
* asset rating
* GPS location interpolation (if you have gps from recent photo stream, let the dSLR adopt that location)
* event grouping
  (look for temporal gaps in images that are statistically relevant or geotagged in different places)
* piling (similar images taken within seconds of eachother, only show largest one, let user choose the "best")
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

## Done

* small, medium, large images are created
* Use Procfile/foreman to manage multiple processes on start?
* use STI for tags, so we can have DateTag, FileTag, UrlTag, ...?
* Support gm or imagemagick http://www.graphicsmagick.org/FAQ.html
* write file_iterator
* what iterates directories (findler)
* only import files with EXIF headers (exiftoolr)
* extract out Picasa EXIF face tags (research EXIF-RDF)
* geotag labeling extraction
