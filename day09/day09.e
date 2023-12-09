note
	description: "Code for Advent of Code Day 9"
	author: "Edd Purcell"
	date: "$Date$"

class
	DAY09

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
			numbers: LINKED_LIST [INTEGER]
			rev_numbers: LINKED_LIST [INTEGER]
			seq: PRIMED_SEQUENCE [INTEGER]
		do
			create sequences.make
			create rev_sequences.make
			across lines as l
			loop
				create numbers.make
				create rev_numbers.make
				across l.item.split (' ') as n
				loop
					numbers.extend (n.item.to_integer)
					rev_numbers.put_front (n.item.to_integer)
				end
				create seq.prime (numbers)
				sequences.extend (seq)
				create seq.prime (rev_numbers)
				rev_sequences.extend (seq)
			end
		end
	
	sequences: LINKED_LIST [PRIMED_SEQUENCE [INTEGER]]
	rev_sequences: LINKED_LIST [PRIMED_SEQUENCE [INTEGER]]

feature {ANY} -- operations
	part_1: INTEGER
		do
			Result := 0
			across sequences as seq
			loop
				seq.item.forth
				Result := Result + seq.item.item
			end
		end
	part_2: INTEGER
		do
			Result := 0
			across rev_sequences as seq
			loop
				seq.item.forth
				Result := Result + seq.item.item
			end
		end

feature {NONE} -- part 1
feature {NONE} -- part 2
end
