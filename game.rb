require_relative 'cell'
require 'terminal-table'
require_relative 'file_manipulator'
require 'colorize'
require 'colorized_string'
require_relative 'GUI'

include FileManipulator
include GUI

#loading datas from files
cell_values1 = FileManipulator.load_sudoku_from_file("sudoku1.csv")
cell_values2 = FileManipulator.load_sudoku_from_file("sudoku2.csv")

#build the possible values of each cell
def build_potential_value_list(cells)
  cells.each do |row|
    row.each do |cell|
      #all cell except the fixed one
      if !cell.is_fixed
        cell.potential_value_stack = [1, 2, 3, 4, 5, 6, 7, 8, 9]
        
        #for each cell in the vertical
        cell.vertical_family.each do |c|
          cell.potential_value_stack.delete_if {|value| value == cells[c[0]][c[1]].value}
        end
        cell.horizontal_family.each do |c|
          cell.potential_value_stack.delete_if {|value| value == cells[c[0]][c[1]].value}
        end
        cell.block_family.each do |c|
          cell.potential_value_stack.delete_if {|value| value == cells[c[0]][c[1]].value}
        end
      end
    end
  end
end

#shed 
def shed_potential_value_list(cells)
  cells.each do |row|
    row.each do |cell|
      #all cell except the fixed one
      if !cell.is_fixed
        #for each cell in the vertical
        cell.vertical_family.each do |c|
          cell.potential_value_stack.delete_if {|value| value == cells[c[0]][c[1]].value}
        end
        cell.horizontal_family.each do |c|
          cell.potential_value_stack.delete_if {|value| value == cells[c[0]][c[1]].value}
        end
        cell.block_family.each do |c|
          cell.potential_value_stack.delete_if {|value| value == cells[c[0]][c[1]].value}
        end
      end
    end
  end
end

#evaluate and update
def update_cells(cells)
  cells.each do |row|
    row.each do |cell|
      #all cell except the fixed one
      if (!cell.is_fixed) && cell.potential_value_stack.size == 1
        cell.value = cell.potential_value_stack.pop
      end
    end
  end
end

#display the cells
def display_sudoku(cells, title)
  
  rows = []
  cells.each do |row|
    temp_row = []
    row.each do |cell|
      temp_row << {:value => cell.value, :alignment => :center}
    end
    rows << temp_row
  end

  table2 = Terminal::Table.new :title => title, :rows => rows, :style => {:width => 55, :all_separators => true }
 
  puts table2

end

#solve the sudoku
def is_solved(cells)
  solved = true
  
  cells.each do |row|
    row.each do |cell|
      #all cell except the fixed one
      if cell.value == 0
        return false
      end
    end
  end
  
  return solved
end

#The function will solve a sudoku from a given filename
def solve_a_sudoku(sudoku_datas)

  sudoku_cells = prepare_sudoku_cells(sudoku_datas)
  #display_sudoku(sudoku_cells, "Sudoku to solve")
  #build the potential list of values for each cell
  build_potential_value_list(sudoku_cells)
  update_cells(sudoku_cells)  #update the value of each cell
  counter = 0
  #continue to the try to solve
  #if the counter goes beyond a million
  #it's probably a bad sudoku
  while !is_solved(sudoku_cells) # 
    shed_potential_value_list(sudoku_cells)
    update_cells(sudoku_cells)
    counter += 1
  end
  return sudoku_cells
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
  play = true
  files = ['sudoku1.csv', 'sudoku2.csv']
  batch_file = 'easy-sudokus.csv'
  progress = 0  #keeping track of the game

  #print 'Welcome to '
  until play != true do
    
    input = GUI.display_option1

    if input == '1'
      #play game
      sudoku_datas = FileManipulator.load_sudoku_from_file(files[progress])
      sudoku_cells = prepare_sudoku_cells(sudoku_datas)
      
      solution = solve_a_sudoku(sudoku_datas)
      while !is_solved(sudoku_cells)
        # puts `clear`
        display_sudoku(sudoku_cells, "Sudoku Challenge ##{progress+1}")
        input_values = GUI.cell_input_display #gets.strip.split(' ').map {|val| val.to_i}
        if !(input_values.grep_v(1..9).size > 0 || input_values.size != 3)

          sudoku_cells[input_values[0] - 1][input_values[1] - 1].value = input_values[-1].to_i
        elsif input_values.count(0) == 3
          display_sudoku(solution, "Solution to Challenge ##{progress+1}")
          break
        else
          puts "You've entered some invalid datas.  Try again."
        end
      end
      if is_solved(sudoku_cells)
        GUI.congratulate
        puts 'You have successfully completed your challenge.'
      end
      progress += 1
    elsif input == '2'
      #ask user for a file name
      print 'Please, enter the csv filename: '
      filename = gets.strip
      if File.exist?(filename)
        cell_values2 = FileManipulator.load_sudoku_from_file(filename)
        #print out the solution
        result = solve_a_sudoku(cell_values2)
        puts `clear`
        display_sudoku(result, "Solved by Sudoku Solver (programmed by Jack Toke)")
      else
        puts 'Invalid filename.  Please, try again later.'
      end
      
    elsif input == '9'
      #quit
      play = false
    else
      puts "We don't offer any other option.  Please, try again."
    end
  end
end

user_interface