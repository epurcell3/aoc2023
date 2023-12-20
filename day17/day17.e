note
	description: "Code for Advent of Code Day 17, probably a*"
	author: "Edd Purcell"
	date: "$Date$"

class
	DAY17

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
			p: POINT
		do
			create entry_costs.make (lines.count * lines.first.count)
			across lines as lc
			loop
				x := 1
				across lc.item.linear_representation as cc
				loop
					create p.make (x, lc.cursor_index)
					entry_costs.put (cc.item.out.to_integer, p)
					x := x + 1
				end
			end
			create start.make (1, 1)
			create goal.make (lines.first.count, lines.count)
			create path_cost_g.make (lines.first.count * lines.count)
			create path_cost_f.make (lines.first.count * lines.count)
			create came_from.make (lines.first.count * lines.count)
		end
	
	entry_costs: HASH_TABLE [INTEGER, POINT]
	start: POINT
	goal: POINT
	path_cost_g: HASH_TABLE [INTEGER, POINT_STATE]
	path_cost_f: HASH_TABLE [INTEGER, POINT_STATE]
	came_from: HASH_TABLE [POINT_STATE, POINT_STATE]

feature {ANY} -- operations
	Up: INTEGER = 0
	Left: INTEGER = 1
	Down: INTEGER = 2
	Right: INTEGER = 3

	Turn_left: INTEGER = 10
	Turn_right: INTEGER = 11
	Forward: INTEGER = 12

	part_1: INTEGER
		local
			begin: POINT_STATE
		do
			create begin.make (start, Right, 0, path_cost_f)
			a_star (begin)
--			from p := goal until p.is_equal (start)
--			loop
--				print (p.out + " " + g (p).out + "%N")
--				p := came_from.definite_item (p)
--			end
			Result := {INTEGER}.Max_value
			across path_cost_g as entries
			loop
				if entries.key.is_at (goal) and entries.item < Result then
					Result := -entries.item
				end
			end
		end

	part_2: INTEGER
		local
			begin: ULTRA_POINT_STATE
		do
			create begin.make (start, Right, 0, path_cost_f)
			a_star (begin)
			Result := {INTEGER}.Max_value
			across path_cost_g as entries
			loop
				if entries.key.is_at (goal) and entries.item < Result then
					Result := -entries.item
				end
			end
		end

	cost_from_map (p: POINT_STATE; map: HASH_TABLE [INTEGER, POINT_STATE]): INTEGER
		do
			if map.has (p) then
				Result := map.definite_item (p)
			else
				Result := {INTEGER}.Min_value
			end
		ensure
			instance_free: class
		end
feature {NONE} -- part 1
	g (p: POINT_STATE): INTEGER
		do
			Result := cost_from_map (p, path_cost_g)
		end
	
	f (p: POINT_STATE): INTEGER
		do
			Result := cost_from_map (p, path_cost_f)
		end
	

	point_with_best_f (points: HASH_TABLE [INTEGER, POINT_STATE]): POINT_STATE
		local
			best, tmp: INTEGER
		do
			best := {INTEGER}.Max_value
			--Result := points.first
			create Result.make (start, Right, 0, path_cost_f)
			across points as pc
			loop
				tmp := f (pc.key)
				if tmp < best then
					best := tmp
					Result := pc.key
				end
			end
		end
	
	a_star (begin: POINT_STATE)
		local
			curr: POINT_STATE
			--state: COST_STATE
			tentative_g, new_f: INTEGER
			--open_set: HASH_TABLE [INTEGER, POINT_STATE]
			open_set: HEAP_PRIORITY_QUEUE [POINT_STATE]
		do
			create open_set.make (141*141*3*4)
			curr := begin
			--open_set.extend (0, curr)
			open_set.extend (curr)
			-- setup g
			path_cost_g.wipe_out
			path_cost_g.put (0, curr)
			-- setup f
			path_cost_f.wipe_out
			path_cost_f.put (-start.manhattan (goal), curr)

			from
				--curr := point_with_best_f (open_set)
				curr := open_set.item
			until
				open_set.is_empty
				or curr.is_at (goal)
			loop
				--print (curr.out + " " + f (curr).out + " " + path_cost_g.definite_item (curr).out + " " + open_set.count.out + "%N")
				--open_set.start
				--open_set.search (curr)
				--open_set.remove (curr)
				open_set.remove

				across curr.neighbors_by_moves as pc
				loop
					if pc.item.x > 0
						and pc.item.y > 0
						and pc.item.x <= goal.x
						and pc.item.y <= goal.y
					then
						--print (" " + pc.item.out + " ")
						tentative_g := g (curr) - entry_costs.definite_item (pc.item.point)
						--print (tentative_g.out + " ")
						if tentative_g > g (pc.item) then
							--print ("replacing%N")
							came_from.force (curr, pc.item)
							path_cost_g.force (tentative_g, pc.item)
							new_f := tentative_g - pc.item.point.manhattan (goal)
							path_cost_f.force (new_f, pc.item)
							open_set.extend (pc.item)
							--open_set.put (0, pc.item)
						else
							--print ("%N")
						end
					end
				end
				--curr := point_with_best_f (open_set)
				curr := open_set.item
			end
		end

feature {NONE} -- part 2
end
