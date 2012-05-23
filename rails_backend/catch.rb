class Catch < ModelObject
  belongs_to :user

  include_attributes :photo_url, :normal_photo_url

  CREDENTIALS = { access_key_id:'AKIAJLSKSPUOSE6VO5JA', secret_access_key:'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' }

  has_attached_file :photo, :styles => { tiny:'32x32#', table_cell:'40x40#', small:'320x240#' }, :storage => :s3, :bucket => 'fishr', :s3_credentials => CREDENTIALS

  def created_at
    read_attribute(:created_at).strftime '%D' if persisted?
  end

  def photo_url
    photo(:tiny).to_s
  end

  def normal_photo_url
    photo.to_s
  end
end
