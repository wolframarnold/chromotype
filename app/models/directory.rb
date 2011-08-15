class Directory < ActiveRecord::Base
  acts_as_tree #BOOM.

  def self.process_mtime_deltas
    roots.each{|d| d.delay(:priority => d.priority).process if d.process?}
  end

  def exists?
    Dir.exists? path
  end

  def process?
    exists? and File.mtime(path) != last_mtime
  end

  def priority
    # The first 100 priorities are used for user-time background jobs.
    100 + Time.now.to_i - File.mtime(file_name).to_i
  end

end
