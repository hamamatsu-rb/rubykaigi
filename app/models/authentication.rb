class Authentication < ActiveRecord::Base
  belongs_to :rubyist

  validates :uid, :uniqueness => {:scope => :provider}, :presence => true
  validates :provider, :presence => true
end
