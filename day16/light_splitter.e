class
	LIGHT_SPLITTER
inherit
	LIGHT_MECHANISM
		redefine out end
	ANY
		redefine out end
create
	make
feature {NONE} -- init and private props
	split_on: LINKED_SET [INTEGER]
	split_into: LINKED_LIST [INTEGER]


	make (c: CHARACTER)
		require
			valid_character: c = '|' or c = '-'
		do
			out := c.out
			create split_on.make
			create split_into.make
			if c = '|' then
				split_on.extend (Left)
				split_on.extend (Right)
				split_into.extend (Up)
				split_into.extend (Down)
			else
				split_on.extend (Up)
				split_on.extend (Down)
				split_into.extend (Left)
				split_into.extend (Right)
			end
		end
feature -- action
	adjust_beam (dir: INTEGER): LIST [INTEGER]
		local
			res: LINKED_LIST [INTEGER]
		do
			if split_on.has (dir) then
				Result := split_into
			else
				create res.make
				res.extend (dir)
				Result := res
			end
		end

feature -- out
	out: STRING
end
