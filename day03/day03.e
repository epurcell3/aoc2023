note
	description: "Code for Advent of Code Day 3"
	author: "Edd Purcell"
	date: "2023/12/03"

class
	DAY03

inherit
	DAY redefine parse end

create
	make

feature {NONE} -- Initialization

	make
		do
			create symbols.make (1024)
			create numbers.make (1024)
			process
		end
	
	parse
		local 
			x, y, t: INTEGER
			item: CHARACTER
		do
			y := 0
			across lines as l
			loop
				from
					x := 1
				until
					x > l.item.count
				loop
					item := l.item.at (x)
					if not item.is_digit and item /= '.' then
						symbols.extend (item, [x, y])
					end
					if item.is_digit then
						t := find_end_number (l.item, x)
						numbers.extend (l.item.substring(x, t), [x, y])
						x := t
					end
					x := x + 1
				end
				y := y + 1
			end
		end

	find_end_number (line: STRING; start: INTEGER): INTEGER
		do
			from
				Result := start
			until
				not line.at (Result).is_digit
			loop
				Result := Result + 1
			end
			Result := Result - 1
		end

feature {NONE} -- properties
	symbols: HASH_TABLE [CHARACTER, TUPLE [INTEGER, INTEGER]]
	numbers: HASH_TABLE [STRING, TUPLE [INTEGER, INTEGER]]

feature {ANY} -- operations
	-- find the sum of all numbers that aren't "part numbers", i.e. numbers not
	-- adjacent to a symbol
	part_1: INTEGER
		do
			Result := 0
			across numbers as number
			loop
				if across neighbors (number.key) as n
					some symbols.has_key (n.item) end then
					Result := Result + number.item.to_integer
				end
			end
		end

	-- Sum of all "gear ratios": the result of multipying the two part numbers
	-- attached to a gear together
	part_2: ANY
		do
			Result := "TBD"
		end

feature {NONE} -- part 1
	neighbors (number_start: TUPLE [INTEGER, INTEGER]): LIST [TUPLE [INTEGER, INTEGER]]
		local
			i, x_start, x_end: INTEGER
			res: LINKED_LIST [TUPLE [INTEGER, INTEGER]]
		do
			x_start := number_start.integer_32_item (1) - 1
			x_end := number_start.integer_32_item (1) + numbers.definite_item (number_start).count
			create res.make
			res.extend ([x_start, number_start.integer_32_item (2)])
			res.extend ([x_end, number_start.integer_32_item (2)])
			from
				i := x_start
			until
				i > x_end
			loop
				res.extend([i, number_start.integer_32_item (2) - 1])
				res.extend([i, number_start.integer_32_item (2) + 1])
				i := i + 1
			end
			Result := res
		end

feature {NONE} -- part 2
	-- a '*' symbol that is adjacent to exactly 2 part numbers
	is_gear (symbol_start: TUPLE [INTEGER, INTEGER]): BOOLEAN
		do
			Result := symbols.definite_item (symbol_start) = '*'

		end
end
