note
	description: "2D point for graphs"
class
	POINT
inherit
	ANY
		redefine out, is_equal end
	HASHABLE
		redefine out, is_equal end
create
	make
feature -- init
	make (x_coord: INTEGER; y_coord: INTEGER)
		do
			x := x_coord
			y := y_coord
		end
feature -- Access
	x: INTEGER
	y: INTEGER

	cardinal_neighbors: LIST [POINT]
		local
			res: LINKED_LIST [POINT]
			new_p: POINT
		do
			create res.make
			-- Up
			create new_p.make (x, y + 1)
			res.extend  (new_p)
			-- Right
			create new_p.make (x + 1, y)
			res.extend  (new_p)
			-- Down
			create new_p.make (x, y - 1)
			res.extend  (new_p)
			-- Left
			create new_p.make (x - 1, y)
			res.extend  (new_p)
			Result := res
		end

feature -- arithmetic
	plus alias "+" (other: POINT): POINT
		do
			create Result.make (x + other.x, y + other.y)
		end
	minus alias "-" (other: POINT): POINT
		do
			create Result.make (x - other.x, y - other.y)
		end

feature -- comparrison
	is_equal (other: POINT): BOOLEAN
		do
			Result := x = other.x and y = other.y
		end

	manhattan (other: POINT): INTEGER
		do
			Result := (x - other.x).abs + (y - other.y).abs
		end

feature -- hashing
	hash_code: INTEGER
		do
			Result := x * y
		end

feature -- out
	out: STRING
		do
			Result := "[" + x.out + "," + y.out + "]"
		end
end
