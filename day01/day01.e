note
	description: "Code for Advent of Code Day 1"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DAY01

inherit
	DAY

create
	make

feature {NONE} -- Initialization

	make
		do
			process
		end

feature {ANY} -- operations
	part_1: INTEGER
		local data: LINKED_LIST [STRING]
		do
			Result := 0
			create data.make
			data.deep_copy (lines)
			across data as ic
			loop
				Result := Result + ((first_digit (ic.item).out.to_integer) * 10) + last_digit (ic.item).out.to_integer
			end
		end
	part_2: INTEGER
		local data: LINKED_LIST [STRING]
		do
			Result := 0
			create data.make
			data.deep_copy (lines)
			across data as ic
			loop
				Result := Result + (first_digit2 (ic.item) * 10) + last_digit2 (ic.item)
			end
		end

feature {NONE} -- helpers
	clear_alpha (line: STRING): STRING
		local
			i: INTEGER
		do
			Result := ""
			from
				i := 1
			until
				i > line.count
			loop
				if (line @ i).is_digit then
					Result.append_character (line @ i)
				end
				i := i + 1
			end
		end

	first_digit (line: STRING): CHARACTER
		do
			Result := clear_alpha (line) @ 1
		end

	last_digit (line: STRING): CHARACTER
		local
			s: STRING
		do
			s := clear_alpha (line)
			Result := s @ s.count
		end

feature {NONE}
	-- Part 2 specific
	first_real_digit_index (line: STRING): INTEGER
		local
			i: INTEGER
		do
			from
				i := 1
			until
				Result /= 0
			loop
				if (line @ i).is_digit then
					Result := i
				end
				i := i + 1
			end
		end

	first_digit2 (line: STRING): INTEGER
		local
			mindex, tmp: INTEGER
		do
			mindex := first_real_digit_index (line)
			Result := line.at (mindex).out.to_integer
			tmp := line.fuzzy_index ("one", 1, 0)
			if tmp /= 0 and tmp < mindex then
				mindex := tmp
				Result := 1
			end
			tmp := line.fuzzy_index ("two", 1, 0)
			if tmp /= 0 and tmp < mindex then
				mindex := tmp
				Result := 2
			end
			tmp := line.fuzzy_index ("three", 1, 0)
			if tmp /= 0 and tmp < mindex then
				mindex := tmp
				Result := 3
			end
			tmp := line.fuzzy_index ("four", 1, 0)
			if tmp /= 0 and tmp < mindex then
				mindex := tmp
				Result := 4
			end
			tmp := line.fuzzy_index ("five", 1, 0)
			if tmp /= 0 and tmp < mindex then
				mindex := tmp
				Result := 5
			end
			tmp := line.fuzzy_index ("six", 1, 0)
			if tmp /= 0 and tmp < mindex then
				mindex := tmp
				Result := 6
			end
			tmp := line.fuzzy_index ("seven", 1, 0)
			if tmp /= 0 and tmp < mindex then
				mindex := tmp
				Result := 7
			end
			tmp := line.fuzzy_index ("eight", 1, 0)
			if tmp /= 0 and tmp < mindex then
				mindex := tmp
				Result := 8
			end
			tmp := line.fuzzy_index ("nine", 1, 0)
			if tmp /= 0 and tmp < mindex then
				mindex := tmp
				Result := 9
			end
		end

	last_digit2 (line: STRING): INTEGER
		local
			mindex, tmp: INTEGER
			mirror: STRING
		do
			mirror := line.twin
			mirror.mirror
			mindex := first_real_digit_index (mirror)
			Result := mirror.at (mindex).out.to_integer
			tmp := mirror.fuzzy_index ("eno", 1, 0)
			if tmp /= 0 and tmp < mindex then
				mindex := tmp
				Result := 1
			end
			tmp := mirror.fuzzy_index ("owt", 1, 0)
			if tmp /= 0 and tmp < mindex then
				mindex := tmp
				Result := 2
			end
			tmp := mirror.fuzzy_index ("eerht", 1, 0)
			if tmp /= 0 and tmp < mindex then
				mindex := tmp
				Result := 3
			end
			tmp := mirror.fuzzy_index ("ruof", 1, 0)
			if tmp /= 0 and tmp < mindex then
				mindex := tmp
				Result := 4
			end
			tmp := mirror.fuzzy_index ("evif", 1, 0)
			if tmp /= 0 and tmp < mindex then
				mindex := tmp
				Result := 5
			end
			tmp := mirror.fuzzy_index ("xis", 1, 0)
			if tmp /= 0 and tmp < mindex then
				mindex := tmp
				Result := 6
			end
			tmp := mirror.fuzzy_index ("neves", 1, 0)
			if tmp /= 0 and tmp < mindex then
				mindex := tmp
				Result := 7
			end
			tmp := mirror.fuzzy_index ("thgie", 1, 0)
			if tmp /= 0 and tmp < mindex then
				mindex := tmp
				Result := 8
			end
			tmp := mirror.fuzzy_index ("enin", 1, 0)
			if tmp /= 0 and tmp < mindex then
				mindex := tmp
				Result := 9
			end
		end
end
