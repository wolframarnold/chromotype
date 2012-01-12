class SeasonTag < Tag
  def self.for_date(t)
    firnd_or_create_by_path I18n.t("tags.events.children.seasons.children.#{t.season.to_s}.name")
  end

end