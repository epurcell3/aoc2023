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
	part_2: INTEGER
		local
			np: LIST [STRING]
		do
			Result := 0
			across symbols as symbol
			loop
				if is_possible_gear (symbol.item) then
					np := neighboring_parts (symbol.key)
					if np.count = 2 then
						Result := Result + (
							np.at (1).to_integer *
							np.at (2).to_integer)
					end
				end
			end
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
	-- a '*' symbol
	is_possible_gear (symbol: CHARACTER): BOOLEAN
		do
			Result := symbol = '*'
		end
	
	within (origin: INTEGER; point: INTEGER; threshold: INTEGER): BOOLEAN
		local t: INTEGER
		do
			t := origin - point
			Result := t.abs <= threshold
		end

	neighboring_parts (symbol_point: TUPLE [INTEGER, INTEGER]): LIST [STRING]
		local
			res: LINKED_LIST [STRING]
		do
			create res.make
			across numbers as number
			loop
				-- heuristic to only dig into closer numbers
				-- within 3 spaces in x
				-- within 1 spaces in y
				if
					within (
						symbol_point.integer_32_item (1),
						number.key.integer_32_item (1),
						3) and
					within (
						symbol_point.integer_32_item (2),
						number.key.integer_32_item (2),
						1) and
					across neighbors (number.key) as n
						some n.item.is_equal (symbol_point) end then
					res.extend (number.item)
				end
			end

			Result := res
		end
end
