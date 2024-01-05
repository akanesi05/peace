require 'carrierwave/storage/abstract'
require 'carrierwave/storage/file'
require 'carrierwave/storage/fog'

CarrierWave.configure do |config|
    config.storage :fog
    config.fog_provider = 'fog/aws'
    config.fog_directory  = 'pisusotu' # バケット名
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: ENV['A3UYY6XTJXMF66QTE'], # 環境変数
      aws_secret_access_key: ENV['xLy4hDLd4QuRSh8cbKv2OXHZk4oKX7kKg12NPHjm'], # 環境変数
      region: 'ap-northeast-1', # リージョン
      path_style: true
    }
end 
