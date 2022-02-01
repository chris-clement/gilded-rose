require 'gilded_rose'
require 'item'

describe GildedRose do

  describe "#reduce_items_quality" do
    it "reduces the quality of a single item by 1" do
      soup = Item.new('soup', 3, 10)
      gilded_rose = GildedRose.new(soup)
      
      expect{ gilded_rose.reduce_items_quality }.to change { soup.quality }.by -1
    end
  end
end