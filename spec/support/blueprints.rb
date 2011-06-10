# -*- coding: utf-8 -*-
require 'machinist/active_record'
require 'sham'
require 'faker'

Sham.username { Faker::Internet.user_name.gsub('.', '-') }
Sham.year(:unique => true) {|i| 2010 + i }
Sham.item_code(:unique => true) {|i| "item_#{i}" }
Sham.sort_order(:unique => true) {|i| i }

Rubyist.blueprint do
  username
end

Authentication.blueprint do
  provider { 'twitter' }
end

Rubyist.blueprint :invalid do
  username { '' }
end

def make_rubyist_as_staff(kaigi_year = RubyKaigi.latest_year, attrs = {})
  returning Rubyist.make(attrs) do |r|
    Contribution.authorize_as_staff(r, kaigi_year)
  end
end

RubyKaigi.blueprint do
  year
  capacity { 0 }
  party_capacity { 0 }
end

HeadlineEntry.blueprint do
end

ProductItem.blueprint do
  item_code
  unit_price { 123 }
  stock { 10 }
  ruby_kaigi_id { 5 }
  open_sale_at { Time.now }
  ready_for_sale { false }
end

Order.blueprint do
  rubyist { Rubyist.make }
  ruby_kaigi_id { 5 }
  return_from_paypal { false }
  price { 0 }
end

OrderItem.blueprint do
  order { Order.make }
  product_item { ProductItem.make }
  quantity { 1 }
  unit_price { 0 }
end

IndividualSponsorOption.blueprint do
  link_label { "matz" }
  link_url { "http://www.rubyist.net/~matz/" }
  additional_amount { 0 }
  attend_party { true }
end

Contribution.blueprint do
  contribution_type { "attendee" }
  rubyist { Rubyist.make }
  ruby_kaigi_id { 5 }
  order_item { OrderItem.make }
end

Room.blueprint do
  name_en { 'Room A' }
  name_ja { '部屋A' }
  sort_order
end

Event.blueprint do
  title_en { 'Keynote' }
  title_ja { '基調講演' }
  abstract_en { 'something about Ruby' }
  abstract_ja { 'Rubyの話' }
  room
end
