web:    bundle exec thin start -p $PORT
redis:  redis-server
memcache:  memcached -v
worker: bundle exec sidekiq --queue 1,default --queue 8,user # <- concurrency is a Setting
