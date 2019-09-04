class Cell
  #representing a cell on a sudoku table
  
  #once initiated the row and column remained unchanged
  attr_reader :row, :column, :value, :vertical_family, :horizontal_family, :block_family
  #value can be changed
  attr_accessor :potential_value_stack

  def initialize(row, column, value)
    @row = row
    @column = column
    @vertical_family = [] #all the cells in a column the cell belong to
    @horizontal_family = [] #all the cells in a row that the cell belong to
    @block_family = [] #all the cells in the same block the cell belong to
    @value = value #value of the cell
    @potential_value_stack = [] #all the potential value it could have
    
    #whether or not the value is permissible to change
    if value.to_i > 0 && value.to_i <= 9
      @fixed = true
    else
      @fixed = false
    end

    #initializing the value of the vertical family
    for r in (0..8)
      if r != @row
        @vertical_family << [r, @column]
      end
    end

    #initializing the value of the horizontal family
    for c in (0..8)
      if c != @column
        @horizontal_family << [@row, c]
      end
    end  

    #get all the cells that the cell belong to
    get_block_family()
  end

  #change the value of the cell
  def value=(v)
    if !@fixed && (v <= 9 && v > 0)
      @value = v
      return true
    end 
    return false
  end

  #Is the number changeable
  def is_fixed
    return @fixed
  end

  def to_s
    return "[#{@row}, #{@column}, #{@value}]"
  end
  #get block family
  private
  def get_block_family()
    #initializing block family
    # @block_family = []
    
    if @row < 3
      if @column < 3
        for r in (0..2)
          @block_family << [r, 0]  #block 1
          @block_family << [r, 1]  
          @block_family << [r, 2]  
        end
      elsif @column >= 3 && @column < 6
        for r in (0..2)
          @block_family << [r, 3]  #block 2
          @block_family << [r, 4]  
          @block_family << [r, 5]  
        end
      elsif @column >= 6 && @column < 9
        for r in (0..2)
          @block_family << [r, 6]  #block 3
          @block_family << [r, 7]  
          @block_family << [r, 8]  
        end
      end
    elsif @row >= 3 && @row < 6
      if @column < 3
        for r in (3..5)
          @block_family << [r, 0]  #block 4
          @block_family << [r, 1]  
          @block_family << [r, 2]  
        end
      elsif @column >= 3 && @column < 6
        for r in (3..5)
          @block_family << [r, 3]  #block 5
          @block_family << [r, 4]  
          @block_family << [r, 5]  
        end
      elsif @column >= 6 && @column < 9
        for r in (3..5)
          @block_family << [r, 6]  #block 6
          @block_family << [r, 7]  
          @block_family << [r, 8]  
        end
      end
    elsif @row >= 6 && @row < 9
      if @column < 3
        for r in (6..8)
          @block_family << [r, 0]  #block 7
          @block_family << [r, 1]  
          @block_family << [r, 2]  
        end
      elsif @column >= 3 && @column < 6
        for r in (6..8)
          @block_family << [r, 3]  #block 8
          @block_family << [r, 4]  
          @block_family << [r, 5]  
        end
      elsif @column >= 6 && @column < 9
        for r in (6..8)
          @block_family << [r, 6]  #block 9
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