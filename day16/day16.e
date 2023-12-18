note
	description: "Code for Advent of Code Day 16"
	author: "Edd Purcell"
	date: "$Date$"

class
	DAY16

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
			x: INTEGER
			new_point: POINT
			new_mirror: LIGHT_MIRROR
			new_splitter: LIGHT_SPLITTER
		do
			create new_point.make (1, 1)
			create light_tree.make (new_point)
			create visited_cells.make (1024)
			create energized_cells.make (1024)
			create map.make (1024)
			across lines as lc
			loop
				x := 1
				across lc.item.linear_representation as cc
				loop
					if cc.item = '/' or cc.item = '\' then
						create new_mirror.make (cc.item)
						create new_point.make (x, lc.cursor_index)
						map.put (new_mirror, new_point)
					elseif cc.item = '|' or cc.item = '-' then
						create new_splitter.make (cc.item)
						create new_point.make (x, lc.cursor_index)
						map.put (new_splitter, new_point)
					end
					x := x + 1
				end
			end
			max_x := lines.first.count
			max_y := lines.count
		end

	map: HASH_TABLE [LIGHT_MECHANISM, POINT]
	max_x: INTEGER
	max_y: INTEGER

	light_tree: LINKED_TREE [POINT]
	visited_cells: HASH_TABLE [LINKED_SET [INTEGER], POINT]
	energized_cells: HASH_TABLE [INTEGER, POINT]

feature {ANY} -- operations
	part_1: INTEGER
		local
			p: POINT
		do
			--print_map
			create p.make (0, 1)
			build_tree (p, {LIGHT_MECHANISM}.Right)
			Result := energized_cells.count - 1
		end

	part_2: INTEGER_64
		local
			n: INTEGER
			p: POINT
		do
			from n := 1 until n > max_y
			loop
				-- Left side going right
				create p.make (0, n)
				build_tree (p, {LIGHT_MECHANISM}.Right)
				Result := Result.max (energized_cells.count - 1)
				-- Right side going left
				create p.make (max_x + 1, n)
				build_tree (p, {LIGHT_MECHANISM}.Left)
				Result := Result.max (energized_cells.count - 1)
				n := n + 1
			end
			from n := 1 until n > max_x
			loop
				-- Top side going down
				create p.make (n, 0)
				build_tree (p, {LIGHT_MECHANISM}.Down)
				Result := Result.max (energized_cells.count - 1)
				-- Bottom side going up
				create p.make (n, max_y + 1)
				build_tree (p, {LIGHT_MECHANISM}.Up)
				Result := Result.max (energized_cells.count - 1)
				n := n + 1
			end
		end
feature {NONE} -- part 1
	build_tree (p: POINT; dir: INTEGER)
		do
			visited_cells.wipe_out
			energized_cells.wipe_out
			create light_tree.make (p)
			build_tree_helper (light_tree, dir)
		end
	
	build_tree_helper (current_node: LINKED_TREE [POINT]; dir: INTEGER)
		local
			seen_dirs: LINKED_SET [INTEGER]
		do
			if attached find_next_node (current_node.item, dir) as next then
				--print ("%N" + next.out + " ")
				current_node.extend (next)
				record_cells (current_node.item, next)
				if not attached visited_cells.at (next) then
					create seen_dirs.make
					visited_cells.put (seen_dirs, next)
				end
	
				if attached {LIGHT_MECHANISM} map.at (next) as l_m 
					and attached current_node.last_child as l_c 
					and attached visited_cells.at (next) as l_p
				then
					if not l_p.has (dir) then
						l_p.extend (dir)
						across l_m.adjust_beam (dir) as beamc
						loop
							--print (beamc.item.out + " ")
							build_tree_helper (l_c, beamc.item)
						end
					end
				end
			end
		end
	
	record_cells (start, finish: POINT)
		-- assumes horizontal or vertical, but just filles in the square
		local
			p: POINT
			x, y: INTEGER
			start_x, finish_x, start_y, finish_y: INTEGER
		do
			start_x := start.x.min (finish.x)
			finish_x := start.x.max (finish.x)
			start_y := start.y.min (finish.y)
			finish_y := start.y.max (finish.y)
			from y := start_y until y > finish_y
			loop
				from x := start_x until x > finish_x
				loop
					create p.make (x, y)
					if energized_cells.has (p) then
						energized_cells.replace (energized_cells.at (p) + 1, p)
					else
						energized_cells.put (1, p)
					end
					x := x + 1
				end
				y := y + 1
			end

		end

feature {NONE} -- part 2

feature {NONE} -- map helpers

	find_next_node (start: POINT; dir: INTEGER): detachable POINT
		require
			valid_dir: dir = {LIGHT_MECHANISM}.Right
				or dir = {LIGHT_MECHANISM}.Left
				or dir = {LIGHT_MECHANISM}.Up
				or dir = {LIGHT_MECHANISM}.Down
		do
			if dir = {LIGHT_MECHANISM}.Right then
				Result := find_next_right_node (start)
			elseif dir = {LIGHT_MECHANISM}.Left then
				Result := find_next_left_node (start)
			elseif dir = {LIGHT_MECHANISM}.Up then
				Result := find_next_up_node (start)
			else -- elseif dir = {LIGHT_MECHANISM}.Down then
				Result := find_next_down_node (start)
			end
			if Result.is_equal (start) then
				Result := Void
			end
		end
	
	find_next_right_node (start: POINT): POINT
		local
			x: INTEGER
			p: POINT
		do
			from x := start.x + 1 until x > max_x or Result /= Void
			loop
				create p.make (x, start.y)
				if map.has (p) then
					Result := p
				end
				x := x + 1
			end
			if Result = Void then
				create Result.make (max_x, start.y)
			end
		end
	
	find_next_left_node (start: POINT): POINT
		local
			x: INTEGER
			p: POINT
		do
			from x := start.x - 1 until x < 1 or Result /= Void
			loop
				create p.make (x, start.y)
				if map.has (p) then
					Result := p
				end
				x := x - 1
			end
			if Result = Void then
				create Result.make (1, start.y)
			end
		end

	find_next_down_node (start: POINT): POINT
		local
			y: INTEGER
			p: POINT
		do
			from y := start.y + 1 until y > max_y or Result /= Void
			loop
				create p.make (start.x, y)
				if map.has (p) then
					Result := p
				end
				y := y + 1
			end
			if Result = Void then
				create Result.make (start.x, max_y)
			end
		end
	
	find_next_up_node (start: POINT): POINT
		local
			y: INTEGER
			p: POINT
		do
			from y := start.y - 1 until y < 1 or Result /= Void
			loop
				create p.make (start.x, y)
				if map.has (p) then
					Result := p
				end
				y := y - 1
			end
			if Result = Void then
				create Result.make (start.x, 1)
			end
		end

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
					x := x + 1
					if attached {LIGHT_MIRROR} map.at (p) as l_m then
						print (l_m.out)
					end
					if attached {LIGHT_SPLITTER} map.at (p) as l_s then
						print (l_s.out)
					end
					if not map.has (p) then
						print (".")
					end
				end
				print ("%N")
				y := y + 1
			end
		end
end
