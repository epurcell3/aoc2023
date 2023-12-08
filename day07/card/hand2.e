class HAND2
inherit
	HAND
		redefine
			get_card,
			is_five_of_a_kind,
			is_four_of_a_kind,
			is_full_house,
			is_three_of_a_kind,
			is_two_pair,
			is_one_pair,
			is_equal
		end
create
	make_from_string
feature {HAND}
	get_card (c: CHARACTER): CAMEL_CARD
		do
			create Result.make_from_character2 (c)
		end
	is_five_of_a_kind: BOOLEAN
		local
			five_count, four_count, three_count, pair_count, single_count, joker_count: INTEGER
		do
			across counts as ic
			loop
				if (ic.key = 0) then
					joker_count := counts.item (0)
				elseif (ic.item = 5) then
					five_count := five_count + 1
				elseif (ic.item = 4) then
					four_count := four_count + 1
				elseif (ic.item = 3) then
					three_count := three_count + 1
				elseif (ic.item = 2) then
					pair_count := pair_count + 1
				elseif (ic.item = 1) then
					single_count := single_count + 1
				end
			end
			Result := five_count = 1 or joker_count = 5 or
				(four_count = 1 and joker_count = 1) or
				(three_count = 1 and joker_count = 2) or
				(pair_count = 1 and joker_count = 3) or
				(single_count = 1 and joker_count = 4)
		end
	is_four_of_a_kind: BOOLEAN
		local
			four_count, three_count, pair_count, single_count, joker_count: INTEGER
		do
			across counts as ic
			loop
				if (ic.key = 0) then
					joker_count := counts.item (0)
				elseif (ic.item = 4) then
					four_count := four_count + 1
				elseif (ic.item = 3) then
					three_count := three_count + 1
				elseif (ic.item = 2) then
					pair_count := pair_count + 1
				elseif (ic.item = 1) then
					single_count := single_count + 1
				end
			end
			Result := four_count = 1 or
				(three_count = 1 and joker_count = 1) or
				(pair_count = 1 and joker_count = 2) or
				(single_count = 2 and joker_count = 3)
		end
	is_full_house: BOOLEAN
		local
			three_count, pair_count, single_count, joker_count: INTEGER
		do
			across counts as ic
			loop
				if (ic.key = 0) then
					joker_count := counts.item (0)
				elseif (ic.item = 3) then
					three_count := three_count + 1
				elseif (ic.item = 2) then
					pair_count := pair_count + 1
				elseif (ic.item = 1) then
					single_count := single_count + 1
				end
			end
			Result := (three_count = 1 and pair_count = 1) or
				(pair_count = 2 and joker_count = 1) or
				(pair_count = 1 and joker_count = 2) or
				(single_count = 2 and joker_count = 3)
		end
	is_three_of_a_kind: BOOLEAN
		local
			three_count, pair_count, single_count, joker_count: INTEGER
		do
			across counts as ic
			loop
				if (ic.key = 0) then
					joker_count := counts.item (0)
				elseif (ic.item = 3) then
					three_count := three_count + 1
				elseif (ic.item = 2) then
					pair_count := pair_count + 1
				elseif (ic.item = 1) then
					single_count := single_count + 1
				end
			end
			Result := three_count = 1 or
				(pair_count = 1 and joker_count = 1) or
				(single_count > 0 and joker_count = 2)
		end
	is_two_pair: BOOLEAN
		local
			pair_count, single_count, joker_count: INTEGER
		do
			across counts as ic
			loop
				if (ic.key = 0) then
					joker_count := ic.item
				elseif (ic.item = 2) then
					pair_count := pair_count + 1
				elseif (ic.item = 2) then
					single_count := single_count + 1
				end
			end
			Result := pair_count = 2 or 
				(pair_count = 1 and single_count = 2 and joker_count = 1) or
				(pair_count = 0 and single_count > 2 and joker_count = 2)
		end
	is_one_pair: BOOLEAN
		local
			pair_count, single_count, joker_count: INTEGER
		do
			across counts as ic
			loop
				if (ic.key = 0) then
					joker_count := ic.item
				elseif (ic.item = 2) then
					pair_count := pair_count + 1
				elseif (ic.item = 2) then
					single_count := single_count + 1
				end
			end
			Result := pair_count = 1 or 
				(pair_count = 0 and joker_count = 1)
		end

			
feature --comparrisons
	is_equal (other: HAND2): BOOLEAN
		do
			Result := string_rep = other.string_rep
		end
end
