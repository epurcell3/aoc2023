note
	description: "Code for Advent of Code Day 15"
	author: "Edd Purcell"
	date: "$Date$"

class
	DAY15

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
			lines.first.replace_substring_all ("%N", "")
			sequence := lines.first.split (',')
			create ops.make
			across sequence as seqc
			loop
				ops.extend (parse_op (seqc.item))
			end
		end
	
	parse_op (s: STRING): OP
		local
			new_remove_op: REMOVE_OP
			new_place_op: PLACE_OP
		do
			if s.ends_with ("-") then
				create new_remove_op.make (s)
				Result := new_remove_op
			else
				create new_place_op.make (s)
				Result := new_place_op
			end
		end
	
	sequence: LIST [STRING]
	ops: LINKED_LIST [OP]

	boxes: HASH_TABLE [LIST [LENS], INTEGER]

feature {ANY} -- operations
	part_1: INTEGER
		do
			across sequence as s
			loop
				Result := Result + holiday_ascii_string_helper (s.item)
			end
		end
	part_2: INTEGER
		do
			holiday_ascii_string_helper_manual_arrangement_procedure
			across boxes as boxc
			loop
				across boxc.item as lensc
				loop
					Result := Result + focusing_power (boxc.key, lensc.cursor_index, lensc.item.focal_length)
				end
			end
		end

feature {OP} -- part 1
	holiday_ascii_string_helper (s: STRING): INTEGER
		do
			across s.linear_representation as c
			loop
				Result := Result + c.item.code
				Result := Result * 17
				Result := Result \\ 256
			end
		ensure
			positive_or_zero: Result >= 0
			fits_in_one_byte: Result < 256
			instance_free: class
		end
feature {NONE} -- part 2
	holiday_ascii_string_helper_manual_arrangement_procedure
		local
			i: INTEGER
			new_list: LINKED_LIST [LENS]
		do
			create boxes.make (255)
			from i := 0 until i > 255
			loop
				create new_list.make
				new_list.compare_objects
				boxes.put (new_list, i)
				i := i + 1
			end
			across ops as opc
			loop
				opc.item.execute (boxes)
			end
		end
	
	focusing_power (box_number, lens_index, focal_length: INTEGER): INTEGER
		do
			Result := (box_number + 1) * lens_index * focal_length
		end
end
