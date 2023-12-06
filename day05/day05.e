note
	description: "Code for Advent of Code Day 5"
	author: "Edd Purcell"
	date: "$Date$"

class
	DAY05

inherit
	DAY redefine parse end

create
	make

feature {NONE} -- Initialization

	make
		do
			process
		end
	
	parse
		do
			parse_seeds
			parse_mappers
		end
	
	parse_seeds
		local
			numbers: STRING
			i: INTEGER
			new_window: RANGE
		do
			create seeds.make
			numbers := lines.first.split (':').last
			numbers.prune_all_leading (' ')
			across numbers.split(' ') as ic
			loop
				seeds.extend (ic.item.to_integer_64)
			end
			create seed_windows.make
			from
				i := 1
			until
				i >= seeds.count
			loop
				create new_window.make (
					seeds.at (i),
					seeds.at (i) + seeds.at (i + 1) - 1)
				seed_windows.extend (new_window)
				i := i + 2
			end
		end
	
	parse_mappers
		local
			new_multimapper: MULTIMAPPER
			new_mapper: MAPPER
			mapper_parts: LIST [STRING]
		do
			create multimappers.make
			create new_multimapper.make

			-- Start on the first mapper of the first map
			lines.start
			lines.forth
			lines.forth
			lines.forth
			from
			until
				lines.off
			loop
				if lines.item.is_equal ("") then
					multimappers.extend (new_multimapper)
					create new_multimapper.make
					lines.forth
				else 
					mapper_parts := lines.item.split (' ')
					create new_mapper.make (
						mapper_parts.at (1).to_integer_64,
						mapper_parts.at (2).to_integer_64,
						mapper_parts.at (3).to_integer_64)
					new_multimapper.add_mapper (new_mapper)
				end
				lines.forth
			end
			multimappers.extend (new_multimapper)
		end
		

	seeds: LINKED_LIST [INTEGER_64]
	multimappers: LINKED_LIST [MULTIMAPPER]
	seed_windows: LINKED_LIST [RANGE]

feature {ANY} -- operations
	part_1: INTEGER_64
		do
			Result := {INTEGER_64}.Max_value
			across seeds as seed
			loop
				Result := Result.min (map_seed_to_location (seed.item))
			end
		end
	part_2: INTEGER_64
		do
			Result := {INTEGER_64}.Max_value
			across seed_windows as seed_range
			loop
				across map_seed_range_to_location_ranges (seed_range.item)
					as l_range
				loop
					--print ("CHECKING " + l_range.item.out + "%N")
					Result := Result.min (l_range.item.lower)
				end
			end
		end

feature {NONE} -- part 1
	map_seed_to_location (seed: INTEGER_64): INTEGER_64
		do
			--print ("Seed: " + seed.out + "%N")
			Result := seed
			across multimappers as m
			loop
				--print (Result.out + "%N")
				Result := m.item.map (Result)
			end
		end
feature {NONE} -- part 2
	map_seed_range_to_location_ranges (seed_range: RANGE): LIST [RANGE]
		local
			res: LINKED_LIST [RANGE]
			next: LINKED_LIST [RANGE]
		do
			create res.make
			res.extend (seed_range)
			across multimappers as m
			loop
				--print ("%N%NMultiMapper%N")
				create next.make
				across res as range
				loop
					--print (range.item.out)
					next.append (m.item.map_range(range.item))
				end
				--print ("%N")
				--across next as r loop print ("next " + r.item.out + "%N") end
				res := next
			end
			Result := res
		end
	part_2_brute: INTEGER_64
		local
			i: INTEGER
			seed: INTEGER_64
			range: INTEGER_64
		do
			Result := {INTEGER_64}.Max_value
			from
				i := 1
			until
				i >= seeds.count
			loop
				range := seeds.at (i + 1)
				from
					seed := seeds.at (i)
				until
					seed >= (seeds.at (i) + range)
				loop
					Result := Result.min (map_seed_to_location (seed.item))
					seed := seed + 1
				end
				i := i + 2
			end
		end
end
