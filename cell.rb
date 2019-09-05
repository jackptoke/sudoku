# frozen_string_literal: true

class Cell
  # representing a cell on a sudoku table

  # once initiated the row and column remained unchanged
  attr_reader :row, :column, :value, :vertical_family, :horizontal_family, :block_family
  # value can be changed
  attr_accessor :potential_value_stack

  def initialize(row, column, value)
    @row = row
    @column = column
    @vertical_family = [] # all the cells in a column the cell belong to
    @horizontal_family = [] # all the cells in a row that the cell belong to
    @block_family = [] # all the cells in the same block the cell belong to
    @value = value # value of the cell
    @potential_value_stack = [] # all the potential value it could have

    # whether or not the value is permissible to change
    @fixed = if value.to_i > 0 && value.to_i <= 9
               true
             else
               false
             end

    # initializing the value of the vertical family
    (0..8).each do |r|
      @vertical_family << [r, @column] if r != @row
    end

    # initializing the value of the horizontal family
    (0..8).each do |c|
      @horizontal_family << [@row, c] if c != @column
    end

    # get all the cells that the cell belong to
    get_block_family
  end

  # change the value of the cell
  def value=(v)
    if !@fixed && (v <= 9 && v > 0)
      @value = v
      return true
    end
    false
  end

  # Is the number changeable
  def is_fixed
    @fixed
  end

  def to_s
    "[#{@row}, #{@column}, #{@value}]"
  end
  # get block family

  private

  def get_block_family
    # initializing block family
    # @block_family = []

    if @row < 3
      if @column < 3
        (0..2).each do |r|
          @block_family << [r, 0]  # block 1
          @block_family << [r, 1]
          @block_family << [r, 2]
        end
      elsif @column >= 3 && @column < 6
        (0..2).each do |r|
          @block_family << [r, 3]  # block 2
          @block_family << [r, 4]
          @block_family << [r, 5]
        end
      elsif @column >= 6 && @column < 9
        (0..2).each do |r|
          @block_family << [r, 6]  # block 3
          @block_family << [r, 7]
          @block_family << [r, 8]
        end
      end
    elsif @row >= 3 && @row < 6
      if @column < 3
        (3..5).each do |r|
          @block_family << [r, 0]  # block 4
          @block_family << [r, 1]
          @block_family << [r, 2]
        end
      elsif @column >= 3 && @column < 6
        (3..5).each do |r|
          @block_family << [r, 3]  # block 5
          @block_family << [r, 4]
          @block_family << [r, 5]
        end
      elsif @column >= 6 && @column < 9
        (3..5).each do |r|
          @block_family << [r, 6]  # block 6
          @block_family << [r, 7]
          @block_family << [r, 8]
        end
      end
    elsif @row >= 6 && @row < 9
      if @column < 3
        (6..8).each do |r|
          @block_family << [r, 0]  # block 7
          @block_family << [r, 1]
          @block_family << [r, 2]
        end
      elsif @column >= 3 && @column < 6
        (6..8).each do |r|
          @block_family << [r, 3]  # block 8
          @block_family << [r, 4]
          @block_family << [r, 5]
        end
      elsif @column >= 6 && @column < 9
        (6..8).each do |r|
          @block_family << [r, 6]  # block 9
          @block_family << [r, 7]
          @block_family << [r, 8]
        end
      end
    end
  end
end

# a = Cell.new(0,0,1)
# p a.block_family
# p a.vertical_family
# p a.horizontal_family
# p a.to_s

# p ".........................................."

# b = Cell.new(3,5,1)
# p b.block_family
# p b.vertical_family
# p b.horizontal_family

# c = Cell.new(0,4,1)
# p c.block_family
# p c.vertical_family
# p c.horizontal_family

# d = Cell.new(7,0,1)
# p d.block_family
# p d.vertical_family
# p d.horizontal_family
