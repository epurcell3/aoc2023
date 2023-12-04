note
	description: "Code for Advent of Code Day 4"
	author: "Edd Purcell"
	date: "$Date$"

class
	DAY04

inherit
	DAY redefine parse end

create
	make

feature {NONE} -- Initialization

	make
		do
			process
		end
	
	parse
		local
			card: CARD
		do
			create cards.make
			create card_counts.make (150)
			across lines as l
			loop
				create card.make (l.item)
				cards.extend (card)
				card_counts.extend (1, card.id)
			end
		end

feature {NONE} -- access
	cards: LINKED_LIST [CARD]
	-- count, card ID
	card_counts: HASH_TABLE [INTEGER, INTEGER]

feature {ANY} -- operations
	part_1: REAL_64
		do
			Result := 0
			across cards as ic
			loop
				Result := Result + points (ic.item)
			end
		end
	part_2: INTEGER
		local
			match_count, i, card_count, tmp: INTEGER
		do
			across cards as ic
			loop
				match_count := matches (ic.item)
				card_count := card_counts.definite_item (ic.item.id)

				from
					i := 1
				until
					i > match_count 
					or not card_counts.has_key (ic.item.id + i)
				loop
					tmp := card_counts.definite_item (ic.item.id + i)
					card_counts.replace (tmp + card_count, ic.item.id + i)
					i := i + 1
				end

			end
			Result := 0
			across card_counts as ic
			loop
				Result := Result + ic.item
			end
		end

feature {NONE} -- part 1
	points (card: CARD): REAL_64
		local count: INTEGER
		do
			count := matches (card)
			if count = 0 then
				Result := 0
			else
				-- then cheekily do 2^(Result - 1)
				Result := 2 ^ (count - 1)
			end
		end
feature {NONE} -- part 2
	matches (card: CARD): INTEGER
		do
			Result := 0
			across card.winning_numbers as in
			loop
				Result := Result + in.item
			end
		end
end
