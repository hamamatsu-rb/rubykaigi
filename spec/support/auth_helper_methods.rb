module AuthHelperMethods
  def sign_in_as(rubyist)
    stub(controller) {
      user { rubyist }
      authenticated? { true }
    }
  end

  def not_signed_in
    stub(controller).authenticated? { false }
  end
end
