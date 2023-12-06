note
	description: "Range class for large windows"

class RANGE
inherit ANY redefine out end
create
	make
feature {NONE} -- init
	make (lower_bound: INTEGER_64; upper_bound: INTEGER_64)
		do
			lower := lower_bound
			upper := upper_bound
		end
feature {ANY} -- access
	lower: INTEGER_64
	upper: INTEGER_64
feature {ANY} -- tests
	contains (n: INTEGER_64): BOOLEAN
		do
			Result := lower <= n and n <= upper
		end

	-- Given another RANGE, return a tuple of the list of non-overlap and an
	-- optional range of the overlap
	overlap (other: RANGE): TUPLE [LIST [RANGE], detachable RANGE]
		local
			nonoverlap: LINKED_LIST [RANGE]
			new_range: RANGE
		do
			create nonoverlap.make
			create Result
			-- No overlap
			if lower > other.upper or upper < other.lower then
				--print ("No overlap%N")
				nonoverlap.extend (other)
				Result.put (nonoverlap, 1)
				Result.put (Void, 2)
			elseif contains (other.lower) and not contains (other.upper) then
				--print ("Left overlap%N")
				create new_range.make (upper + 1, other.upper)
				nonoverlap.extend (new_range)
				Result.put (nonoverlap, 1)
				create new_range.make (other.lower, upper)
				Result.put (new_range, 2)
			elseif not contains (other.lower) and contains (other.upper) then
				--print ("Right overlap%N")
				create new_range.make (other.lower, lower - 1)
				nonoverlap.extend (new_range)
				Result.put (nonoverlap, 1)
				create new_range.make (lower, other.upper)
				Result.put (new_range, 2)
			elseif contains (other.lower) and contains (other.upper) then
				--print ("Full encompass%N")
				Result.put (nonoverlap, 1)
				Result.put (other, 2)
			elseif other.contains (lower) and other.contains (upper) then
				--print ("Full enclosure%N")
				create new_range.make (other.lower, lower - 1)
				nonoverlap.extend (new_range)
				create new_range.make(upper + 1, other.upper)
				nonoverlap.extend (new_range)
				Result.put (nonoverlap, 1)
				Result.put (Current, 2)
			else
				print ("Not possible%N")
			end
		end

feature {ANY} -- display
	out: STRING
		do
			Result := "[" + lower.out + ", " + upper.out + "]"
		end
end
