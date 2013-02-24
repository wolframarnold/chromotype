require 'minitest_helper'

describe CameraTag do

  # wget --no-parent --recursive --level=1 http://owl.phy.queensu.ca/~phil/exiftool/sample_images.html
  # mkdir samples ; cd samples ; tar xvzf ../owl.phy.queensu.ca/~phil/exiftool/*.tar.gz
  # exiftool -j `find . -type f` 2> /dev/null | grep ''Make':' | cut -d: -f2 | sort -u

  it 'cleans EXIF makers' do
    expected = {
      'Apple' => 'Apple',
      'Asahi Optical Co.,Ltd' => 'Asahi',
      'Canon ' => 'Canon',
      'Canon Inc.' => 'Canon',
      'Canon' => 'Canon',
      'CASIO COMPUTER CO.,LTD' => 'Casio',
      'CASIO COMPUTER CO.,LTD.' => 'Casio',
      'CASIO' => 'Casio',
      'EASTMAN KODAK COMPANY' => 'Eastman Kodak',
      'Eastman Kodak Company' => 'Eastman Kodak',
      'FUJI PHOTO FILM CO., LTD.' => 'Fuji Photo Film',
      'FUJIFILM' => 'Fujifilm',
      'Hewlett-Packard Co.' => 'Hewlett-Packard',
      'Hewlett-Packard Company' => 'Hewlett-Packard',
      'Hewlett-Packard' => 'Hewlett-Packard',
      'HTC' => 'HTC',
      'KONICA CORPORATION' => 'Konica',
      'KONICA MINOLTA CAMERA, Inc.' => 'Konica Minolta',
      'Konica Minolta Photo Imaging, Inc.' => 'Konica Minolta',
      'KYOCERA' => 'Kyocera',
      'LEICA CAMERA AG' => 'Leica',
      'LEICA' => 'Leica',
      'LG ELEC' => 'LG',
      'LG Elec.' => 'LG',
      'LG Electronics Inc' => 'LG',
      'LG Electronics Inc.' => 'LG',
      'LG ELECTRONICS' => 'LG',
      'LG Electronics' => 'LG',
      'LG electronics' => 'LG',
      'LG Electronics, Inc.' => 'LG',
      'LG_Electronics' => 'LG',
      'Medion   OPTICAL CO,LTD' => 'Medion',
      'Minolta Co., Ltd.' => 'Minolta',
      'MINOLTA CO.,LTD' => 'Minolta',
      'NEC' => 'NEC',
      'NIKON CORPORATION' => 'Nikon',
      'NIKON' => 'Nikon',
      'OLYMPUS CORPORATION' => 'Olympus',
      'OLYMPUS IMAGING CORP.' => 'Olympus',
      'OLYMPUS OPTICAL CO.,LTD' => 'Olympus',
      'OLYMPUS_IMAGING_CORP.' => 'Olympus',
      'PENTAX Corporation ' => 'Pentax',
      'PENTAX Corporation' => 'Pentax',
      'PENTAX DIGITAL CAMERA' => 'Pentax',
      'PENTAX RICOH IMAGING' => 'Pentax Ricoh',
      'PENTAX' => 'Pentax',
      'RICOH' => 'Ricoh',
      'Rollei Fototechnic GmbH' => 'Rollei',
      'ROLLEI' => 'Rollei',
      'Rollei' => 'Rollei',
      'SAMSUNG ELEC.' => 'Samsung',
      'SAMSUNG ELECTRONICS' => 'Samsung',
      'SAMSUNG Electronics' => 'Samsung',
      'SAMSUNG TECHWIN CO,. LTD' => 'Samsung Techwin',
      'SANYO Electric Co.,Ltd.' => 'Sanyo',
      ' SANYO Electric Co.,Ltd.' => 'Sanyo',
      'SEIKO EPSON CORP.' => 'Seiko Epson',
      'SONY' => 'Sony',
      'TRAVELER OPTICAL CO,LTD' => 'Traveler',
      'Vodafone Group' => 'Vodafone',
      'Vodafone' => 'Vodafone',
      'WIA' => 'WIA',
      'WWL .,LTD' => 'WWL',
      'WWL Corporation' => 'WWL',
      'WWL' => 'WWL'
    }
    expected.collect_hash do |raw_make, expected_make|
      {raw_make => CameraTag.clean_make(raw_make)}
    end.must_equal_hash(expected)
  end

  it 'cleans EXIF models' do
    expected = [
      ['KODAK', 'KODAK C310 DIGITAL CAMERA', 'C310'],
      ['MOTOROLA', 'DROID2 4efa0021ffd800000a3a513a13025025', 'DROID2'],
      ['MOTOROLA', 'DROID2 GLOBAL 2f140001ffd800000a3a9c5303026017', 'DROID2 GLOBAL'],
      ['Kodak', 'DC200      (V02.10)', 'DC200'],
      ['Canon', 'Canon DIGITAL IXUS 85 IS', 'DIGITAL IXUS 85 IS'],
      ['Hewlett-Packard', 'HP PhotoSmart R725  (V01.00)d', 'PhotoSmart R725']
    ]
    expected.each do |clean_make, raw_model, expected_model|
      CameraTag.clean_model(clean_make, raw_model).must_equal expected_model
    end
  end
end
