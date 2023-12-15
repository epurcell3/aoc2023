deferred class
	OP
feature -- access
	label: STRING
feature -- action
	execute (boxes: HASH_TABLE [LIST [LENS], INTEGER])
		deferred end
feature {OP} -- helpers
	relevant_box: INTEGER
		do
			Result := {DAY15}.Holiday_ascii_string_helper (label)
		end
end
