class Product < ActiveRecord::Base
  
  has_attached_file :avatar, styles: {
     thumb: '100x100>',
     square: '200x200#',
     medium: '300x300>'
   }, :default_url => "/images/:style/missing.png",
   :storage => :s3,
   :s3_permissions => :public_read,
   :s3_credentials => "#{Rails.root}/config/aws.yml",
   :bucket => 'hashtree-assets',
   :s3_options => { :server => "s3-eu-west-1.amazonaws.com" }

   validates_attachment :avatar,
     :size => { :in => 0..$MAX_FILE_SIZE.kilobytes }
   
   # validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
   
   validates_attachment :avatar, :content_type => { :content_type => ["image/jpeg", "image/png"] }
   validates_attachment_file_name :avatar, :matches => [/png\Z/, /jpe?g\Z/, /mp3\Z/, /mp4\Z/,/epub\Z/,/pdf\Z/]
   # Explicitly do not validate
   do_not_validate_attachment_file_type :avatar
   
   
   has_attached_file :document
   
   has_attached_file :document,
    :storage => :s3,
    :s3_permissions => :public_read,
    :s3_credentials => "#{Rails.root}/config/aws.yml",
    :bucket => 'hashtree-assets',
    :s3_options => { :server => "s3-eu-west-1.amazonaws.com" }
   

   # validates_attachment_presence :document
   validates_attachment_content_type :document, :content_type => [ 'application/pdf','text/plain',"application/epub+zip","application/octet-stream","application/zip"]
   validates_attachment_file_name :document, :matches => [/png\Z/, /jpe?g\Z/,/epub\Z/,/pdf\Z/,/webarchive\Z/,/zip\Z/]
   validates_attachment :document,
      :size => { :in => 0..$MAX_FILE_SIZE.kilobytes }
   do_not_validate_attachment_file_type :document

   has_attached_file :audio
   # validates_attachment_presence :audio
   validates_attachment_content_type :audio, :content_type => [ 'audio/mp3','audio/mpeg']
   validates_attachment_file_name :audio, :matches => [/mp3\Z/, /mp4\Z/]
   validates_attachment :audio,
      :size => { :in => 0..$MAX_FILE_SIZE.kilobytes }
   
   has_attached_file :video
   # validates_attachment_presence :video
   validates_attachment_content_type :video, :content_type => [ 'video/mp4','video/mpeg']
   validates_attachment_file_name :video, :matches => [/mp4\Z/]
   validates_attachment :video,
      :size => { :in => 0..$MAX_FILE_SIZE.kilobytes }

  has_many :line_items
  has_many :orders, :through => :line_items
  before_destroy :ensure_not_referenced_by_any_line_item
  after_initialize :set_default_stock, :if => :new_record?
  
  CATEGORIES = ["ebook","paperback","membership", "music"]
  
  DOC_TYPES = ["pdf", "epub", "webarchive","zip","video", "audio"]
  
  def set_default_stock
    self.stock ||= 1
  end
  
  def has_attachment?
    !self.document_file_name.blank? or ( !self.audio_file_name.blank? or !self.video_file_name.blank?)
  end
  

  private
  # ensure that there are no line items referencing this product

  def ensure_not_referenced_by_any_line_item
    if line_items.empty?
      return true
    else
      errors.add(:base, 'Line Items Present')
      return false
    end
  end
  
end
