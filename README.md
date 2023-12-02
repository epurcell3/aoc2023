# Advent of Code 2023!

## To Run

Question: Are you sure?

If you are for some reason, get EiffelStudio (at least 23.09) from [here](https://account.eiffel.com/downloads).
Follow the instructions to install EiffelStudio and set the right environment
values that it wants. At this point, you should have a working compiler and
build tooling.

To run a particular day's solution, first run `ec -config dayXX/dayXX.ecf`,
which should create a folder along the lines of `EFIGENs/dayXX/W_code`. `cd` to
that folder and run `finish_freezing` [another tool for Eiffel] to generate the
actual executable from the generated C code. The executable should be named
`aoc2023-XX`.

Finally, run the executable and pass in the path to the input file for that day.

Congrats! You made it!

### From the GUI

Like GUI IDEs and don't want to run code directly? Finish installing the IDE
completely, and pray I didn't mangle the configurations too much for it.
Godspeed, you'll need it.
