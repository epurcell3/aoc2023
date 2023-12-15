class
	REMOVE_OP
inherit
	OP
create
	make
feature {NONE} -- init
	make (instruction: STRING)
		require
			instruction_is_valid: instruction.ends_with ("-")
		do
			label := instruction.substring (1, instruction.count - 1)
			create fake_lens.make (label, 1)
		end
	
	fake_lens: LENS
	
feature -- action
	execute (boxes: HASH_TABLE [LIST [LENS], INTEGER])
		local
			lenses: LIST [LENS]
		do
			lenses := boxes.definite_item (relevant_box)
			lenses.start
			lenses.search (fake_lens)
			if not lenses.exhausted then
				lenses.remove
			end
		end
end

