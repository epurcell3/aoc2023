class
	LIGHT_EMPTY_SPACE
inherit
	LIGHT_MECHANISM
feature
	adjust_beam (dir: INTEGER): LIST [INTEGER]
		local
			res: LINKED_LIST [INTEGER]
		do
			create res.make
			res.extend (dir)
			Result := res
		end
end
