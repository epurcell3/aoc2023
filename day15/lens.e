class
	lens
inherit
	ANY
		redefine is_equal end
create
	make
feature {NONE} -- init
	make (nlabel: STRING; nfocal_length: INTEGER)
		require
			label_exists: nlabel /= Void
			focal_length_valid: 0 < nfocal_length and nfocal_length < 10
		do
			label := nlabel
			focal_length := nfocal_length
		end

feature -- access
	label: STRING
	focal_length: INTEGER

feature -- comparisson
	is_equal (other: LENS): BOOLEAN
		do
			Result := label.is_equal (other.label)
		end
end
