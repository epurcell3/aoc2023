class MOVEMENT
create make
feature {NONE} -- init
	make (adjust: POINT; dir: INTEGER)
		do
			adjustment := adjust
			direction := dir
		end
feature -- acess
	adjustment: POINT
	direction: INTEGER
end
