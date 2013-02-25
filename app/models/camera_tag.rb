class CameraTag < Tag

  def self.root_name
    "with"
  end

  def self.visit_asset(exif_asset)
    # todo: short-circuit if we already have camera tags
    exif = exif_asset.exif
    return if exif.nil?
    make = clean_make(exif[:make])
    model = clean_model(make, exif[:model])
    path = [make, model].compact # Not all photos have either
    return if path.empty?
    exif_asset.add_tag(named_root.find_or_create_by_path(path), self)
  end

  # "AMAZEBALLS Optical Co.Ltd." or "Amazeballs corp." should just be "Amazeballs".
  IGNORABLE_MAKE_PATTERNS = [
    /\s+(ag|camera|co|company|computer|corp|corporation|digital|elec|electric|electronics|fototechnic|gmbh|group|imaging|inc|international|ltd|optical|photo|technologies|technology)\z/i,
  ]

  def self.clean_make(make)
    return nil if make.nil?
    make = make.gsub(/[\.,]+/, ' ')
    make = normalize(make, IGNORABLE_MAKE_PATTERNS)
    make = make.downcase.titleize if make =~ /\A[A-Z ]{4,}\z/ # Don't titleize LG or NEC
    make
  end

  IGNORABLE_MODEL_PATTERNS = [
    # Some camera models (like Motorola's Droid X) end in a hex serial number. We don't need that:
    /[0-9a-f]{32,}\z/i,
    # Some camera models have a version number (!!):
    /\(v\d+.\d+\)\w?\z/i,
    # Some digital cameras are less sure of themselves, and need to reassert there digital camera-ness:
    /digital camera\z/i]

  def self.clean_model(clean_make, model)
    return nil if model.nil?
    model = normalize(model, IGNORABLE_MODEL_PATTERNS)
    if model.downcase.start_with? "#{clean_make} ".downcase
      model = model[(clean_make.size + 1)..-1]
    end
    if clean_make =~ /\Ahewlett.packard\z/i && model =~ /\Ahp /i
      model = model[3..-1]
    end
    model
  end

  def self.normalize(make, ignorable_patterns)
    make = make.strip.gsub(/[\s_]+/, ' ')
    # Strip off the Ltd., Co., …
    make_before = nil
    begin
      make_before = make
      ignorable_patterns.each do |re|
        if match_data = re.match(make)
          make = make[0, match_data.begin(0)].strip
        end
      end
    end while make_before != make
    make
  end
end
