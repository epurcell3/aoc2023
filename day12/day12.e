note
	description: "Code for Advent of Code Day 12"
	author: "Edd Purcell"
	date: "$Date$"

class
	DAY12

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
			new_nonogram: NONOGRAM
			gram, clue: STRING
		do
			create nonograms.make
			create unfolded_nonograms.make
			across lines as lc
			loop
				-- regular p1
				create new_nonogram.make (lc.item)
				nonograms.extend (new_nonogram)
				-- unfolded p2
				gram := lc.item.split (' ').first
				clue := lc.item.split (' ').last
				create new_nonogram.make (
					gram+"?"+gram+"?"+gram+"?"+gram+"?"+gram+" "+
					clue+","+clue+","+clue+","+clue+","+clue
				)
				unfolded_nonograms.extend (new_nonogram)
			end
		end
	
	nonograms: LINKED_LIST [NONOGRAM]
	unfolded_nonograms: LINKED_LIST [NONOGRAM]
feature {ANY} -- operations
	part_1: INTEGER_64
		local
			n: INTEGER_64
		do
			across nonograms as nc
			loop
				n := nc.item.valid_permutation_count
				--print (n.out + "%T" + nc.item.out + "%N")
				Result := Result + n
			end
		end

	part_2: INTEGER_64
		local
			n: INTEGER_64
		do
			across unfolded_nonograms as nc
			loop
				--print (nc.cursor_index.out + "%N")
				n := nc.item.valid_permutation_count
				--print (n.out + "%T" + nc.item.out + "%N")
				Result := Result + n
			end
		end

feature {NONE} -- part 1

feature {NONE} -- part 2
end
