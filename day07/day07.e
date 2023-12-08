note
	description: "Code for Advent of Code Day 7"
	author: "Edd Purcell"
	date: "$Date$"

class
	DAY07

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
			s: LIST [STRING]
			h: HAND
			h2: HAND2
		do
			create hands.make (2000)
			create hands2.make (2000)
			across lines as l
			loop
				s := l.item.split(' ')
				create h.make_from_string (s.first)
				create h2.make_from_string (s.first)
				hands.put (s.last.to_integer, h)
				hands2.put (s.last.to_integer, h2)
			end
			create ordered.make_from_iterable (hands.current_keys)
			create ordered2.make_from_iterable (hands2.current_keys)
		end
	
	-- [bid, hand]
	hands: HASH_TABLE [INTEGER, HAND]
	ordered: SORTED_TWO_WAY_LIST [HAND]
	hands2: HASH_TABLE [INTEGER, HAND2]
	ordered2: SORTED_TWO_WAY_LIST [HAND2]

feature {ANY} -- operations
	part_1: INTEGER
		local
			i: INTEGER
		do
			i := 1
			across ordered as ic
			loop
				Result := Result + (i * hands.definite_item (ic.item))
				i := i + 1
			end
		end
	part_2: INTEGER
		local
			i: INTEGER
		do
			i := 1
			across ordered2 as ic
			loop
				Result := Result + (i * hands2.definite_item (ic.item))
				i := i + 1
			end
		end

feature {NONE} -- part 1
feature {NONE} -- part 2
end
