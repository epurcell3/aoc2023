class
	ULTRA_POINT_STATE
inherit
	POINT_STATE
		rename make as psmake
		redefine valid_moves, new_point_state, is_less, is_equal end
create
	make
feature {NONE} -- init
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

			-- necessary to make the, but not really applicable
			create sometimes_valid_moves.make
			create always_valid_moves.make

			create forward_only.make
			forward_only.extend ({DAY17}.Forward)

			create turns_allowed.make
			turns_allowed.extend ({DAY17}.Turn_left)
			turns_allowed.extend ({DAY17}.Turn_right)
			turns_allowed.extend ({DAY17}.Forward)

			create must_turn.make
			must_turn.extend ({DAY17}.Turn_left)
			must_turn.extend ({DAY17}.Turn_right)
		end
	
	forward_only: LINKED_LIST [INTEGER]
	turns_allowed: LINKED_LIST [INTEGER]
	must_turn: LINKED_LIST [INTEGER]

feature {POINT_STATE} -- neighbors
	valid_moves: LIST [INTEGER]
		do
			if forward_count < 4 then
				Result := forward_only
			elseif forward_count < 10 then
				Result := turns_allowed
			else
				Result := must_turn
			end
		end
	
	new_point_state (p: POINT; f, n: INTEGER; costs: HASH_TABLE [INTEGER, POINT_STATE]): POINT_STATE
		local
			new: ULTRA_POINT_STATE
		do
			create new.make (p, f, n, costs)
			Result := new
		end

feature -- comparison
	is_less alias "<" (other: ULTRA_POINT_STATE): BOOLEAN
		do
			Result := {DAY17}.cost_from_map (Current, path_costs)
				< {DAY17}.cost_from_map (other, path_costs)
		end

	is_equal (other: ULTRA_POINT_STATE): BOOLEAN
		do
			Result := x = other.x
				and y = other.y
				and facing = other.facing
				and forward_count = other.forward_count
		end
end
