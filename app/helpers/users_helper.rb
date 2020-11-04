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

  def find_relationship id
    relationship = current_user.active_relationships.find_by(followed_id: id)
    return relationship if relationship

    flash[:danger] = t "base.user_not_found"
    redirect_to root_path
  end
end
