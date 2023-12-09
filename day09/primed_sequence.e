note
	description: "An infinite sequence of integers that follows some growth mechanism"

class
	PRIMED_SEQUENCE [G -> NUMERIC]
create
	prime
feature {NONE} -- init
	prime (primer: LIST [G])
		local
			curr_delta: LINKED_LIST [G]
		do
			-- debug_list (primer)
			basic_init
			create initial_state.make
			initial_state.extend (primer.last)
			create current_state.make

			create curr_delta.make_from_iterable (primer)
			from
			until
				curr_delta.for_all (agent is_zero)
			loop
				curr_delta := deltas (curr_delta)
				-- debug_list (curr_delta)
				initial_state.extend (curr_delta.last)
			end

			current_state.copy (initial_state)
		end
	
	debug_list (l: LIST [G])
		do
			across l as il
			loop
				print (il.item.out + " ")
			end
			print ("DONE%N")
		end
	
	basic_init
		do
			index := 1
			after := false
			exhausted := false
			is_empty := false
			off := false
		end
	
	deltas (l: LIST [G]): LINKED_LIST [G]
		local
			i: INTEGER
		do
			create Result.make
			from
				i := 2
			until
				i > l.count
			loop
				Result.extend (l.at (i) - l.at (i - 1))
				i := i + 1
			end
		end
	
	is_zero (n: G): BOOLEAN
		local
			zero: G
		do
			Result := n = zero
		end
	
	initial_state: LINKED_LIST [G]
	current_state: LINKED_LIST [G]

feature -- Access

	index: INTEGER_32
			-- Index of current position

	item: G
			-- Item at current position
			-- (from TRAVERSABLE)
		require -- from TRAVERSABLE
			not_off: not off
		do
			Result := current_state.first
		end

	item_for_iteration: G
			-- Item at current position
		require
			not_off: not off
		do
			Result := item
		end

	
feature -- Status report

	after: BOOLEAN
			-- Is there no valid position to the right of current one?

	exhausted: BOOLEAN
			-- Has structure been completely explored?

	is_empty: BOOLEAN
			-- Is there no element?
			-- (from CONTAINER)

	off: BOOLEAN
			-- Is there no current item?
	
feature -- Cursor movement

	forth
			-- Move to next position; if no next position,
			-- ensure that `exhausted` will be true.
		require
			not_after: not after
		local
			delta: G
		do
			-- debug_list (current_state)
			-- kind of a hack, but last should always be 0 anyway
			delta := current_state.last
			from
				current_state.finish
			until
				current_state.off
			loop
				current_state.replace (current_state.item + delta)
				delta := current_state.item
				current_state.back
			end
			index := index + 1
		end

	start
			-- Move to first position if any.
			-- (from TRAVERSABLE)
		do
			current_state.copy (initial_state)
			index := 1
		end

invariant
	after_constraint: after implies off

		-- from TRAVERSABLE
	empty_constraint: is_empty implies off
end
