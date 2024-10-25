class UserNameForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :user

  attribute :name, :string

  validates :name, format: { with: /\A\p{Hiragana}+\z/ }, presence: true

  def initialize(model: nil, **attrs)
    attrs.symbolize_keys!
    if model
      @user = model
      attrs = { name: @user.name }.merge(attrs)
    end
    super(**attrs)
  end

  def save(...)
    transfer_attributes
    if valid?
      user.save(...)
    else
      false
    end
  end

  def form_with_options
    if user.persisted?
      { url: Rails.application.routes.url_helpers.name_path(user), method: :patch }
    else
      { url: Rails.application.routes.url_helpers.names_path, method: :post }
    end
  end

  private
  def transfer_attributes
    user.name = name
  end
end

# つかい方の例:
# uf = UserNameForm.new(model: User.new, name: "いがいが")
# if uf.save
#   # 成功時の処理
# else
#   # 失敗時の処理
# end
