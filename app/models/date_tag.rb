class DateTag < Tag
  def self.for_date(t)
    d = t.to_date
    YearTag.
      find_or_create_by_path([d.year]).
      find_or_create_by_path([d.month], :type => MonthTag.to_s).
      find_or_create_by_path([d.day], :type => DayTag.to_s)
  end
end

class YearTag < DateTag
  def to_s
    name
  end
end

class MonthTag
  def to_s
    # TODO: i18n
    name
  end
end

class DayTag
  def to_s
    # TODO: i18n
    name
  end
end
