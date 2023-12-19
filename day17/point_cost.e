class
	POINT_COST
inherit
	COMPARABLE
		redefine is_equal end
create
	make
feature -- init
	make (p: POINT; c: INTEGER; f: INTEGER)
		do
			point := p
			cost := c
			facing := f
		end

feature -- access
	point: POINT
	cost: INTEGER
	facing: INTEGER


feature -- Comparison
	is_less alias "<" (other: POINT_COST): BOOLEAN
		do
			Result := cost < other.cost
		end

	is_equal (other: POINT_COST): BOOLEAN
		do
			Result := point.is_equal (other.point) and cost = other.cost
		end
end
