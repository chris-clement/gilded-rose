require 'item'

class GildedRose

  FLOOR_QUALITY = 0
  FLOOR_SELL_IN = 0
  CEILING_QUALITY = 50
  
  SELL_IN_STD_REDUCTION = 1
  
  QUALITY_STD_REDUCTION = 1
  QUALITY_HIGHER_REDUCTION = 2
  
  QUALITY_STD_INCREASE = 1

  def initialize(items)
    @items = items
    @aged_items = ['Aged Brie']
  end

  def update_quality()
    @items.each do |item|
      if item.name != "Aged Brie" and item.name != "Backstage passes to a TAFKAL80ETC concert"
        if item.quality > 0
          if item.name != "Sulfuras, Hand of Ragnaros"
            item.quality = item.quality - 1
          end
        end
      else
        if item.quality < 50
          item.quality = item.quality + 1
          if item.name == "Backstage passes to a TAFKAL80ETC concert"
            if item.sell_in < 11
              if item.quality < 50
                item.quality = item.quality + 1
              end
            end
            if item.sell_in < 6
              if item.quality < 50
                item.quality = item.quality + 1
              end
            end
          end
        end
      end
      if item.name != "Sulfuras, Hand of Ragnaros"
        item.sell_in = item.sell_in - 1
      end
      if item.sell_in < 0
        if item.name != "Aged Brie"
          if item.name != "Backstage passes to a TAFKAL80ETC concert"
            if item.quality > 0
              if item.name != "Sulfuras, Hand of Ragnaros"
                item.quality = item.quality - 1
              end
            end
          else
            item.quality = item.quality - item.quality
          end
        else
          if item.quality < 50
            item.quality = item.quality + 1
          end
        end
      end
    end
  end

  def change_items_quality
    @items.each do |item|
      if @aged_items.include? item.name
        increase_item_quality(item)
      else
        reduce_item_quality(item)
      end
    end
  end

  def reduce_item_quality(item)
      if @aged_items.include? item.name
        raise "This item gets better with age. Quality not reduced."
      elsif item.quality == FLOOR_QUALITY
        item.quality -= 0
      elsif item.sell_in < FLOOR_SELL_IN
        item.quality -= QUALITY_HIGHER_REDUCTION
      else
        item.quality -= QUALITY_STD_REDUCTION
      end
  end

  def increase_item_quality(item)
    if item.quality < CEILING_QUALITY
      item.quality += QUALITY_STD_INCREASE
    end
  end

  def reduce_items_sell_in
    @items.each do |item|
      item.sell_in -= SELL_IN_STD_REDUCTION
    end
  end
end


