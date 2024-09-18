class ImageUploader < CarrierWave::Uploader::Base

  if Rails.env.production?
    storage :fog # 本番環境ではfogを使用
  else
    storage :file # 開発環境とテスト環境ではfileを使用
  end
 
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end



  def extension_allowlist
    %w[jpg jpeg gif png]
  end

  def size_range
    1..300.kilobytes
  end
 
end
