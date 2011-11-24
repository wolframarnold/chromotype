class Directory < ActiveRecord::Base
  acts_as_tree :name_column => :basename, :dependent => :destroy
  has_many :assets

  def self.find_or_create_from_file(file)
    # TODO find_or_create_by_path
  end

  def self.process_mtime_deltas
    roots.each{|d| d.delay(:priority => d.priority).process if d.process?}
  end

  def path
    # TODO: FINISH
    # self_and_ancestors.reverse
  end

  def exists?
    Dir.exists? path
  end

  def process?
    !exists? or File.mtime(path) != last_mtime
  end

  def process process_all_assets = false
    # Clone the assets that we know about before processing
    if !exists?
      parent.children.remove
    end
    # TODO: FINISH
  end

  def priority
    # The first 100 priorities are used for user-time background jobs.
    100 + Time.now.to_i - File.mtime(file_name).to_i
  end

end
