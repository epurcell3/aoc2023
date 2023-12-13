note
	description: "Code for Advent of Code Day 10"
	author: "Edd Purcell"
	date: "$Date$"

class
	DAY10

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
		do
			create loop_path.make
			create map.make (7000)
			loop_path.compare_objects
			-- will always be attached, but let it go
			if attached find_start as l_start then
				track_loop (l_start)
			end
		end
	
	find_start: detachable POINT
		local
			y: INTEGER
		do
			y := 1
			from
				lines.start
			until
				lines.off or Result /= Void
			loop
				if lines.item.index_of ('S', 1) /= 0 then
					create Result.make (lines.item.index_of ('S', 1), y)
				end
				y := y + 1
				lines.forth
			end
		end
	
	track_loop (start: POINT)
		local
			curr_point: POINT
			from_direction: INTEGER
		do
			loop_path.extend (start)
			map.put (0, start)
			if attached find_first_movement (start) as l_p then
				from
					curr_point := start + l_p.adjustment
					from_direction := l_p.direction
				until
					curr_point.is_equal (start)
				loop
					loop_path.extend (curr_point)
					map.put (0, curr_point)
					if attached move_through (pipe_at (curr_point), from_direction) as l_movement then
						curr_point := curr_point + l_movement.adjustment
						from_direction := l_movement.direction
					end
				end
			end
		end
	
	pipe_at (p: POINT): CHARACTER
		do
			Result := lines.at (p.y).at (p.x)
		end
	
	find_first_movement (p: POINT): detachable MOVEMENT
		local
			p2: POINT
			pipe: CHARACTER
		do
			-- Check Up
			create p2.make (p.x, p.y - 1)
			if p.y /= 1 then
				pipe := pipe_at (p2)
				if pipe = '7' or pipe = '|' or pipe = 'F' then
					create Result.make (p2 - p, Down)
				end
			end
			-- Check Down
			create p2.make (p.x, p.y + 1)
			pipe := pipe_at (p2)
			if pipe = 'J' or pipe = '|' or pipe = 'L' then
				create Result.make (p2 - p, Up)
			end
			-- Check Left
			create p2.make (p.x - 1, p.y)
			pipe := pipe_at (p2)
			if pipe = 'F' or pipe = '-' or pipe = 'L' then
				create Result.make (p2 - p, Right)
			end
			-- Check Right
			create p2.make (p.x + 1, p.y)
			pipe := pipe_at (p2)
			if pipe = '7' or pipe = '-' or pipe = 'J' then
				create Result.make (p2 - p, Left)
			end
		end
	
	move_through (pipe: CHARACTER; from_dir: INTEGER): detachable MOVEMENT
		require
			valid_from_direction: from_dir = Up or from_dir = Down or from_dir = Right or from_dir = Left
		local
			adjust: POINT
		do
			if pipe = '|' then
				if from_dir = Up then
					create adjust.make (0, 1)
					create Result.make (adjust, Up)
				elseif from_dir = Down then
					create adjust.make (0, -1)
					create Result.make (adjust, Down)
				end
			elseif pipe = '-' then
				if from_dir = Left then
					create adjust.make (1, 0)
					create Result.make (adjust, Left)
				elseif from_dir = Right then
					create adjust.make (-1, 0)
					create Result.make (adjust, Right)
				end
			elseif pipe = 'L' then
				if from_dir = Up then
					create adjust.make (1, 0)
					create Result.make (adjust, Left)
				elseif from_dir = Right then
					create adjust.make (0, -1)
					create Result.make (adjust, Down)
				end
			elseif pipe = 'J' then
				if from_dir = Up then
					create adjust.make (-1, 0)
					create Result.make (adjust, Right)
				elseif from_dir = Left then
					create adjust.make (0, -1)
					create Result.make (adjust, Down)
				end
			elseif pipe = '7' then
				if from_dir = Down then
					create adjust.make (-1, 0)
					create Result.make (adjust, Right)
				elseif from_dir = Left then
					create adjust.make (0, 1)
					create Result.make (adjust, Up)
				end
			elseif pipe = 'F' then
				if from_dir = Down then
					create adjust.make (1, 0)
					create Result.make (adjust, Left)
				elseif from_dir = Right then
					create adjust.make (0, 1)
					create Result.make (adjust, Up)
				end
			end
--			if Result = Void then
--				{EXCEPTIONS}.raise ("bad movement: " + pipe.out + ":" + from_dir.out)
--			end
--		ensure
--			non_void_result: Result /= Void
		end

	loop_path: LINKED_LIST [POINT]
	Up: INTEGER = 1
	Down: INTEGER = 2
	Right: INTEGER = 3
	Left: Integer = 4

	map: HASH_TABLE [INTEGER, POINT]

feature {ANY} -- operations
	part_1: INTEGER
		do
			Result := loop_path.count // 2
		end

	last_x: INTEGER
	winding: INTEGER

	part_2: INTEGER
		local
			min_x, min_y, max_x, max_y: INTEGER
			x, y: INTEGER
			tmp: INTEGER
			verticals, v_tmp: LIST [EDGE]
		do
			min_x := {INTEGER}.Max_value
			min_y := {INTEGER}.Max_value
			max_x := {INTEGER}.Min_value
			max_y := {INTEGER}.Min_value
			-- set the bounding box we card about
			across loop_path as l
			loop
				if l.item.x < min_x then
					min_x := l.item.x
				elseif l.item.x > max_x then
					max_x := l.item.x
				end
				if l.item.y < min_y then
					min_y := l.item.y
				elseif l.item.y > max_y then
					max_y := l.item.y
				end
			end
			-- we only care about vertical edges for our casting
			verticals := vertical_edges (points_to_edges)
			--print ("N Verticals: " + verticals.count.out + "%N")
			
			--min_y := 7
			--max_y := 7
			-- loop
			from
				y := min_y
			until
				y > max_y
			loop
				print (y.out + "%N")
				v_tmp := verticals_in_y (y, verticals)
				--v_tmp := verticals
				last_x := max_x
				winding := 0
				from
					x := max_x
				until
					x < min_x
				loop
					tmp := winding_number (x, y, v_tmp) 
					--print ("[" + x.out + "," + y.out + "]: " + tmp.out + "%N")
					if tmp /= 0 then
						Result := Result + 1
					last_x := x
					winding := tmp
					end
					x := x - 1
				end
				y := y + 1
			end
		end

feature {NONE} -- part 1
feature {NONE} -- part 2
	verticals_in_y (y: INTEGER; verts: LIST [EDGE]): LIST [EDGE]
		local
			res: LINKED_LIST [EDGE]
		do
			create res.make
			across verts as v
			loop
				if v.item.contains_y (y) then
					res.extend (v.item)
				end
			end
			Result := res
		end

	winding_number (x: INTEGER; y: INTEGER; verts: LIST [EDGE]): INTEGER
		local
			p: POINT
			curr_x: INTEGER
			last_edge: EDGE
		do
			create p.make (x, y)
			if map.has (p) then
				--print ("in pipe ")
				Result := 0
			else
				from
					curr_x := x
				until
					curr_x > last_x
				loop
					create p.make (curr_x, y)
					across verts as v
					loop
						if not treat_the_same (v.item, last_edge) and v.item.contains_point (p) then
							--print ("%N  " + v.item.out + " [" + winding_adjust (v.item).out + "] ")
							--print (p.out + " hit edge ")
							Result := Result + winding_adjust (v.item)
							last_edge := v.item
						end
					end
					curr_x := curr_x + 1
				end
				Result := Result + winding
				--print ("%N TOTAL: " + Result.out)
			end
		end

	treat_the_same (e1: EDGE; e2: detachable EDGE): BOOLEAN
		do
			if attached e2 then
				Result := 
					(e1.first.y = e2.last.y and winding_adjust(e1) = winding_adjust(e2)) or
					(e1.last.y = e2.first.y and winding_adjust(e1) = winding_adjust(e2))
			else
				Result := false
			end
		end

	points_to_edges: LIST [EDGE]
		local
			res: LINKED_LIST [EDGE]
			new_edge: EDGE
			curr_start: POINT
			pipe: CHARACTER
		do
			create res.make
			curr_start := loop_path.first
			across loop_path as l
			loop
				pipe := pipe_at (l.item)
				if pipe = 'F' or pipe = 'J' or pipe = '7' or pipe = 'L' then
					create new_edge.make (curr_start, l.item)
					res.extend (new_edge)
					curr_start := l.item
				end
			end
			create new_edge.make (curr_start, loop_path.first)
			res.extend (new_edge)
			Result := res
		end
	
	vertical_edges (edges: LIST [EDGE]): LIST [EDGE]
		local
			res: LINKED_LIST [EDGE]
		do
			create res.make
			across edges as e
			loop
				if e.item.vertical then
					res.extend (e.item)
				end
			end
			Result := res
		end

	winding_adjust (edge: EDGE): INTEGER
		do
			if edge.vertical then
				if edge.first.y > edge.last.y then
					Result := -1
				else
					Result := 1
				end
			else
				if edge.first.x > edge.last.x then
					Result := 1
				else
					Result := -1
				end
			end
		end
end
