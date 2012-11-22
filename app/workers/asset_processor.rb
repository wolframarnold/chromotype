class AssetProcessor


  include Sidekiq::Worker

  def perform(uri)
    ProtoAsset.new(uri.to_uri).process
  end
end

