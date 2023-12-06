note
	description: "Transformer with multiple mappers"
	author: "Edd Purcell"
class
	MULTIMAPPER
create
	make
feature {NONE} -- init
	make
		do
			create mappers.make
		end
	
	mappers: LINKED_LIST [MAPPER]

feature {ANY} -- setup
	add_mapper (m: MAPPER)
		do
			mappers.extend (m)
		end
feature {ANY} -- transformer
	map (in: INTEGER_64): INTEGER_64
		do
			Result := in
			--print ("Map start: " + in.out)
			from
				mappers.start
			until
				Result /= in
				or mappers.off
			loop

				--print ("%NMapper: " + mappers.item.out)
				--print ("%N  Input: " + Result.out)
				Result := mappers.item.map (in)
				--print ("%N  Result: " + Result.out)
				mappers.forth
			end
		end
	
	map_range (r: RANGE): LIST [RANGE]
		local
			mapping_result: TUPLE [LIST[RANGE], detachable RANGE]
			todo: LINKED_LIST [RANGE]
			new_todo: LINKED_LIST [RANGE]
			curr: RANGE
			mapped: LINKED_LIST [RANGE]
		do
			create todo.make
			todo.extend (r)
			todo.start

			create mapped.make

			from mappers.start until mappers.off or todo.off
			loop
				--print ("%NMapper " + mappers.item.out + "%N")
				create new_todo.make
				from todo.start until todo.off
				loop
					curr := todo.item
					mapping_result := mappers.item.map_range (todo.item)
					--print ("Map result: " +mapping_result.out + "%N")
					if attached {RANGE} mapping_result.at (2) as l_r then
						--print ("MAPPED " + l_r.out)
						mapped.extend (l_r)
					end
					if attached {LIST [RANGE]} mapping_result.at (1) as l_l then

						--debug_ranges(l_l)
						new_todo.append (l_l)
					end
					todo.remove
				end
				todo.append (new_todo)
				--debug_ranges (todo)
				--print ("%N")
				todo.start
				mappers.forth
			end
			mapped.append (todo)
			--print ("RESULTS!")
			--debug_ranges (mapped)
			Result := mapped
		end
feature {NONE} -- debugging
	debug_ranges (ranges: LIST [RANGE])
		do
			print ("%NMUTLTIMAPPER Ranges: ")
			across ranges as r
			loop print (r.item.out + " ") end
		end
end
