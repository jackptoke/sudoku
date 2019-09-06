Programmer: Jack Toke
Github link: [git@github.com:jackptoke/sudoku.git](https://github.com/jackptoke/sudoku)

#Sudoku Master
<img src="images/sudoku.png"
     alt="Sudoku Master"
     style="width: 150px;" />

#Installation
- Clone the repo
```
git clone git@github.com:jackptoke/sudoku.git
```
- CD into the directory
```
cd sudoku
```
- Run the build shell
```
gems install terminal-table
gems install colorize
gems install artii
gems install pry
```
- Run the following command
```
ruby game.rb
#ruby game.rb play
#ruby game.rb solve sudoku1.csv
#the file must be in the correct format
```


##The Background of Sudoku
Sudoku is a number puzzle.  According the best source of knowledge, *"Wikipedia"*, it was first appeared in a French newspaper in 1979.
<img src="images/sudoku.jpg"
     alt="Sudoku Master"
     style="width: 250px;" />
But it only became mainstream in 1986 by the Japanese puzzle company Nikoli, under the name, Sudoku, meaning **"single number"**.

The puzzle has **9x9** grid with digits so that each column, each row and each of the 9 3x3 subgrids that compose the grid contains all the number from 1 to 9.  The setter provides a partially completed grid, which has only one solution.

#Objective of Sudoku Master
<img src="./images/first1-screen.jpg"
     alt="Sudoku Master"
     style="width: 350px;" />
Sudoku Master is a simple app created to solve any sudoku.  It also allows user to have fun playing it as well.

###Play a game
Once you've chosen to have a game by keying ***1***, the program will take you to the following screen, allowing you to choose the level of difficulty - _easy, intermediate and expert_.
<img src="./images/play-option-screen.jpg"
     alt="Sudoku Master"
     style="width: 350px;" />
After you choose the level of difficulty, it take you to the third screen, allowing you to enter the value of the cells.  The valid syntax for the values is: *ROW* space *COLUMN* space *VALUE*.  Eg. 1 2 5, representing the 1st row, 2nd column and the value is 5.
>1 2 5
<img src="./images/play-screen.jpg"
     alt="Sudoku Master"
     style="width: 350px;" />
The game will only stop when you have successfully attempted the puzzle.  But if you desire to give up half-way, you can just type _0 0 0_  seperated by a space.  It will show you the solution to the puzzle after that.
>0 0 0
<img src="./images/solution-screen.jpg"
     alt="Sudoku Master"
     style="width: 350px;" />

###Solve a sudoku puzzle from a given file name.
If you desire to just use the app to solve any sudoku puzzle, you could opt for a 2nd option.  It will ask you for a filename.  
<img src="./images/solve-screen.jpg"
     alt="Sudoku Master"
     style="width: 350px;" />
The file must be a csv or txt file, but in a _very specific_ format, as shown below.  It doesn't expect any other format.
<img src="./images/game-data-format.jpg"
     alt="Sudoku Master"
     style="width: 350px;" />
If you've given it the correct file, it will attempt to solve it and display you the solution afteward.
<img src="./images/sudoku-solution.jpg"
     alt="Sudoku Master"
     style="width: 350px;" />
##Strategies
There are three strategies that anyone could use to conquer any sudoku puzzles.  I'll briefly explain the strategy with the help of some images.
###Strategy #1
**Step One**: Build up a list of potential values for each cell.
<img src="./images/strategy1-1.jpg"
     alt="Sudoku Master"
     style="width: 350px;" />
**Step Two**: Iterate throught each cells that don't have a value already, and shed off their potential list of values, as the values are found in the same row, column or subgrid.
<img src="./images/strategy1-2b.jpg"
     alt="Sudoku Master"
     style="width: 350px;" />
**Step Three**: Once you do that you will find that some cells will have their potential list of values drop down to one.  Update those values.
<img src="./images/strategy1-3.jpg"
     alt="Sudoku Master"
     style="width: 350px;" />
**Step 4**: If the game is not solved, repeat 1-3.
 
This algorithm is sufficient to tackle most of the easy puzzle. For more difficult puzzles, the next two strategies may come handy.
**Building a list of potential values**
```
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
```
**Shed off the numbers that area already on the grid**
```#shed 
def shed_potential_value_list(cells)
  cells.each do |row|
    row.each do |cell|
      #all cell except the fixed one
      if !cell.is_fixed  #fixed cells are provided by the game setter
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
```
**Once cells are shed the cells must be updated to reflect the change**
```
#evaluate and update
#for every cell that only have one potential value
#give the cell the value
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
```
###Strategy #2
In order to solve a more advanced puzzle, the program will need to find two/three cells in the same row, column or subgrid that has the same potential values.  If such cells are found, all other cells in the same row, column or subgrid can remove those values in their potential values lists.
**Step 1: Look for two cells in the same row, column or subgrid with exactly two potential values that are the same.
<img src="./images/strategy2-2c.jpg"
     alt="Sudoku Master"
     style="width: 350px;" />
**Step 2:  Shed of those values in their respective row, column or subgrid.  Once you have done that, you'll see a few cells reduced the size of their potential value list to just one.
<img src="./images/strategy2-3a.jpg"
     alt="Sudoku Master"
     style="width: 350px;" />
**Step 3:  Update those cells values and go back to strategy 1 and back to strategy 2.

```
#Look for two or three cells in the same row, column or subgrid
#that have exactly the same values in their potential value lists
#if such cells are found, remove those values in all other cells 
#that are not one of those cells
def double_or_triple_whammer(sudoku_cells)
  #1. obtain the lists of cells that still need a value
  #2. for each cell in the list look for other cells
  #   which are in the same row, column or subgrid
  #   that has the same potential values
  #3. if such cells are found, remove from other 
  #   cells all those values from them
end
```
###Strategy 3
If a number already appears on two sub-grids on the same row or column, then that number will appear on the remaining row/column that doesn't have the number, provided that the number is in the potential value list of a remaining cell but not the other or it's the only available slot.
**Step 1: Search for two cells in the different subgrids that are on the same row or column that has the same number.  
<img src="./images/strategy3-a.jpg"
     alt="Sudoku Master"
     style="width: 350px;" />
**Step 2: Check if the other subgrid on the same row or column, cells that you can safely insert the number. If it doesn't go into conflict with any other existing cells, then make the change.
**Step 3:  Go back to strategy 1, strategy and repeat the process.
#GUI Flowchart
<img src="./images/flowchart.jpg"
     alt="Sudoku Master"
     style="width: 550px;" />

##Tool Used to help with the project
###Trellow:
[Trello](https://trello.com/b/SPnuI36h/build-sudoku-terminal-app)
<img src="./images/trello.jpg"
     alt="Sudoku Master"
     style="width: 650px;" />
###Google Diagram:
[GUI Flowchart](https://docs.google.com/drawings/d/1pRHW2w3wrARL9nAGgxlk_ODcHgAH5fsgAIxwANbcPj4/edit?usp=sharing)

#Conclusion
A lot of fun learning Ruby language.  I have fallen in love with it.  Coming from a Java, C++ background, it is a much simpler language to master but has a lot of cool feature.
I also have learnt the benefits of GitHub.  I messed up my code on Wednesday night and was stressing out big time.  Fortunately, I was able to clone what I have pushed earlier.  It was a precious lesson, fortunately not too much at the cost.

##Future Improvement
There are a few improvements I would to add.
1. A more user friendly GUI to play the game.  One that is a bit more interactive.
2. A better algorithm to solve the puzzle.  This will need a bit more than 3 days to achieve.

