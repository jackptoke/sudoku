#Development Log
##Day 1 - Monday 2nd September, 2019
Initially, I was thinking of doing a game of Black Jack.  On the way back home on the train, I started drafting the class design and overview structure and outline the rules of the game. 

##Day 2 - Tuesday 3rd September, 2019
After a bit more thinking, I've decided to change to attempting a more challenging app, Sudoku solver.
I have 3 stretagies to solve the problem, but I didn't think I would need all three of them.  By noon, I've solved the problem, by implementing the first strategy. (At least that what I thought at the time.)

Started working on the GUI and tried to figure out how to display the Sudoku.

Started to play around with TTY Box and TTY Table.  It looked promising.

##Day 3 - Wednesday 4th September, 2019
Decided to ditch the TTY Box and TTY Table for a much simpler GEMS, Terminal-Table.

I was happy with Terminal Table, but I couldn't get it to display square grids, as it only allowed me to set the width of the grid, not the height.

By the afternoon, I was trying to implement the different levels of difficulty.  I have done git commit and went on to make changes.  By the evening, I thought I have completed the change and attempt to intergrate the new method into the rest of the codes.

I wanted to include more game options for the different level of difficulties.  I went on the internet to download some 90 sokudu games to include into mine.

I ended up writing a bunch of methods just to process the data into the format that my code can comprehend it.

After all that, the program went into an infinite loop.  I wasn't sure what to make of it. Many thing could have gone wrong.  May be it's my new methods, may be it's the data format (string vs integer).  May be it's my previous methods that was already working.  

I went on to make changes here, there and everywhere.  By midnight, I couldn't figure out what went wrong.


##Day 4 - Thursday 5th September, 2019
By now, I decided the best thing to do is to clone the git repositery I committed the day before, before all these messes. I did just that.

I was a bit disappointed.  Disheartened but the spirit is not broken.

I did more rigorous test on my old methods before the mess and they all seemed to be performing the task correctly.  I loaded the first few games, and tested them and everything was fine.  Then I manually entered the data from the files I downloaded to make sure that everything is in the right format.  As soon as I loaded that, the program went into infinite loop.  I loaded the old games and everything was fine.  Reloaded the new games and everything came crashing down.

So I questioned the new data and set out to manually solving a few of them.  They were solvable.  Then I knew there is a loop hole in my algorithm.

I realized that strategy 1 alone is not sufficient, I will need to implement the rest of the strategy. 

But I have a time constraint.

I decided to not implement the other two strategies until I have done some of the documentations and other tasks that needed my immediate attention. Instead, I fixed up my GUI and makes it look a bit prettier.

On the way back home on V-line, I couldn't help myself to try to implement strategy 2.  I started it, but couldn't finish it.

##Day 5 - Friday 6th September, 2019
I have finished implementing the code from the pseudo-codes, but upon some testing, there are bugs in there.  But I don't have time to clean it up.

I will just focus on the documentation now, and will come back to it later to fix it up.

