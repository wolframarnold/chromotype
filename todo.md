== Backend

* small, medium, large images are created
* move files into root/YYYY/yyyy-mm-dd/ automatically
  * what to do with dupes? shove into dupe dir?
* cron job for processing? rufus-scheduler?
* FAM integration with guard
* verify hire-fire (and integrate with guard daemon?)
* get background processing working (assume there's a restart event thanks to monit/unicorn/passenger?)
* https://github.com/maccman/juggernaut, and use resque instead?
* write a flikr_iterator
* large image uploaded to S3 for backup?

== Frontend

* http://warpspire.com/experiments/history-api/ to infinity!
* decompose page ajax requests
* http://boedesign.com/demos/gritter/ for growl notification of async stuff
* add https://github.com/rails/jquery-ujs ?

== Features

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

* OpenCV face detection: http://www.cognotics.com/opencv/servo_2007_series/part_5/index.html
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
* what iterates directories (asset_processor)
* only import files with EXIF headers
* extract out Picasa EXIF face tags (research EXIF-RDF)
