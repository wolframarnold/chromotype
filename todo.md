== Backend

* cron job for processing? rufus-scheduler?
* FAM integration with guard
* verify hire-fire (and integrate with guard daemon?)
* get background processing working (assume there's a restart event thanks to monit/unicorn/passenger?)
* OpenCV face detection: http://www.cognotics.com/opencv/servo_2007_series/part_5/index.html
* extract out Picasa EXIF face tags
* https://github.com/maccman/juggernaut, and use resque instead?

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

* decompose page ajax requests
* http://boedesign.com/demos/gritter/ for growl notification of async stuff
* add https://github.com/rails/jquery-ujs ?

== Features

* move files into root/YYYY/yyyy-mm-dd/ automatically

* do asset tombstoning, not deleting (in the case of moving photos to different directories)?
* add auth (devise?)
* asset rating
* geotag labelling extraction
* event grouping
  (look for temporal gaps in images that are statistically relevant or geotagged in different places)
* piling (similar images taken within seconds of eachother, only show last one, let user choose the "best")
* similar images
* find images like your starred images
* transcode/upload to flickr/vimeo?

== Done

* Use Procfile/foreman to manage multiple processes on start?
* use STI for tags, so we can have DateTag, FileTag, UrlTag, ...?
