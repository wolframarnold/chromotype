class Tag < ActiveRecord::Base
  acts_as_tree
  has_many :asset_tags
  has_many :assets, :through => :asset_tags

  def deactivate_assets
    Asset.update_all({:active => false}, {:tag_id => self_and_children.collect { |ea| ea.id }})
  end

  def to_s
    display_name or name
  end

  def path
    ancestry_path :to_s
  end

  class << self

    def process_roots
      roots.each { |d| d.delay(:priority => d.priority).process if d.process? }
    end

    #def root
    #  roots.find_or_create_by_name(
    #    :name => I18n.t("tags.#{self.name}.name"),
    #      :description => I18n.t("tags.#{type}.description", :default => nil))
    #end
    #
    # TODO: move to subclass:
    #def events_root
    #  root("events")
    #end
    #
    #def seasons_root
    #  root("events.children.seasons")
    #end

    #def localized_initial_tags
    #  YAML.load(Rails.root.join("config/locales/#{I18n.locale.to_s}.yml").read)[I18n.locale.to_s]["tags"]
    #end
    #
    #def create_roots! (root_tags = localized_initial_tags)
    #  root_tags.collect { |k, v| new_tag v }
    #end

    #private
    #def new_tag (data, parent = nil)
    #  tag = (parent ? parent.children : Tag).create!(:name => data["name"], :description => data["description"])
    #  data["children"].each { |k, v| new_tag v, tag } if data["children"]
    #  tag
    #end
  end
end
