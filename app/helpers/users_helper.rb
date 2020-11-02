module UsersHelper
  def gravatar_for user, size = {size: Settings.avatar.size_80}
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    s = size[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{s}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end

  def valid_admin? user
    current_user.admin? && !current_user?(user)
  end
end
