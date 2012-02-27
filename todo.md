## What constitutes a duplicate file?

### Certainly

* A file with the same sha2

### Probably:

* A file with the same "durable exif headers" and same numeric filename
(EXIF headers that get persisted by Photoshop, iPhoto, Preview, ...)

### Probably not

* Same durable exif headers, different numeric filename (to detect intra-second exposures)

* what iterates directories (dir_tag? )

* small, medium, large images are created (and large image uploaded to S3 for backup?)

== Backend

* only import files with EXIF headers

* cron job for processing? rufus-scheduler?
* FAM integration with guard
* verify hire-fire (and integrate with guard daemon?)
* get background processing working (assume there's a restart event thanks to monit/unicorn/passenger?)
* OpenCV face detection: http://www.cognotics.com/opencv/servo_2007_series/part_5/index.html
* extract out Picasa EXIF face tags (research EXIF-RDF)
* https://github.com/maccman/juggernaut, and use resque instead?

* write a flikr_iterator

== URI structure

/setup (what roots to search, privacy settings)
/search?q=something
/asset/123/like
/label/(id or name?)

from PS:
/cmd/**
/status/**
/stream/**
/login
/search

== Frontend

* http://warpspire.com/experiments/history-api/ to infinity!
* decompose page ajax requests
* http://boedesign.com/demos/gritter/ for growl notification of async stuff
* add https://github.com/rails/jquery-ujs ?

== Features

* move files into root/YYYY/yyyy-mm-dd/ automatically

* do asset tombstoning, not deleting (in the case of moving photos to different directories)?
* add auth (devise? diy? )
* asset rating
* geotag labelling extraction
* event grouping
  (look for temporal gaps in images that are statistically relevant or geotagged in different places)
* piling (similar images taken within seconds of eachother, only show last one, let user choose the "best")
* similar images
* find images like your starred images
* transcode/upload to flickr/vimeo?

* "good" photo prediction:
libsvm/SVR, random forests, lin regression of very simple features(time of day, season, colors?)
  https://github.com/febeling/rb-libsvm
  https://github.com/tomz/libsvm-ruby-swig
  http://creativemachines.cornell.edu/eureqa

* ditch rails?
  https://github.com/bbwharris/examples/tree/master/sinatra/test/
  http://carlosgabaldon.com/articles/singing-with-sinatra/

== Done

* Use Procfile/foreman to manage multiple processes on start?
* use STI for tags, so we can have DateTag, FileTag, UrlTag, ...?
* Support gm or imagemagick http://www.graphicsmagick.org/FAQ.html
* write file_iterator
