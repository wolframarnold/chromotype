namespace :asset  do
  desc "show thumbprints for an asset"
  task :thumbprints => :environment do
    asset_path = ENV['ASSET'] || begin
      print "Path to asset: "
      $stdin.gets
    end
    pa = ProtoAsset.new(asset_path)
    puts pa.thumbprints.to_yaml
  end
end
