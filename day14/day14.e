note
	description: "Code for Advent of Code Day 14"
	author: "Edd Purcell"
	date: "$Date$"

class
	DAY14

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
		do
			create map.make (1024)
			max_x := lines.first.count
			max_y := lines.count
			y := 1
			across lines as lc
			loop
				x := 1
				across lc.item.linear_representation as cc
				loop
					if cc.item /= '.' then
						create new_point.make (x, y)
						map.put (cc.item, new_point)
					end
					x := x + 1
				end
				y := y + 1
			end
			orig_map := map
			create hashes.make (1024)
		end
	
	min_x: INTEGER = 1
	max_x: INTEGER
	min_y: INTEGER = 1
	max_y: INTEGER

	orig_map: HASH_TABLE [CHARACTER, POINT]
	map: HASH_TABLE [CHARACTER, POINT]

	Round_rock: CHARACTER = 'O'
	Square_rock: CHARACTER = '#'

feature {ANY} -- operations
	part_1: INTEGER
		do
			tilt_up
			Result := load_north
		end
	part_2: INTEGER
		local
			step, sol, eol, additional_steps: INTEGER
		do
			map := orig_map
			from
				step := 0
				create hashes.make (1024)
			until
				hashes.has (hash)
			loop
				hashes.put (step, hash)		
				spin
				step := step + 1
				print (step.out + " ")
			end
			print ("%N")
			sol := hashes.definite_item (hash)
			eol := step
			from
				additional_steps := (1_000_000_000 - sol) \\ (eol - sol)
			until
				additional_steps = 0
			loop
				spin
				additional_steps := additional_steps - 1
			end
			Result := load_north
		end

feature {NONE} -- part 1
	tilt_up
		do
			tilt_up_down (1, max_x, agent greater_than, agent increment)
		end

	greater_than (a, b: INTEGER): BOOLEAN
		do
			Result := a > b
		end
	
	increment (a: INTEGER): INTEGER
		do
			Result := a + 1
		end

		tilt_up_down (loop_start, loop_end: INTEGER; cmp: FUNCTION [TUPLE [INTEGER, INTEGER], BOOLEAN]; adjust: FUNCTION [TUPLE [INTEGER], INTEGER])
		local
			new_map: HASH_TABLE [CHARACTER, POINT]
			x, y: INTEGER
			roll_to: INTEGER
			point: POINT
		do
			create new_map.make (map.count)
			from x := loop_start until cmp (x, loop_end)
			loop
				roll_to := loop_start
				from y := loop_start until cmp (y, loop_end)
				loop
					create point.make (x, y)
					if attached map.at (point) as l_c then
						if l_c = Round_rock then
							create point.make (x, roll_to)
							new_map.put (l_c, point)
							roll_to := adjust (roll_to)
						elseif l_c = Square_rock then
							new_map.put (l_c, point)
							roll_to := adjust (y)
						end
					end
					y := adjust (y)
				end
				x := adjust (x)
			end
			map := new_map
		end

	load_north: INTEGER
		do
			across map as mc
			loop
				if mc.item = Round_rock then
					Result := Result + (max_y - mc.key.y) + 1
				end
			end
		end
	
feature {NONE} -- part 2
	-- tracking for loops, [step, hash]
	hashes: HASH_TABLE [INTEGER, INTEGER]
	hash: INTEGER
		local
			s: STRING
		do
			s := ""
			across map as mc
			loop
				if mc.item = Round_rock then
					s.append (mc.key.out)
				end
			end
			Result := s.hash_code
		end

	spin
		do
			tilt_up
			tilt_left
			tilt_down
			tilt_right
		end

	less_than (a, b: INTEGER): BOOLEAN
		do
			Result := a < b
		end

	decrement (a: INTEGER): INTEGER
		do
			Result := a - 1
		end

	tilt_down
		do
			tilt_up_down (max_x, 1, agent less_than, agent decrement)
		end
	
	tilt_left
		do
			tilt_right_left (1, max_y, agent greater_than, agent increment)
		end
	
	tilt_right
		do
			tilt_right_left (max_y, 1, agent less_than, agent decrement)
		end

		tilt_right_left (loop_start, loop_end: INTEGER; cmp: FUNCTION [TUPLE [INTEGER, INTEGER], BOOLEAN]; adjust: FUNCTION [TUPLE [INTEGER], INTEGER])
		local
			new_map: HASH_TABLE [CHARACTER, POINT]
			x, y: INTEGER
			roll_to: INTEGER
			point: POINT
		do
			create new_map.make (map.count)
			from y := loop_start until cmp (y, loop_end)
			loop
				roll_to := loop_start
				from x := loop_start until cmp (x, loop_end)
				loop
					create point.make (x, y)
					if attached map.at (point) as l_c then
						if l_c = Round_rock then
							create point.make (roll_to, y)
							new_map.put (l_c, point)
							roll_to := adjust (roll_to)
						elseif l_c = Square_rock then
							new_map.put (l_c, point)
							roll_to := adjust (x)
						end
					end
					x := adjust (x)
				end
				y := adjust (y)
			end
			map := new_map
		end
feature {NONE} -- debug
	print_map
		local
			x, y: INTEGER
			p: POINT
		do
			from y := 1 until y > max_y
			loop
				from x := 1 until x > max_x
				loop
					create p.make (x, y)
					if attached map.at (p) as l_c then
						print (l_c.out)
					end
					if not map.has (p) then
						print (".")
					end
					x := x + 1
				end
				print ("%N")
				y := y + 1
			end
		end
end
