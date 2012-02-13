class DateTag < Tag

  def self.root_name
    "when"
  end

  def self.for_date(d)
   named_root.find_or_create_by_path([d.year.to_s, d.month.to_s, d.day.to_s])
  end

  def self.process(asset)
    date = asset.captured_at.to_date
    asset.add_tag(for_date(date))
  end

end
