class
	LIGHT_MIRROR
inherit
	LIGHT_MECHANISM
		redefine out end
	ANY
		redefine out end
create
	make
feature {NONE} -- init and private properties
	up_to: INTEGER
	left_to: INTEGER
	right_to: INTEGER
	down_to: INTEGER

	make (c: CHARACTER)
		require
			valid_character: c = '/' or c = '\'
		do
			out := c.out
			if c = '/' then
				up_to := Right
				left_to := Down
				down_to := Left
				right_to := Up
			else
				up_to := Left
				right_to := Down
				down_to := Right
				left_to := Up
			end
		end

feature -- action
	adjust_beam (dir: INTEGER): LIST [INTEGER]
		local
			res: LINKED_LIST [INTEGER]
		do
			create res.make
			if dir = Up then
				res.extend (up_to)
			elseif dir = Left then
				res.extend (left_to)
			elseif dir = Down then
				res.extend (down_to)
			elseif dir = Right then
				res.extend (right_to)
			end
			Result := res
		end
feature -- out
	out: STRING

end
