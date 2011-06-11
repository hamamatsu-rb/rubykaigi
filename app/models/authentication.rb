class Authentication < ActiveRecord::Base
  belongs_to :rubyist

  attr_accessor :current_password, :password, :password_confirmation

  validates :uid, :uniqueness => {:scope => :provider}, :presence => true
  validates :provider, :presence => true
  validates :password, :confirmation => true, :if => :changing_password?

  validate do
    if changing_password?
      errors.add(:current_password, :invalid) unless valid_password?(current_password)
    end
  end

  before_save do
    if changing_password?
      self.uid = Authentication.encrypt_password(rubyist.username, password)
    end
  end

  def change_password!(args)
    self.current_password      = args[:current_password]
    self.password              = args[:password]
    self.password_confirmation = args[:password_confirmation]
    self.save!
  end

  def changing_password?
    password.present? && provider == 'password'
  end

  def valid_password?(p)
    Authentication.encrypt_password(rubyist.username, p) == uid
  end

  def self.encrypt_password(identifier, password)
    encripter = OmniAuth::Strategies::Password.new(nil, Rubykaigi::Application.config.secret_token)
    encripter.encrypt(identifier, password)
  end
end
