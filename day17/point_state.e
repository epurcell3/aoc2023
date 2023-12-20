class
	POINT_STATE
inherit
	COMPARABLE
		redefine is_equal, out end
	HASHABLE
		redefine is_equal, out end
	POINT
		rename make as pmake
		redefine hash_code, is_equal, out end
create
	make
feature
	make (p: POINT; f, n: INTEGER; costs: HASH_TABLE [INTEGER, POINT_STATE])
		-- x: x location
		-- y: y location
		-- f: facing
		-- n: steps going forward
		do
			x := p.x
			y := p.y
			facing := f
			forward_count := n
			path_costs := costs

			create always_valid_moves.make
			always_valid_moves.extend ({DAY17}.Turn_left)
			always_valid_moves.extend ({DAY17}.Turn_right)

			create sometimes_valid_moves.make
			sometimes_valid_moves.extend ({DAY17}.Turn_left)
			sometimes_valid_moves.extend ({DAY17}.Turn_right)
			sometimes_valid_moves.extend ({DAY17}.Forward)
		end

	always_valid_moves: LINKED_LIST [INTEGER]
	sometimes_valid_moves: LINKED_LIST [INTEGER]
	path_costs: HASH_TABLE [INTEGER, POINT_STATE]

feature -- Access
	facing: INTEGER
	forward_count: INTEGER

	is_at (other: POINT): BOOLEAN
		do
			Result := x = other.x and y = other.y
		end

	neighbors_by_moves: LIST [POINT_STATE]
		local
			res: LINKED_LIST [POINT_STATE]
			new_point: POINT
			new_state: POINT_STATE
		do
			create res.make
			across valid_moves as mc
			loop
				if mc.item = {DAY17}.Forward then
					create new_point.make (0, -1)
					new_point := rotate_unit (new_point, facing)
					new_state := new_point_state (
						Current + new_point,
						facing,
						forward_count + 1,
						path_costs
					)
					--print ("FORWARD: " + new_state.out + "%N")
				elseif mc.item = {DAY17}.Turn_right then
					create new_point.make (0, -1)
					new_point := rotate_unit (new_point, (facing + 3) \\ 4)
					new_state := new_point_state (
						Current + new_point,
						(facing + 3) \\ 4,
						1,
						path_costs
					)
					--print ("RIGHT: " + new_state.out + "%N")
				else --elseif mc.item = {DAY17}.Turn_left then
					create new_point.make (0, -1)
					new_point := rotate_unit (new_point, (facing + 1) \\ 4)
					new_state := new_point_state (
						Current + new_point,
						(facing + 1) \\ 4,
						1,
						path_costs
					)
					--print ("LEFT: " + new_state.out + "%N")
				end
				res.extend (new_state)
			end
			Result := res
		end
	point: POINT
		do
			create Result.make (x, y)
		end

feature {NONE} -- helpers
	rotate_unit (p: POINT; quarter_turns: INTEGER): POINT
		do
			if quarter_turns = 1 then
				create Result.make (p.y, p.x)
			elseif quarter_turns = 2 then
				create Result.make (p.x, -p.y)
			elseif quarter_turns = 3 then
				create Result.make (-p.y, p.x)
			else
				Result := p
			end
		end
	
	new_point_state (p: POINT; f, n: INTEGER; costs: HASH_TABLE [INTEGER, POINT_STATE]): POINT_STATE
		do
			create Result.make (p, f, n, costs)
		end

feature {POINT_STATE} -- other helpers
	valid_moves: LIST [INTEGER]
		do
			if forward_count < 3 then
				Result := sometimes_valid_moves
			else
				Result := always_valid_moves
			end
		end
feature -- comparison
	is_less alias "<" (other: POINT_STATE): BOOLEAN
		do
			Result := {DAY17}.cost_from_map (Current, path_costs)
				< {DAY17}.cost_from_map (other, path_costs)
		end

	is_equal (other: POINT_STATE): BOOLEAN
		do
			Result := x = other.x
				and y = other.y
				and facing = other.facing
				and forward_count = other.forward_count
		end


feature -- hashing
	hash_code: INTEGER
		do
			Result := x
			Result := Result * 37 + y
			Result := Result * 37 + facing
			Result := Result * 37 + forward_count
		end
feature -- out
	out: STRING
		do
			Result := "[" + x.out + ","+ y.out + "; " + facing.out + " " + forward_count.out + "]"
		end

invariant
	facing_is_valid: facing = 0 or facing = 1 or facing = 2 or facing = 3
end
