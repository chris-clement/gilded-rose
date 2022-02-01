require 'gilded_rose'
require 'item'

describe GildedRose do

  before(:each) do
    @soup = Item.new('soup', 3, 10)
    @bread = Item.new('bread', 5, 5)
  end

  describe '#reduce_items_quality' do
    it 'reduces the quality of a single item by 1' do
      gilded_rose = GildedRose.new([@soup])
      
      expect{ gilded_rose.reduce_items_quality }.to change { @soup.quality }.by -1
    end
    it 'reduces the quality of two items by 1' do
      gilded_rose = GildedRose.new([@soup, @bread])
      
      expect{ gilded_rose.reduce_items_quality }.to change { @soup.quality }.by -1
      expect{ gilded_rose.reduce_items_quality }.to change { @bread.quality }.by -1
    end
    it 'once sell by date has passed, quality degrades twice as fast' do
      gilded_rose = GildedRose.new([@soup])
      (@soup.sell_in + 1).times do 
        gilded_rose.reduce_items_sell_in
      end
      expect{ gilded_rose.reduce_items_quality }.to change { @soup.quality }.by -2
    end
    it 'stops reducing when quality is at 0' do
      gilded_rose = GildedRose.new([@soup])
      (@soup.quality).times do 
        gilded_rose.reduce_items_quality
      end
      expect{ gilded_rose.reduce_items_quality }.to change { @soup.quality }.by 0
    end
    it 'Aged Brie actually increases in quality by 1 as time passes' do
      brie = Item.new('Aged Brie', 10, 20)
      gilded_rose = GildedRose.new([brie])
      expect{ gilded_rose.reduce_items_quality }.to change { brie.quality }.by 1
    end
  end
  describe '#reduce_items_sell_in' do
    it 'reduces the sell_in of a single item by 1' do
      gilded_rose = GildedRose.new([@soup])
      
      expect{ gilded_rose.reduce_items_sell_in }.to change { @soup.sell_in }.by -1
    end
    it 'reduces the sell_in of two items by 1' do
      gilded_rose = GildedRose.new([@soup, @bread])
      
      expect{ gilded_rose.reduce_items_sell_in}.to change { @soup.sell_in }.by -1
      expect{ gilded_rose.reduce_items_sell_in }.to change { @bread.sell_in }.by -1
    end
  end
  describe '#change_items_quality' do
    it "calls the increase_items_quality method if the item is Aged brie" do
      brie = Item.new('Aged Brie', 10, 20)
      gilded_rose = GildedRose.new([brie])
      expect(gilded_rose).to receive :increase_item_quality
      gilded_rose.change_items_quality
    end
  end
end