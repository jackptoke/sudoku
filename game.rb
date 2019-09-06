# frozen_string_literal: true

require_relative 'cell'
require 'terminal-table'
require_relative 'file_manipulator'
require 'colorize'
require 'colorized_string'
require_relative 'gui'
require 'pry'

# include Gui
# include FileManipulator
# loading datas from files
# cell_values1 = FileManipulator.load_sudoku_from_file("sudoku1.csv")
# cell_values2 = FileManipulator.load_sudoku_from_file("sudoku2.csv")

# build the possible values of each cell
def build_potential_value_list(cells)
  cells.each do |row|
    row.each do |cell|
      # all cell except the fixed one
      next if cell.is_fixed

      cell.potential_value_stack = [1, 2, 3, 4, 5, 6, 7, 8, 9]

      # for each cell in the vertical
      cell.vertical_family.each do |c|
        cell.potential_value_stack.delete_if { |value| value == cells[c[0]][c[1]].value }
      end
      cell.horizontal_family.each do |c|
        cell.potential_value_stack.delete_if { |value| value == cells[c[0]][c[1]].value }
      end
      cell.block_family.each do |c|
        cell.potential_value_stack.delete_if { |value| value == cells[c[0]][c[1]].value }
      end
    end
  end
end

# shed
def shed_potential_value_list(cells)
  cells.each do |row|
    row.each do |cell|
      # all cell except the fixed one
      next if cell.is_fixed
      # for each cell in the vertical
      cell.vertical_family.each do |c|
        cell.potential_value_stack.delete_if { |value| value == cells[c[0]][c[1]].value }
      end
      cell.horizontal_family.each do |c|
        cell.potential_value_stack.delete_if { |value| value == cells[c[0]][c[1]].value }
      end
      cell.block_family.each do |c|
        cell.potential_value_stack.delete_if { |value| value == cells[c[0]][c[1]].value }
      end
    end
  end
end

# evaluate and update
def update_cells(cells)
  cells.each do |row|
    row.each do |cell|
      # all cell except the fixed one
      if !cell.is_fixed && cell.potential_value_stack.size == 1
        cell.value = cell.potential_value_stack.pop
      end
    end
  end
end

# display the cells
def display_sudoku(cells, title)
  puts `clear`
  rows = []
  #header
  header = []
  header << { value: " ", alignment: :center }
  (1..(cells.size)).each do |col|
    header << { value: "Col #{col}\n\n", alignment: :center }
  end

  #add header to the top
  rows << header
  temp_row = []

  #add the content of the table
  cells.each_with_index do |row, index|
    temp_row = []
    temp_row << { value: "Row #{index + 1}\n", alignment: :center }
    row.each do |cell|
      temp_row << { value: "\n#{cell.value}", alignment: :center }
    end
    rows << temp_row
  end

  table2 = Terminal::Table.new title: title, rows: rows, style: { width: 90, all_separators: true }

  puts table2
end

# solve the sudoku
def solved(cells)
  a_flag = true

  cells.each do |row|
    row.each do |cell|
      # all cell except the fixed one
      return false if cell.value.zero?
    end
  end

  a_flag
end

# The function will solve a sudoku from a given filename
def solve_a_sudoku(sudoku_datas)
  sudoku_cells = prepare_sudoku_cells(sudoku_datas)
  # display_sudoku(sudoku_cells, "Sudoku to solve")
  # build the potential list of values for each cell
  build_potential_value_list(sudoku_cells)
  update_cells(sudoku_cells) # update the value of each cell
  counter = 0
  # continue to the try to solve
  # if the counter goes beyond a million
  # it's probably a bad sudoku
  until solved(sudoku_cells) || counter > 1000 #
    shed_potential_value_list(sudoku_cells)
    update_cells(sudoku_cells)
    # double_whammer(sudoku_cells)
    counter += 1
  end
  if (counter > 1000)
    return nil
  end
  sudoku_cells
end

# get a list of all the sudoku cells that require attention
# they are to be shed as their values changes
def get_working_list(sudoku_cells)
  # look through the grid and put into the array
  # all the cells that still need attention
  working_list = []
  sudoku_cells.each do |row|
    row.each do |cell|
      if cell.value.zero? 
        working_list << cell
        # print cell.value.to_s + ' '
      end
    end
  end
  return working_list
  # this method could possible implemented at the start
  # to reduce unnecessary check and improve performance
end

# Look for two or three cells in the same row, column or subgrid
# that have exactly the same values in their potential value lists
# if such cells are found, remove those values in all other cells
# that are not one of those cells
def double_whammer(sudoku_cells)

  # 1. obtain the lists of cells that still need a value
  # 2. for each cell in the list look for other cells
  #   which are in the same row, column or subgrid
  #   that has the same potential values
  # 3. if such cells are found, remove from other
  #   cells all those values from them
  working_list = get_working_list(sudoku_cells)

  #Those that are of the same row/column/subgrid
  #check if any of them has the same potential values
  working_list.each do |cell_a|
    check_list = working_list.find_all do |cell_b| 
      !cell_a.eql?(cell_b) && (cell_a.row == cell_b.row || cell_a.column == cell_b.column || cell_a.same_subgrid?(cell_b))
    end
    
    check_list.each do |cell|
      if cell_a.same_potential?(cell)
        #if the match is found on the same row
        if cell_a.row == cell.row
          sudoku_cells[cell_a.row].each do |x|
            if x.value.zero? && !x.eql?(cell_a) && !x.eql?(cell)
              cell_a.potential_value_stack.each {|v| x.potential_value_stack.delete(x)}
            end
          end
        elsif cell_a.column == cell.column
          i = 0
          until i >= sudoku_cells.size do
            cell_a.potential_value_stack.each do |v|
              if !sudoku_cells[i][cell_a.column].eql?(cell_a) && !sudoku_cells[i][cell_a.column].eql?(cell)
                sudoku_cells[i][cell_a.column].potential_value_stack.delete(v)
              end
            end
            i += 1
          end
        elsif cell_a.same_subgrid?(cell)
          cell_a.block_family.each do |indexes|
            if !sudoku_cells[indexes[0]][indexes[1]].eql?(cell_a) && !sudoku_cells[indexes[0][1]].eql?(cell)
              cell_a.potential_value_stack.each do |v|
                sudoku_cells[indexes[0]][indexes[1]].potential_value_stack.delete(v)
              end
            end
          end
        end
      end
    end
  end

  # working_list.each do |cell|
  #   puts "[#{cell.row}, #{cell.column}]"
  # end
  # puts "Working list: #{working_list.size}"
  # binding.pry
end

#this function is just created to tell the new algorithm
def temp_test(sudoku_datas)
  sudoku_cells = prepare_sudoku_cells(sudoku_datas)
  # display_sudoku(sudoku_cells, "Sudoku to solve")
  # build the potential list of values for each cell
  build_potential_value_list(sudoku_cells)
  update_cells(sudoku_cells) # update the value of each cell
  counter = 0
  # continue to the try to solve
  # if the counter goes beyond a million
  # it's probably a bad sudoku
 
  display_sudoku(sudoku_cells, "Test")
  shed_potential_value_list(sudoku_cells)
  
  update_cells(sudoku_cells)
  display_sudoku(sudoku_cells, "Test")
  double_whammer(sudoku_cells)
  update_cells(sudoku_cells)
  display_sudoku(sudoku_cells, "Test")

  update_cells(sudoku_cells)
  display_sudoku(sudoku_cells, "Test")
  double_whammer(sudoku_cells)
  update_cells(sudoku_cells)
  display_sudoku(sudoku_cells, "Test")

  update_cells(sudoku_cells)
  display_sudoku(sudoku_cells, "Test")
  double_whammer(sudoku_cells)
  update_cells(sudoku_cells)
  display_sudoku(sudoku_cells, "Test")

  update_cells(sudoku_cells)
  display_sudoku(sudoku_cells, "Test")
  double_whammer(sudoku_cells)
  update_cells(sudoku_cells)
  display_sudoku(sudoku_cells, "Test")

  update_cells(sudoku_cells)
  display_sudoku(sudoku_cells, "Test")
  double_whammer(sudoku_cells)
  update_cells(sudoku_cells)
  display_sudoku(sudoku_cells, "Test")

  update_cells(sudoku_cells)
  display_sudoku(sudoku_cells, "Test")
  double_whammer(sudoku_cells)
  update_cells(sudoku_cells)
  display_sudoku(sudoku_cells, "Test")

  update_cells(sudoku_cells)
  display_sudoku(sudoku_cells, "Test")
  double_whammer(sudoku_cells)
  update_cells(sudoku_cells)
  display_sudoku(sudoku_cells, "Test")

  update_cells(sudoku_cells)
  display_sudoku(sudoku_cells, "Test")
  double_whammer(sudoku_cells)
  update_cells(sudoku_cells)
  display_sudoku(sudoku_cells, "Test")

  update_cells(sudoku_cells)
  display_sudoku(sudoku_cells, "Test")
  double_whammer(sudoku_cells)
  update_cells(sudoku_cells)
  display_sudoku(sudoku_cells, "Test")

  update_cells(sudoku_cells)
  display_sudoku(sudoku_cells, "Test")
  double_whammer(sudoku_cells)
  update_cells(sudoku_cells)
  display_sudoku(sudoku_cells, "Test")

  update_cells(sudoku_cells)
  display_sudoku(sudoku_cells, "Test")
  double_whammer(sudoku_cells)
  update_cells(sudoku_cells)
  display_sudoku(sudoku_cells, "Test")

  update_cells(sudoku_cells)
  display_sudoku(sudoku_cells, "Test")
  double_whammer(sudoku_cells)
  update_cells(sudoku_cells)
  display_sudoku(sudoku_cells, "Test")
  
end

def prepare_sudoku_cells(sudoku_datas)
  sudoku_cells = []
  sudoku_datas.each_with_index do |row, index_r|
    cell_row = []
    row.each_with_index do |value, index_c|
      cell_row << Cell.new(index_r, index_c, value)
    end
    sudoku_cells << cell_row
  end
  sudoku_cells
end

def user_interface
  go_play = true
  # files = ['sudoku1.csv', 'sudoku2.csv']
  # batch_file = 'easy-sudokus.csv'
  progress = 0 # keeping track of the game
  puts `clear`
  until go_play != true
    # puts "I'm here!!"
    
    input = Gui.display_option1
    if input == '1'
     
      play
      progress += 1
    elsif input == '2'
      # ask user for a file name
      print 'Please, enter the csv filename: '
      filename = STDIN.gets.strip
      solve(filename)

    elsif input == '9'
      # quit
      go_play = false
    else
      puts "We don't offer any other option.  Please, try again."
    end
  end
end

def play
  files = ['sudoku1.csv', 'sudoku2.csv', 'sudoku3.csv']

  file = Gui.difficulty_level-1 #Random.rand(0..(files.size - 1)) # keeping track of the game

  # play game
  sudoku_datas = FileManipulator.load_sudoku_from_file(files[file])
  sudoku_cells = prepare_sudoku_cells(sudoku_datas)

  solution = solve_a_sudoku(sudoku_datas)
  if !solution
    puts "The software is not quite ready to handle this puzzle yet."
    puts "Either that or the puzzle is unsolvable."
    return false
  end

  until solved(sudoku_cells)
    # puts `clear`
    display_sudoku(sudoku_cells, "Sudoku Master Challenge ##{file + 1}")
    input_values = Gui.cell_input_display # gets.strip.split(' ').map {|val| val.to_i}
    if !(!input_values.grep_v(1..9).empty? || input_values.size != 3)

      sudoku_cells[input_values[0] - 1][input_values[1] - 1].value = input_values[-1].to_i
    elsif input_values.count(0) == 3
      display_sudoku(solution, "Solution to Challenge ##{file + 1}")
      break
    else
      puts "You've entered some invalid datas.  Try again."
    end
  end
  result = solved(sudoku_cells)
  if result
    Gui.congratulate
    puts 'You have successfully completed your challenge.'
  end
end

def solve(filename)
  if File.exist?(filename)
    cell_values2 = FileManipulator.load_sudoku_from_file(filename)
    # print out the solution
    result = solve_a_sudoku(cell_values2)
    
    if !result
      puts "I can't solve this puzzle."
      return false
    end
    display_sudoku(result, 'Solved by Sudoku Master (programmed by Jack Toke)')
  else
    puts 'Invalid filename.  Please, try again later.'
  end
end

input_array, *the_rest = ARGV

# binding.pry

if input_array.nil?
  # user_interface
  # puts "I'm here"
  
  user_interface
elsif input_array.downcase == 'play'
  # play
  puts "Let's play"
  play
elsif input_array.downcase == 'solve'
  if !the_rest.empty?
    # puts "Let's solve: #{the_rest}"
    if File.exist?(the_rest[0])
      # call the method to solve the sudoku
      # puts 'Call the Solve method here.'
      solve(the_rest[0])
    else
      puts "Sudoku Master couldn't find the file you've specified."
    end
  else
    puts 'A filename is expected. Eg. sudoku.csv'
  end
elsif input_array.downcase == 'test'

  # play game
  sudoku_datas = FileManipulator.load_sudoku_from_file("easy-game-1.csv")
  sudoku_cells = prepare_sudoku_cells(sudoku_datas)
  temp_test(sudoku_datas)
end
