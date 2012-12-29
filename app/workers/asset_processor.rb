class AssetProcessor
  include Sidekiq::Worker
  def perform(pathname)
    proto_asset = ProtoAsset.new(pathname)
    proto_asset.process
    proto_asset.asset
  end
end

