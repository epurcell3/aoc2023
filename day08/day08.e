note
	description: "Code for Advent of Code Day 8"
	author: "Edd Purcell"
	date: "$Date$"

class
	DAY08

inherit
	DAY
		redefine parse end

create
	make

feature {NONE} -- Initialization

	make
		do
			process
		end
	parse
		do
			directions := lines.first.linear_representation
			create nodes.make (1000)
			from
				lines.start
				lines.forth
				lines.forth
			until
				lines.off
			loop
				parse_node (lines.item)
				lines.forth
			end
		end
	
	parse_node (s: STRING)
		local
			name, connections: STRING
			t: TUPLE [STRING, STRING]
		do
			s.prune_all (' ')
			name := s.split ('=').first
			connections := s.split ('=').last
			connections.prune_all ('(')
			connections.prune_all (')')
			create t
			t.put (connections.split (',').first, 1)
			t.put (connections.split (',').last, 2)
			nodes.put (t, name)
		end

	
	directions: LINEAR [CHARACTER]
	nodes: HASH_TABLE [TUPLE [STRING, STRING], STRING]

feature {ANY} -- operations
	part_1: INTEGER
		do
			Result := length_of_path ("AAA", agent node_is_zzz)
		end
	part_2: INTEGER_64
		local
			temp, divisor: INTEGER
			steps: LINKED_LIST [INTEGER]
		do
			create steps.make
			across nodes.current_keys as key
			loop
				if key.item.ends_with ("A") then
					temp := length_of_path (key.item, agent node_ends_with_z)
					steps.extend (temp)
					print (key.item + " " + temp.out + "%N")
				end
			end
			-- assume the same GCD
			divisor := gcd (steps.at (1), steps.at (2))
			Result := 1
			across steps as s
			loop
				Result := Result * s.item // divisor
			end
			-- divided one too many times this way
			Result := Result * divisor
		end

feature {NONE} -- part 1
	node_is_zzz (node: STRING): BOOLEAN
		do
			Result := node.is_equal("ZZZ")
		end
feature {NONE} -- part 2
	node_ends_with_z (node: STRING): BOOLEAN
		do
			Result := node.ends_with ("Z")
		end
	length_of_path (start: STRING; predicate: FUNCTION [STRING, BOOLEAN]): INTEGER
		local
			curr_node: STRING
			ind: INTEGER
		do
			Result := 0
			curr_node := start
			from
				directions.start
			until
				predicate.item (curr_node)
			loop
				Result := Result + 1
				if directions.item = 'L' then
					ind := 1
				else
					ind := 2
				end
				directions.forth
				if directions.off then
					directions.start
				end
				if attached {STRING} nodes.definite_item (curr_node).at (ind) as l_n then
					curr_node := l_n
				end
			end
		end
	
	gcd (a: INTEGER; b: INTEGER): INTEGER
		local
			ta, tb, mod: INTEGER
		do
			ta := a
			tb := b
			from
				mod := ta \\ tb
			until
				mod = 0
			loop
				Result := mod
				mod := tb \\ mod
			end
		end
end
