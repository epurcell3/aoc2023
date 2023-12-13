class
	EDGE
inherit
	ANY
		redefine out end
create
	make
feature
	make (p1: POINT; p2: POINT)
		do
			first := p1
			last := p2
			min_x := first.x.min (last.x)
			max_x := first.x.max (last.x)
			min_y := first.y.min (last.y)
			max_y := first.y.max (last.y)
		end
feature -- access
	first: POINT
	last: POINT

feature -- interactions
	contains_point (p: POINT): BOOLEAN
		do
			Result :=
				(vertical and p.x = first.x and p.y >= min_y and p.y <= max_y ) or
				(horizontal and p.y = first.y and p.x >= min_x and p.x <= max_x)
		end
	horizontal: BOOLEAN
		do
			Result := first.y = last.y
		end
	vertical: BOOLEAN
		do
			Result := first.x = last.x
		end
	contains_y (y: INTEGER): BOOLEAN
		do
			Result := min_y <= y and y <= max_y
		end
	
feature {NONE} -- helpers
	min_x: INTEGER
	max_x: INTEGER
	min_y: INTEGER
	max_y: INTEGER

feature -- out
	out: STRING
		do
			Result := "{" + first.out + ", " + last.out + "}"
		end
end
