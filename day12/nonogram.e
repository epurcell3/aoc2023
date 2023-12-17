class
	NONOGRAM
inherit
	ANY
		redefine out end
create
	make
feature {NONE} -- init
	-- e.g. `..??#???##??#?? 4,2,2`
	make (s: STRING)
		local
			parts: LIST [STRING]
		do
			create memos.make (512)
			parts := s.split (' ')
			characters := parts.first
			
			create clue.make
			across parts.last.split (',') as nc
			loop
				clue.extend (nc.item.to_integer_32)
			end
		end
feature -- access
	characters: STRING 
	clue: LINKED_LIST [INTEGER]

	Known_open: CHARACTER = '.'
	Known_filled: CHARACTER = '#'
	Unknown: CHARACTER = '?'

feature -- operations
	-- don't expose the world to recursion. It's not ready.
	valid_permutation_count: INTEGER_64
		do
			create memos.make (512)
			Result := memoized_helper (1, 1)
		end

feature {NONE} -- internal
	memos: HASH_TABLE [INTEGER_64, INTEGER]
	
	-- Part 2 is too slow if you recalculate big nonogram sections
	-- forever. Just a wrapper to return known values and can be
	-- ignored.
	memoized_helper (lower_bound, clue_index: INTEGER): INTEGER_64
		local
			key: INTEGER
		do
			key := lower_bound + 10000 * clue_index
			if memos.has (key) then
				Result := memos.definite_item (key)
			else
				Result := permutation_count_helper (lower_bound, clue_index)
				memos.put (Result, key)
			end
		end
	
	-- The meat and potatoes of the solver. Let's go through this shall we?
	-- The lower_bound is the index in the `characters` STRING to start looking
	-- from, `clue_index` is which clue we're currently looking to find possible
	-- places for.
	permutation_count_helper (lower_bound, clue_index: INTEGER): INTEGER_64
		local
			upper_bound, index: INTEGER
			current_clue: INTEGER
		do
			--print (characters + ": " + lower_bound.out + " " + clue_index.out + "%N")
			-- We need to know where we want to end our search, which is
			-- the space_requirements indexes back from the end of the
			-- characters. e.g. `2,1,1` needs 6 spaces to complete, so
			-- there's no reason to try 5 spaces from the end.
			upper_bound := characters.count - space_requirements (clue_index)
			-- But also if there's a known filled ('#') spot before the end
			-- we must stop searching there. If we're looking for a specific
			-- clue, it cannot happen AFTER that known filled spot.
			upper_bound := upper_bound.min (nearest_known_filled (lower_bound))
			-- Get the current clue to not call .at too many times
			current_clue := clue.at (clue_index)
			
			-- If our upper bound is before our starting spot
			-- OR there aren't enough characters left for the size of the
			-- current clue, we know this is a dead branch and can say there
			-- are no possibilities.
			if upper_bound < lower_bound 
				or (characters.count - lower_bound + 1) < current_clue
			then
				--print ("Quiting early%N")
				Result := 0
			else
				-- Otherwise, there's a chance! Let's loop through
				-- the starting position (`lower_bound`) to the final
				-- possible index (`upper_bound`) and sum up the
				-- possibilities!
				from
					index := lower_bound
				until
					index > upper_bound
				loop
					-- Look at the comment for this method call to
					-- explain it.
					if possible (index, clue_index) then
						--print ("Possible @ " + index.out + "!%N")
						-- If there are still clues to work
						-- through, recurse (thru memoized 
						-- method).
						if clue_index < clue.count then
							Result := Result + memoized_helper (index + current_clue + 1, clue_index + 1)
							--print ("Finished recursion!%N")
						else
						-- Otherwise we're at the last clue and
						-- can just add 1 to our result.
							Result := Result + 1
						end
					end
					index := index + 1
				end
			end
		end
	
	-- Add up the remaining clues and add another for the spaces between.
	-- This removes an additional one because 1 based indexing, bay-bee!
	space_requirements (clue_index: INTEGER): INTEGER
		local
			i: INTEGER
		do
			from i := clue_index until i > clue.count
			loop
				Result := Result + clue.at (i)
				i := i + 1
			end
			Result := Result + clue.count - clue_index - 1
		end
	
	-- This is a possible match iff
	-- 1. The space immediately before the current index (`lower_bound`) is
	--    empty or unknown.
	-- 2. The space immediately at the current index + the needed space
	--    (based on the `current_clue`) is empty or unknown. No +1 because the
	--    current index is included in the clue size.
	-- 3. There is enough space that is either unknown ('?') or filled ('#')
	--    at the current index for the current clue. And
	-- 4. If this is the last clue, there are no remaining filled ('#') spaces
	--    in the characters STRING.
	possible (lower_bound, clue_index: INTEGER): BOOLEAN
		local
			current_clue: INTEGER
		do
			current_clue := clue.at (clue_index)
			Result := no_prior_filled (lower_bound) 
				and no_after_filled (lower_bound, current_clue)
				and enough_space (lower_bound, current_clue)
				and no_leftover_known_filled (lower_bound, clue_index)
		end
	no_prior_filled (lower_bound: INTEGER): BOOLEAN
		do
			-- not preceded by a '#'
			Result := lower_bound = 1 or characters.at (lower_bound - 1) /= Known_filled
		end
	
	no_after_filled (lower_bound, current_clue: INTEGER): BOOLEAN
		local
			upper_bound: INTEGER
		do
			--print ("No prior filled " + no_prior_filled.out + "%N")
			-- not suceded by a '#'
			upper_bound := lower_bound + current_clue - 1
			Result := upper_bound = characters.count
				or characters.at (lower_bound + current_clue) /= Known_filled
		end
	
	enough_space (lower_bound, current_clue: INTEGER): BOOLEAN
		local
			index, upper_bound: INTEGER
		do
			--print ("No after filled " + no_after_filled.out + "%N")
			-- area of '#' or '?' in the area
			Result := true
			upper_bound := lower_bound + current_clue - 1
			from
				index := lower_bound
			until
				index > upper_bound or not Result
			loop
				if characters.at (index) = Known_open then
					Result := false
				end
				index := index + 1
			end
		end
	
	no_leftover_known_filled (lower_bound, clue_index: INTEGER): BOOLEAN
		do
			if clue_index = clue.count then
				Result := characters.index_of (Known_filled, lower_bound + clue.last) = 0
			else
				Result := true
			end
		end
	
	nearest_known_filled (start: INTEGER): INTEGER
		do
			Result := characters.index_of (Known_filled, start)
			if Result = 0 then
				Result := characters.count
			end
		end

feature -- out
	out: STRING
		do
			Result := characters + " "
			across clue as cc
			loop
				Result := Result + cc.item.out + ","
			end
		end
end
