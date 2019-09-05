# frozen_string_literal: true

require_relative 'game'
require_relative 'file_manipulator'

# solve
solve('sudoku2.csv')
# play
# play
puts "Test: FileManipulator.load_sudoku_from_file"
datas = FileManipulator.load_sudoku_from_file('sudoku2.csv')

##printing the content from a file
datas.each do |row|
  row.each do |cell|
    print "#{cell} "
  end
  puts
end

puts "Test: FileManipulator.load_sudoku_from_file with BAD datas"
bad_datas = FileManipulator.load_sudoku_from_file('bad-datas.csv')
puts "Test: prepare_sudoku_cells"
cells = prepare_sudoku_cells(datas)
cells.each do |row|
  row.each do |cell|
    print "#{cell.value} "
  end
  puts
end

puts "Test: build_potential_value_list"
puts "Before:"
cells.each do |row|
  row.each do |cell|
    print cell.potential_value_stack
  end
  puts
end
build_potential_value_list(cells)
puts "After: build_potential_value_list and before update_cells and shed_potential_value_list"
cells.each do |row|
  row.each do |cell|
    p cell.potential_value_stack
  end
  puts
end
puts "Test: shed_potential_value_list and update_cells "
puts "Before:"
cells.each do |row|
  row.each do |cell|
    p cell.potential_value_stack
  end
  puts
end
update_cells(cells)
shed_potential_value_list(cells)
update_cells(cells)
puts "After: update_cells and shed_potential_value_list"
cells.each do |row|
  row.each do |cell|
    p cell.potential_value_stack
  end
  puts
end
puts "Repeat Test: shed_potential_value_list and update_cells "
update_cells(cells)
shed_potential_value_list(cells)
update_cells(cells)
puts "After:  shed_potential_value_list and update_cells "
cells.each do |row|
  row.each do |cell|
    p cell.potential_value_stack
  end
  puts
end