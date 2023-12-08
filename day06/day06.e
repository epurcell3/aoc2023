note
	description: "Code for Advent of Code Day 6"
	author: "Edd Purcell"
	date: "$Date$"

class
	DAY06

inherit
	DAY redefine parse end

create
	make

feature {NONE} -- Initialization

	make
		do
			process
		end

	-- to parse:
        -- Time:        54     94     65     92
        -- Distance:   302   1476   1029   1404
	parse
		local
			times: LINKED_LIST [INTEGER_64]
			curr_number: STRING
			new_race: TUPLE [INTEGER_64, INTEGER_64]
		do
			create times.make
			curr_number := ""
			across lines.first.linear_representation as c
			loop
				if curr_number.count /= 0 and not c.item.is_digit then
					times.extend (curr_number.to_integer_64)
					curr_number := ""
				elseif c.item.is_digit then
					curr_number.append_character (c.item)
				end
			end
			times.extend (curr_number.to_integer_64)
			curr_number := ""
			create races.make
			times.start
			across lines.last.linear_representation as c
			loop
				if curr_number.count /= 0 and not c.item.is_digit then
					create new_race
					new_race.put (times.item, 1)
					times.remove
					new_race.put (curr_number.to_integer_64, 2)
					races.extend (new_race)
					curr_number := ""
				elseif c.item.is_digit then
					curr_number.append_character (c.item)
				end
			end
			create new_race
			new_race.put (times.item, 1)
			times.remove
			new_race.put (curr_number.to_integer_64, 2)
			races.extend (new_race)

			parse_part2_race
		end
	
	parse_part2_race
		local
			time: INTEGER_64
			buffer: STRING
		do
			buffer := ""
			across lines.first.linear_representation as c
			loop
				if c.item.is_digit then
					buffer.append_character (c.item)
				end
			end
			time := buffer.to_integer_64
			buffer := ""
			across lines.last.linear_representation as c
			loop
				if c.item.is_digit then
					buffer.append_character (c.item)
				end
			end
			create actual_race
			actual_race.put (time, 1)
			actual_race.put (buffer.to_integer_64, 2)
		end
	
	-- [time, record]
	races: LINKED_LIST [TUPLE [INTEGER_64, INTEGER_64]]
	actual_race: TUPLE [INTEGER_64, INTEGER_64]

feature {ANY} -- operations
	part_1: INTEGER_64
		do
			Result := 1
			across races as r
			loop
				Result := Result * 
					leeway (
						quadratic_factors (
							r.item.integer_64_item (1),
							r.item.integer_64_item(2)))
			end
		end
	part_2: INTEGER_64
		do
			Result := leeway (
				quadratic_factors (
					actual_race.integer_64_item (1),
					actual_race.integer_64_item (2)))
		end

feature {NONE} -- part 1
	quadratic_factors (time: INTEGER_64; distance: INTEGER_64): TUPLE [INTEGER_64, INTEGER_64]
		local
			t, sqrt: REAL_64
		do
			t := time.to_double
			sqrt := (t.power (2) - (4 * distance.to_double)).power (0.5)
			create Result
			Result.put ((((t + sqrt) / 2) - 1).ceiling_real_64.truncated_to_integer_64, 1)
			Result.put ((((t - sqrt) / 2) + 1).floor_real_64.truncated_to_integer_64, 2)
		end

	leeway (factors: TUPLE [INTEGER_64, INTEGER_64]): INTEGER_64
		do
			Result := factors.integer_64_item (1) - factors.integer_64_item (2) + 1
			-- print (factors.integer_64_item (1).out + " - " + factors.integer_64_item (2).out + " + 1 = " + Result.out + "%N")
		end

feature {NONE} -- part 2
end
