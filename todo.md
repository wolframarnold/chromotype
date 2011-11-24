== Backend

* set up rspec, (and webrat?)
* FAM integration with guard
* verify hire-fire (and integrate with guard daemon?)
* get background processing working (assume there's a restart event thanks to monit/unicorn/passenger?)

== Frontend

* use photostructure urls
* decompose page ajax requests
* http://boedesign.com/demos/gritter/ for growl notification of async stuff
* add https://github.com/rails/jquery-ujs ?

== Deployment

* heroku?

== Features

* do asset tombstoning, not deleting (in the case of moving photos to different directories)?

* add auth (devise?)
* asset rating
* geotag labelling extraction
* event grouping
  (look for temporal gaps in images that are statistically relevant or geotagged in different places)
* piling (similar images taken within seconds of eachother, only show last one, let user choose the "best")
* move files into root/YYYY/yyyy-mm-dd/ automatically
* similar images
* find images like your starred images
* transcode/upload to flickr/vimeo?
