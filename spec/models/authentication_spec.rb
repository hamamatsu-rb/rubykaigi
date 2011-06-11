require 'spec_helper'

describe Authentication do
  describe "パスワード変更" do
    let(:rubyist) { Rubyist.make }
    let(:authentication) {
      Authentication.make :provider => 'password',
                          :uid => Authentication.encrypt_password(rubyist.username, 'password'),
                          :rubyist => rubyist
    }

    subject do
      authentication.current_password      = 'password'
      authentication.password              = 'new_password'
      authentication.password_confirmation = 'new_password'
      authentication.save!
      authentication.reload
    end

    its(:uid) { should_not eq 'password' }

    context "変更前のパスワードが間違っていた場合" do
      before do
        authentication.current_password      = 'passwd'
        authentication.password              = 'new_password'
        authentication.password_confirmation = 'new_password'
      end

      it "invalidになること" do
        authentication.should be_invalid
        authentication.errors[:current_password].should be_present
      end
    end

    context "パスワードが一致しないとき" do
      before do
        authentication.current_password      = 'password'
        authentication.password              = 'new_password'
        authentication.password_confirmation = 'foo'
      end

      it "invalidになること" do
        authentication.should be_invalid
        authentication.errors[:password].should be_present
      end
    end
  end
end
