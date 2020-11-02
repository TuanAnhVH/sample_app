class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  default_scope ->{order(created_at: :desc)}
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}
  validates :image,
            content_type: {in: %i(gif png jpg jpeg),
                           message: I18n.t("models.microposts.image_type")},
            size: {less_than: 5.megabytes,
                   message: I18n.t("models.microposts.image_size")}

  def display_image
    image.variant(resize_to_limit: [Settings.image.size, Settings.image.size])
  end
end
