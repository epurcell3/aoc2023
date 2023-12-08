class HAND
inherit
	COMPARABLE redefine is_equal, out end
	HASHABLE redefine is_equal, out end
	ANY redefine is_equal, out end
create
	make_from_string
feature {HAND} -- init
	make_from_string (s: STRING)
		require
			proper_hand_size: s.count = 5
		local 
			new_card: CAMEL_CARD
		do
			string_rep := s
			create cards.make
			create counts.make (5)
			across s.linear_representation as c
			loop
				new_card := get_card (c.item)
				cards.extend (new_card.value)
				if attached counts.item (new_card.value) as l_c then
					counts.force (l_c + 1, new_card.value)
				end
				--print ("PRINTING...%N")
				across counts as tmp
				loop
					--print ("CARD: " + tmp.key.out + ", COUNT: " + tmp.item.out + "%N")
				end
			end
			determine_rank
		end
	determine_rank
		do
			if is_five_of_a_kind then
				rank := {RANK}.five_of_a_kind
			elseif is_four_of_a_kind then
				rank := {RANK}.four_of_a_kind
			elseif is_full_house then
				rank := {RANK}.full_house
			elseif is_three_of_a_kind then
				rank := {RANK}.three_of_a_kind
			elseif is_two_pair then
				rank := {RANK}.two_pair
			elseif is_one_pair then
				rank := {RANK}.one_pair
			else
				rank := {RANK}.high_card
			end
		end
feature {HAND}

	get_card (c: CHARACTER): CAMEL_CARD
		do
			create Result.make_from_character (c)
		end
	is_five_of_a_kind: BOOLEAN
		do
			Result := counts.has_item (5)
		end
	is_four_of_a_kind: BOOLEAN
		do
			Result := counts.has_item (4)
		end
	is_full_house: BOOLEAN
		do
			Result := counts.has_item (2) and counts.has_item (3)
		end
	is_three_of_a_kind: BOOLEAN
		do
			Result := counts.has_item (3)
		end
	is_two_pair: BOOLEAN
		local n: INTEGER
		do
			across counts as ic
			loop
				if ic.item = 2 then
					n := n + 1
				end
			end
			if n = 2 then
				Result := true
			end
		end
	is_one_pair: BOOLEAN
		local n: INTEGER
		do
			across counts as ic
			loop
				if ic.item = 2 then
					n := n + 1
				end
			end
			if n = 1 then
				Result := true
			end
		end
	
feature -- Access
	rank: INTEGER
	cards: LINKED_LIST [INTEGER]
feature {HAND} --internal
	string_rep: STRING
	-- count, camel_card
	counts: HASH_TABLE [INTEGER, INTEGER]

feature -- Comparison
	is_equal (other: HAND): BOOLEAN
		do
			Result := string_rep = other.string_rep
		end
	is_less alias "<" (other: HAND): BOOLEAN
		require else
			same_card_count: cards.count = other.cards.count
		local
			i: INTEGER
			greater_than: BOOLEAN
		do
			--print (string_rep + " < " + other.string_rep + "%N")
			Result := rank < other.rank
			--print (rank.out + " < " + other.rank.out + " = " + Result.out + "%N")
			if not Result and rank.is_equal (other.rank) then
				from
					i := 1
				until
					i > cards.count
					or Result
					or greater_than
				loop
					Result := cards.at (i) < other.cards.at (i)
					greater_than := cards.at (i) > other.cards.at (i)
					--print (cards.at (i).out + " < " + other.cards.at (i).out + " = " + Result.out + "%N")
					i := i + 1
				end
			end
		end
feature -- hashing
	hash_code: INTEGER_32
		do
			Result := string_rep.hash_code
		end

feature -- out
	out: STRING
		do
			Result := string_rep
		end
end
