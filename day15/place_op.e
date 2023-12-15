class
	PLACE_OP
inherit
	OP
create
	make
feature {NONE} -- init
	make (instruction: STRING)
		require
			right_type: instruction.at (instruction.count - 1) = '='
			has_focal_length: instruction.at (instruction.count).is_digit
		local
			parts: LIST [STRING]
		do
			parts := instruction.split ('=')
			label := parts.first
			focal_length := parts.last.to_integer
		end
feature -- access
	focal_length: INTEGER
feature -- action
	execute (boxes: HASH_TABLE [LIST [LENS], INTEGER])
		local
			lenses: LIST [LENS]
			new_lens: LENS
		do
			lenses := boxes.definite_item (relevant_box)
			lenses.start
			create new_lens.make (label, focal_length)
			lenses.search (new_lens)
			if lenses.exhausted then
				lenses.extend (new_lens)
			else
				lenses.replace (new_lens)
			end
		end
end
