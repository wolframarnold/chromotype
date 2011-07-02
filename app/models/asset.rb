class Asset < ActiveRecord::Base
  has_and_belongs_to_many :tags

  scope :with_tag, lambda { |tag| includes(:tags).where("tags.id" => tag.id) }

  scope :with_tag_or_descendants, lambda { |tag| includes(:tags => [:ancestors]).where("ancestors_tags.id = ? or tags.id = ?", tag.id, tag.id) }

  def self.inherited(subclass)
    puts "#{self} just got subclassed by #{subclass}."
  end

  class << self
    def import_file file
      file = file.is_a?( File) ? file : File.new file
      
      return nil
    end
  end
end
