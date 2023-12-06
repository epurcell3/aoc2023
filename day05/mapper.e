note
	description: "A number mapper based on ranges"
	author: "Edd Purcell"

class
	MAPPER
inherit
	ANY redefine out end
create
	make
feature {NONE} -- init
	make (destination_start: INTEGER_64; source_start: INTEGER_64; window: INTEGER_64)
		do
			dest_start := destination_start
			src_start := source_start
			win := window
			create range.make (source_start, source_start + window - 1)
			adjust := destination_start - source_start
		end
	
	dest_start: INTEGER_64
	src_start: INTEGER_64
	win: INTEGER_64
	range: RANGE
	adjust: INTEGER_64

feature {ANY} -- transformers
	map (in: INTEGER_64): INTEGER_64
		do
			Result := in
			if within_range (in) then
				Result := dest_start + in - src_start
			end
		end
	
	map_range (r: RANGE): TUPLE [LIST [RANGE], detachable RANGE]
		local
			res: TUPLE [LIST [RANGE], detachable RANGE]
			mapped_range: RANGE
		do
			--print ("RANGE: " + range.out + ", IN: " + r.out + "%N")
			res := range.overlap (r)
			create Result
			Result.put (res.at (1), 1)
			if attached {RANGE} res.at (2) as l_r then
				create mapped_range.make(l_r.lower + adjust, l_r.upper + adjust)
				Result.put (mapped_range, 2)
			else
				Result.put (Void, 2)
			end
		end

feature {NONE} -- helpers
	within_range (in: INTEGER_64): BOOLEAN
		do
			Result := in >= src_start and in - src_start < win
		end

feature {ANY} -- debugging
	out: STRING
		do
			Result := "Dest Start: " + dest_start.out +
				" Source Range: " + range.out +
				" Adjust: " + adjust.out
		end
end
