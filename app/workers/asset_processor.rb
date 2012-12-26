class AssetProcessor


  include Sidekiq::Worker

  def perform(uri)
    ProtoAsset.new(uri.to_url).process
  end
end

