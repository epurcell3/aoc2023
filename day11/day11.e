note
	description: "Code for Advent of Code Day 11"
	author: "Edd Purcell"
	date: "$Date$"
class
	DAY11
inherit
	DAY
		redefine parse end
create
	make

feature {NONE} -- Initialization

	make
		do
			process
		end
	parse
		local
			x, y: INTEGER
			new_point: POINT
			filled_rows, filled_cols: BINARY_SEARCH_TREE_SET [INTEGER]
		do
			create galaxies.make
			create filled_rows.make
			create filled_cols.make
			y := 1
			across lines as l
			loop
				x := 1
				across l.item.linear_representation as c
				loop
					if c.item = '#' then
						create new_point.make (x, y)
						galaxies.extend (new_point)
						filled_rows.extend (y)
						filled_cols.extend (x)
					end
					x := x + 1
				end
				y := y + 1
			end
			empty_rows := find_empties (filled_rows)
			empty_cols := find_empties (filled_cols)
		end
	
	find_empties (filled: COMPARABLE_STRUCT [INTEGER]): SET [INTEGER]
		local
			empties: LINKED_SET [INTEGER]
			i: INTEGER
		do
			create empties.make
			from
				i := filled.min
			until
				i > filled.max
			loop
				if not filled.has (i) then
					empties.extend (i)
				end
				i := i + 1
			end
			Result := empties
		end


	
	empty_rows: SET [INTEGER]
	empty_cols: SET [INTEGER]
	
	galaxies: LINKED_LIST [POINT]

feature {ANY} -- operations
	part_1: INTEGER
		local
			i, j: INTEGER
		do
			Result := 0
			from i := 1 until i > galaxies.count
			loop
				from j := i + 1 until j > galaxies.count
				loop
					Result := Result + manhattan_w_growth (galaxies.at (i), galaxies.at (j), 1)
					j := j + 1
				end
				i := i + 1
			end
		end
	part_2: INTEGER_64
		local
			i, j: INTEGER
		do
			Result := 0
			from i := 1 until i > galaxies.count
			loop
				from j := i + 1 until j > galaxies.count
				loop
					-- they're 1MM times larger, but one already exists
					Result := Result + manhattan_w_growth (galaxies.at (i), galaxies.at (j), 999999)
					j := j + 1
				end
				i := i + 1
			end
		end

feature {NONE} -- part 1
	manhattan_w_growth (p1: POINT; p2: POINT; steps: INTEGER): INTEGER
		do
			Result := p1.manhattan (p2)
			--print (p1.out + "->" + p2.out + " = " + Result.out + " ( ")
			Result := Result + (empties_between (p1.x, p2.x, empty_cols) * steps)
			--print (Result.out + " & ")
			Result := Result + (empties_between (p1.y, p2.y, empty_rows) * steps)
			--print (Result.out + ")%N")
		end

	empties_between (p1: INTEGER; p2: INTEGER; empties: SET [INTEGER]): INTEGER
		local
			min, max: INTEGER
		do
			min := p1.min (p2)
			max := p1.max (p2)
			across empties as e
			loop
				if min < e.item and e.item < max then
					Result := Result + 1
				end
			end
		end

feature {NONE} -- part 2
end
