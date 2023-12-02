note
	description: "A round has the number of colors"

class
	ROUND
inherit
	ANY
		redefine out end
create
	make, make_with_values
feature {NONE} -- initialization
	-- Example input
	-- ` 1 blue, 2 green, 1 red`
	make (text: STRING)
		do
			text.split (',').do_all (agent parse_color)
		end

	make_with_values(r: INTEGER; g: INTEGER; b: INTEGER)
		do
			red := r
			green := g
			blue := b
		end

	parse_color (text: STRING)
		do
			text.prune_all_leading (' ')
			if text.ends_with("blue") then
				blue := text.split (' ').at (1).to_integer
			elseif text.ends_with("green") then
				green := text.split (' ').at (1).to_integer
			else -- text ends with red
				red := text.split (' ').at (1).to_integer
			end
		end

feature -- Access
	red: INTEGER
	green: INTEGER
	blue: INTEGER

feature
	out: STRING_8
		do
			Result := "RED: " + red.out + ", GREEN: " + green.out + ", BLUE: " + blue.out
		end
end
