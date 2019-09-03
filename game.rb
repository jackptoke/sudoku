require_relative 'cell'
require 'tty-table'
require 'tty-box'
#Prepare
# #         1  2  3  4  5  6  7  8  9
# cell_values = [ [0, 3, 0, 0, 0, 7, 1, 0, 0],# 1
#                 [0, 0, 0, 0, 2, 0, 4, 0, 0],# 2
#                 [2, 0, 8, 0, 0, 0, 7, 9, 6],# 3
#                 [8, 0, 0, 0, 4, 9, 0, 5, 7],# 4
#                 [3, 7, 9, 5, 0, 1, 0, 0, 0],# 5
#                 [0, 0, 0, 7, 6, 3, 0, 0, 0],# 6
#                 [0, 2, 0, 0, 5, 0, 0, 6, 3],# 7
#                 [0, 6, 4, 0, 3, 0, 0, 0, 9],# 8
#                 [5, 0, 0, 0, 0, 0, 0, 0, 4]]# 9

#                1  2  3  4  5  6  7  8  9
cell_values = [ [1, 0, 0, 0, 0, 0, 8, 0, 2],# 1
                [0, 0, 9, 0, 2, 8, 4, 0, 0],# 2
                [0, 0, 0, 0, 6, 7, 9, 0, 0],# 3
                [0, 0, 1, 6, 0, 4, 2, 5, 3],# 4
                [0, 0, 0, 7, 3, 0, 1, 0, 0],# 5
                [0, 9, 0, 2, 8, 0, 0, 0, 0],# 6
                [3, 6, 0, 8, 0, 0, 5, 4, 1],# 7
                [4, 0, 0, 0, 0, 2, 6, 9, 8],# 8
                [9, 0, 5, 0, 1, 0, 0, 0, 0]]# 9

CELLS = []

cell_values.each_with_index do |row, index_r|
  cell_row = []
  row.each_with_index do |value, index_c|
    cell_row << Cell.new(index_r, index_c, value)
  end
  CELLS << cell_row
end

# cells.each do |row|
#   row.each do |cell|
#     puts cell.to_s
#     p cell.vertical_family
#     p cell.horizontal_family
#   end
#   puts
# end

#build the possible values of each cell
def build_potential_value_list
  CELLS.each do |row|
    row.each do |cell|
      #all cell except the fixed one
      if !cell.is_fixed
        cell.potential_value_stack = [1, 2, 3, 4, 5, 6, 7, 8, 9]
        
        #for each cell in the vertical
        cell.vertical_family.each do |c|
          cell.potential_value_stack.delete_if {|value| value == CELLS[c[0]][c[1]].value}
        end
        cell.horizontal_family.each do |c|
          cell.potential_value_stack.delete_if {|value| value == CELLS[c[0]][c[1]].value}
        end
        cell.block_family.each do |c|
          cell.potential_value_stack.delete_if {|value| value == CELLS[c[0]][c[1]].value}
        end
      end
    end
  end
end

#shed 
def shed_potential_value_list
  CELLS.each do |row|
    row.each do |cell|
      #all cell except the fixed one
      if !cell.is_fixed
        #for each cell in the vertical
        cell.vertical_family.each do |c|
          cell.potential_value_stack.delete_if {|value| value == CELLS[c[0]][c[1]].value}
        end
        cell.horizontal_family.each do |c|
          cell.potential_value_stack.delete_if {|value| value == CELLS[c[0]][c[1]].value}
        end
        cell.block_family.each do |c|
          cell.potential_value_stack.delete_if {|value| value == CELLS[c[0]][c[1]].value}
        end
      end
    end
  end
end

#evaluate and update
def update_cells
  CELLS.each do |row|
    row.each do |cell|
      #all cell except the fixed one
      if (!cell.is_fixed) && cell.potential_value_stack.size == 1
        cell.value = cell.potential_value_stack.pop
      end
    end
  end
end

#display the cells
def display_sudoku
  table = TTY::Table.new ['header1','header2'], [['a1', 'a2'], ['b1', 'b2']]
  box = TTY::Box.frame(
  width: 30,
  height: 10,
  align: :center,
  padding: 3,
  border: :thick,
  title: {top_left: 'Sudoku', bottom_right: 'Programmer Jack'}
  ) do
  table.render(:ascii)
  end
end

#solve the sudoku
def is_solved
  solved = true
  CELLS.each do |row|
    row.each do |cell|
      #all cell except the fixed one
      if cell.value == 0
        return false
      end
    end
  end
  return solved
end

#build the potential list of values for each cell
build_potential_value_list()
update_cells  #update the value of each cell

#keep shedding the potential value list until the sudoku is solved
counter = 0
while !is_solved()  
  shed_potential_value_list
  update_cells
  counter += 1
end
puts "##############Total Round #{counter}#############"

CELLS.each do |row|
  row.each do |cell|
    puts cell.to_s
    p cell.potential_value_stack
    p "..............."
  end
  puts
end

display_sudoku