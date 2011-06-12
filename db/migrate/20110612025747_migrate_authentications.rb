class MigrateAuthentications < ActiveRecord::Migration
  def self.up
    Authentication.transaction do
      Rubyist.all.each do |rubyist|
        if rubyist.identity_url?
          Authentication.create! :provider => 'open_id',
                                 :uid      => rubyist.identity_url,
                                 :rubyist  => rubyist
        end

        if rubyist.twitter_user_id?
          Authentication.create! :provider => 'twitter',
                                 :uid      => rubyist.twitter_user_id,
                                 :rubyist  => rubyist
        end
      end
    end
  end

  def self.down
  end
end
