module UsersHelper
  # gravatar_id / user.email.downcase したものを暗号化（ダイジェスト）にしたもの
  def gravatar_url(user, options = { size: 80 })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
  end
end
