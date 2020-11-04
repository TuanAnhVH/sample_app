class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  scope :created_at_desc, ->{order created_at: :desc}
  scope :compare_user_id, ->(id){where user_id: id}
  validates :user_id, presence: true
  validates :content,
            presence: true,
            length: {maximum: Settings.micropost.content.max_length}
  validates :image,
            content_type: {in: %i(gif png jpg jpeg),
                           message: I18n.t("models.microposts.image_type")},
            size: {less_than: Settings.image.size.megabytes,
                   message: I18n.t("models.microposts.image_size")}

  def display_image
    image.variant(resize_to_limit: [Settings.image.show, Settings.image.show])
  end
end
