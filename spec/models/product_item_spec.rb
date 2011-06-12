require 'spec_helper'

describe ProductItem do
  describe "#now_on_sale?" do
    context "販売開始時刻を過ぎている" do
      let(:product_item) { ProductItem.make_unsaved(:open_sale_at => 1.minute.ago) }

      context "販売準備完了フラグが立っている" do
        before { product_item.ready_for_sale = true }
        it { product_item.should be_now_on_sale }
      end

      context "販売準備完了フラグが立ってない" do
        before { product_item.ready_for_sale = false }
        it { product_item.should_not be_now_on_sale }
      end
    end

    context "販売開始時刻をまだ過ぎていない" do
      let(:product_item) { ProductItem.make_unsaved(:open_sale_at => 30.minutes.from_now) }

      context "販売準備完了フラグが立っている" do
        before { product_item.ready_for_sale = true }
        it { product_item.should_not be_now_on_sale }
      end

      context "販売準備完了フラグが立ってない" do
        before { product_item.ready_for_sale = false }
        it { product_item.should_not be_now_on_sale }
      end
    end
  end
end
