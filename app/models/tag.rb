class Tag < ActiveRecord::Base
  acts_as_tree
  has_many :asset_tags
  has_many :assets, :through => :asset_tags

  def deactivate_assets
    Asset.update_all({:active => false}, {:tag_id => self_and_children.collect { |ea| ea.id }})
  end

  def to_s
    name
  end

  def path
    ancestry_path :to_s
  end

  def self.named_root(root = self)
    root.find_or_create_by_path([I18n.t("tags.#{self.root_name}.name")],
      :description => I18n.t("tags.#{self.root_name}.description", :default => nil))
  end
end
