note
	description: "A scratch card for Day 4 of AoC 2023"
	author: "Edd Purcell"

class
	CARD
inherit
	ANY redefine out end
create
	make
feature {NONE} -- init
	make (line: STRING)
		local
			number_part: LIST [STRING]
		do
			id := parse_id (line)

			create winning_numbers.make (20)
			number_part := line.split (':').at (2).split ('|')
			number_part.first.replace_substring_all("  ", " ")
			number_part.first.prune_all_leading (' ')
			number_part.first.prune_all_trailing (' ')
			add_winning_numbers (number_part.first.split (' '))

			number_part.last.replace_substring_all("  ", " ")
			number_part.last.prune_all_leading (' ')
			number_part.last.prune_all_trailing (' ')
			count_winning_numbers (number_part.last.split (' '))

		end
	
	parse_id (line: STRING): INTEGER
		do
			Result := line.split (':').at (1).split (' ').last.to_integer
		end
	
	add_winning_numbers (numbers: LIST [STRING])
		do
			across numbers as in
			loop
				winning_numbers.extend (0, in.item)
			end
		end
	
	count_winning_numbers (numbers: LIST [STRING])
		local
			score: detachable INTEGER
		do
			across numbers as in
			loop
				if winning_numbers.has_key (in.item) then
					score := winning_numbers.definite_item (in.item)
					winning_numbers.replace (score + 1, in.item)
				end
			end
		end

feature {ANY} -- access
	id: INTEGER
	-- winning numbers and their counts
	winning_numbers: HASH_TABLE [INTEGER, STRING]

feature {ANY} -- output
	points: REAL_64
		local count: INTEGER
		do
			count := matches
			if count = 0 then
				Result := 0
			else
				-- then cheekily do 2^(Result - 1)
				Result := 2 ^ (count - 1)
			end
		end
	matches: INTEGER
		do
			across winning_numbers as ic
			loop
				Result := Result + ic.item
			end
		end
	out: STRING
		do
			Result := "CARD " + id.out + "%N"
			across winning_numbers as in
			loop
				Result := Result + in.key + ": " + in.item.out + "%N"
			end
		end
end
