class Tag < ActiveRecord::Base
  acts_as_tree

  has_and_belongs_to_many :assets

  def to_s
    display_name or name
  end

  def path
    ancestry_path :to_s
  end

  class << self
    def date_root
      find_or_create_by_path I18n.t("tags.date.name")
    end

    def events_root
      find_or_create_by_path I18n.t("tags.events.name")
    end

    def seasons_root
      events_root.find_or_create_by_path I18n.t("tags.events.children.seasons.name")
    end

    # Returns an array of tags associated to that date.
    def for_date t
      t = t.to_date
      d = date_root.find_or_create_by_path t.year, t.month, t.day
      d.parent.update_attribute(:display_name, t.month_name) unless d.parent.display_name

      s = seasons_root.find_or_create_by_path I18n.t("tags.events.children.seasons.children.#{t.season.to_s}.name")
      [d, s]
    end

    def url_root
      find_or_create_by_path(I18n.t "tags.url.name")
    end

    def for_url url
      for_file url if (url.is_a? File or url.starts_with? "/")
      u = URI.parse url
      url_root.find_or_create_by_path u.host
    end

    def file_root
      find_or_create_by_path(I18n.t "tags.file.name")
    end

    def for_file file, use_parent = true
      p = Pathname.new(file)
      p = p.parent if use_parent
      file_root.find_or_create_by_path p.realpath.each_filename.to_a
    end

    def localized_initial_tags
      YAML.load(Rails.root.join("config/locales/#{I18n.locale.to_s}.yml").read)[I18n.locale.to_s]["tags"]
    end

    def create_roots! root_tags = localized_initial_tags
      root_tags.collect { |k,v| new_tag v}
    end

    private
    def new_tag data, parent = nil
      tag = (parent ? parent.children : Tag).create!(:name => data["name"], :description => data["description"])
      data["children"].each { |k,v| new_tag v, tag } if data["children"]
      tag
    end

  end

end
