class Date
  N_HEMISPHERE = {
    12 => :winter, 1 => :winter, 2 => :winter, 3 => :spring, 4 => :spring, 5 => :spring,
    6 => :summer, 7 => :summer, 8 => :summer, 9 => :autumn, 10 => :autumn, 11 => :autumn}

  S_HEMISPHERE = {
    6 => :winter, 7 => :winter, 8 => :winter, 9 => :spring, 10 => :spring, 11 => :spring,
    12 => :summer, 1 => :summer, 2 => :summer, 3 => :autumn, 4 => :autumn, 5 => :autumn}

  # Returns :winter, :spring, :summer, or :autumn, using UK-based month-bound seasons.
  # See http://en.wikipedia.org/wiki/Winter
  def season
    (Settings[:is_northern_hemisphere] ? N_HEMISPHERE : S_HEMISPHERE)[self.month]
  end

  def month_name
    I18n.t("date.month_names")[self.month]
  end
end
