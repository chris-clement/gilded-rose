require 'gilded_rose'
require 'item'

describe GildedRose do

  before(:each) do
    @soup = Item.new('soup', 3, 10)
    @bread = Item.new('bread', 5, 5)
    @better_with_age_item = Item.new('Aged Brie', 10, 20)
    @lowest_quality = GildedRose::FLOOR_QUALITY
    @lowest_sell_in = GildedRose::FLOOR_SELL_IN
    @quality_std_reduction = GildedRose::QUALITY_STD_REDUCTION
    @quality_higher_reduction = GildedRose::QUALITY_HIGHER_REDUCTION
  end

  describe '#reduce_items_sell_in' do
    it 'reduces the sell_in of a single item by standard amount' do
      gilded_rose = GildedRose.new([@soup])
      
      expect{ gilded_rose.reduce_items_sell_in }.to change { @soup.sell_in }.by -1
    end
    it 'reduces the sell_in of two items by standard amount' do
      gilded_rose = GildedRose.new([@soup, @bread])
      
      expect{ gilded_rose.reduce_items_sell_in}.to change { @soup.sell_in }.by -1
      expect{ gilded_rose.reduce_items_sell_in }.to change { @bread.sell_in }.by -1
    end
  end
  describe '#change_items_quality' do
    it 'reduces the quality of a single item by standard amount' do
      gilded_rose = GildedRose.new([@soup])
      
      expect{ gilded_rose.change_items_quality }.to change { @soup.quality }.by -@quality_std_reduction
    end
    it 'reduces the quality of two items by standard amount' do
      gilded_rose = GildedRose.new([@soup, @bread])
      
      expect{ gilded_rose.change_items_quality }.to change { @soup.quality }.by -@quality_std_reduction
      expect{ gilded_rose.change_items_quality }.to change { @bread.quality }.by -@quality_std_reduction
    end
    it 'once sell by date has passed, quality degrades twice as fast' do
      gilded_rose = GildedRose.new([@soup])
      (@soup.sell_in - @lowest_sell_in + 1).times do 
        gilded_rose.reduce_items_sell_in
      end
      expect{ gilded_rose.change_items_quality }.to change { @soup.quality }.by -@quality_higher_reduction
    end
    it 'stops reducing when quality is at the lowest quality allowed' do
      gilded_rose = GildedRose.new([@soup])
      (@soup.quality - @lowest_quality).times do 
        gilded_rose.change_items_quality
      end
      expect{ gilded_rose.change_items_quality }.to change { @soup.quality }.by 0
    end
    it "calls the increase_items_quality method if the item is a aged_item" do
      gilded_rose = GildedRose.new([@better_with_age_item])
      expect(gilded_rose).to receive :increase_item_quality
      gilded_rose.change_items_quality
    end
    it 'aged_item actually increases in quality by 1 as time passes' do
      gilded_rose = GildedRose.new([@better_with_age_item])
      expect{ gilded_rose.change_items_quality }.to change { @better_with_age_item.quality }.by 1
    end
    it "calls the decrease_items_quality method if the item is not an aged_item" do
      gilded_rose = GildedRose.new([@soup])
      expect(gilded_rose).to receive :reduce_item_quality
      gilded_rose.change_items_quality
    end
  end
  describe '#reduce_item_quality' do
    it "raises an error when trying to reduce quality of an aged_item" do
      gilded_rose = GildedRose.new([@better_with_age_item])
      expect { gilded_rose.reduce_item_quality(@better_with_age_item) }.to raise_error 'This item gets better with age. Quality not reduced.'
    end
  end
end