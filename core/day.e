note
	description: "Summary description for {DAY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	DAY
inherit
	ARGUMENTS

feature {DAY} -- creation
	process
		require
			input_file_present: argument_count = 1
		local
			input: STRING
			f: PLAIN_TEXT_FILE
		do
			create lines.make
			input := argument (1)
			create f.make_open_read (input)
			from
				f.read_line
			until
				f.end_of_file
			loop
				lines.extend (f.last_string.twin)
				f.read_line
			end
			parse
			print ("Part 1: " + part_1.out + "%N")
			print ("Part 2: " + part_2.out + "%N")
		end

feature {DAY}
	lines: LINKED_LIST [STRING]

feature {ANY} -- operations
	parse
		do
		end
	part_1: ANY
		deferred end
	part_2: ANY
		deferred end

feature {NONE}
	print_line (line: STRING)
		do
			print (line)
			print ("%N")
		end

end
