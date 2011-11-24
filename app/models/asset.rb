class Asset < ActiveRecord::Base
  has_and_belongs_to_many :tags

  belongs_to :directory

  scope :with_tag, lambda { |tag| includes(:tags).where("tags.id" => tag.id) }

  scope :with_tag_or_descendants, lambda { |tag| includes(:tags => [:ancestors]).where("ancestors_tags.id = ? or tags.id = ?", tag.id, tag.id) }

  def self.inherited(subclass)
    (@@subclasses ||= []) << subclass
  end

  def self.import_file file
    file = file.is_a?(File) ? file : File.new(file)
    # FINISH @@subclasses.affinity_for_file
    return nil
  end
end
