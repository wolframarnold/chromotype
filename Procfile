web:    bundle exec thin start -p $PORT
redis:  redis-server
worker: bundle exec sidekiq --queue 1,default --queue 8,user -c ${CONCURRENCY:-2} # default to 2
