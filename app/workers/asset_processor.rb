class AssetProcessor
  include Sidekiq::Worker
  def perform(url)
    ProtoAsset.new(url).process
  end
end

