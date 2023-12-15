note
	description: "Code for Advent of Code Day 13"
	author: "Edd Purcell"
	date: "$Date$"

class
	DAY13

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
			row_map: LINKED_LIST [STRING]
			col_map: LINKED_LIST [STRING]
			i: INTEGER
		do
			create row_maps.make
			create row_map.make

			create col_maps.make
			create col_map.make
			across lines as lc
			loop
				if lc.item.is_equal("") then
					row_maps.extend (row_map)
					create row_map.make
					col_maps.extend (col_map)
					create col_map.make
				else
					row_map.extend (lc.item)
					i := 1
					across lc.item.linear_representation as cc
					loop
						if col_map.count >= i then
							col_map.at (i).append_character (cc.item)
						else
							col_map.extend (cc.item.out)
						end
						i := i + 1
					end
				end
			end
			row_maps.extend (row_map)
			col_maps.extend (col_map)
		end

	row_maps: LINKED_LIST [LIST [STRING]]
	col_maps: LINKED_LIST [LIST [STRING]]


feature {ANY} -- operations
	part_1: INTEGER
		local
			n: INTEGER
			new_reflection: TUPLE [INTEGER, BOOLEAN]
		do
			create p1_reflections.make (row_maps.count)
			across row_maps as rc
			loop
				n := find_reflection (rc.item, 1.5, agent simple_check)
				if n /= 0 then
					create new_reflection
					new_reflection.put (n, 1)
					new_reflection.put (true, 2)
					p1_reflections.put (new_reflection, rc.cursor_index)
					Result := Result + 100 * n
				end
			end
			across col_maps as cc
			loop
				n := find_reflection (cc.item, 1.5, agent simple_check)
				if n /= 0 then
					create new_reflection
					new_reflection.put (n, 1)
					new_reflection.put (false, 2)
					p1_reflections.put (new_reflection, cc.cursor_index)
					Result := Result + n
				end
			end
		end
	part_2: INTEGER
		local
			n, ref: INTEGER
		do
--			across p1_reflections.current_keys as kc
--			loop
--				if kc.item /= 12 then
--					p1_reflections.remove (kc.item)
--				end
--			end
			across p1_reflections as refc
			loop
				if refc.item.boolean_item (2) then
					ref := refc.item.integer_32_item (1)
				else
					ref := -1
				end
				n := find_different_reflection (row_maps.at (refc.key), ref)
				if n /= 0 and smudges /= 0
				then
					Result := Result + 100 * n
				else
					if not refc.item.boolean_item (2) then
						ref := refc.item.integer_32_item (1)
					else
						ref := -1
					end
					n := find_different_reflection (col_maps.at (refc.key), ref)
					if n /= 0 and smudges /= 0 
					then
						Result := Result + n
					else
						print ("NO REFLECTION FOUND! " + refc.key.out + ", old ref " + refc.item.integer_32_item (1).out + " " + refc.item.boolean_item (2).out + "%N")
					end
				end
			end
		end

feature {NONE} -- part 1
	-- index for the maps, tuple is the found reflection value and true if it's a row reflection
	p1_reflections: HASH_TABLE [TUPLE [INTEGER, BOOLEAN], INTEGER]

	simple_check (map: LIST [STRING]; a, b: INTEGER): BOOLEAN
		do
			Result := map.at (a).is_equal (map.at (b))
		end

	find_reflection (map: LIST [STRING]; start: REAL; fn: FUNCTION [TUPLE [LIST [STRING], INTEGER, INTEGER], BOOLEAN]): INTEGER
		local
			curr_line: REAL
			a, b: INTEGER
		do
			from 
				curr_line := start
			until
				curr_line > map.count
				or Result /= 0
			loop
				smudges := 0
				from
					a := curr_line.floor
					b := curr_line.ceiling
				until
					a < 1 or b > map.count 
					or not fn (map, a, b)
				loop
					-- print (curr_line.out + " " + map.at (a).out + " " + map.at (b).out + "%N")
					a := a - 1
					b := b + 1
				end
				if a < 1 or b > map.count then
					Result := curr_line.floor
				end
				curr_line := curr_line + 1
			end
		end
feature {NONE} -- part 2
	smudges: INTEGER

	find_different_reflection (map: LIST [STRING]; p1_reflection: INTEGER): INTEGER
		local
			start: REAL
		do
			from
				start := 1.5
			until
				start > map.count
				or (start /= 1.5 and Result = 0)
				or (Result /= 0 and smudges = 1 and Result /= p1_reflection)
			loop
				Result := find_reflection (map, start, agent smudge_check)
				--print ("Start: " + start.out + " Result: " + Result.out + "P1 Ref: " + p1_reflection.out + "%N")
				if Result = 0 then
					start := map.count.to_real + 0.5
				else
					start := Result.to_real + 1.5
				end
			end
		end

	smudge_check (map: LIST [STRING]; a, b: INTEGER): BOOLEAN
		local
			fuzziness: INTEGER
		do
			if smudges > 0 then
				fuzziness := 0
			else
				fuzziness := 1
			end
			Result := map.at (a).fuzzy_index (map.at (b), 1, fuzziness) = 1
			if Result and not map.at (a).is_equal (map.at (b)) then
				smudges := smudges + 1
			end
		end
end
