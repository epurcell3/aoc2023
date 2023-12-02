note
	description: "Represents a single game"
	author: ""

class
	GAME
inherit
	ANY
		redefine out end

create
	make

feature {NONE} -- Initialization

	-- Example input: 
	-- Game 1: 1 green, 4 blue; 1 blue, 2 green, 1 red; 1 red, 1 green, 2 blue; 1 green, 1 red; 1 green; 1 green, 1 blue, 1 red
	make (line: STRING)
		do
			id := get_game_id (line)
			rounds := map_text_to_rounds (line.split (':').at (2))
		end

	get_game_id (line: STRING): INTEGER
		local
			header: STRING
		do
			header := line.split (':').at (1)
			Result := header.split(' ').at (2).to_integer
		end
	
	get_rounds (line: STRING)
		do
			rounds := map_text_to_rounds (line.split (':').at (2))
		end

	create_round (text: STRING): ROUND
		do
			create Result.make (text)
		end
	
	-- Example text:
	-- ` 1 green, 4 blue; 1 blue, 2 green, 1 red; 1 red, 1 green, 2 blue; 1 green, 1 red; 1 green; 1 green, 1 blue, 1 red`
	map_text_to_rounds (text: STRING): LIST[ROUND]
		local
			new_list: LINKED_LIST[ROUND]
		do
			create new_list.make
			across text.split (';') as round
			loop
				new_list.extend (create_round (round.item))
			end
			Result := new_list
		end

feature {ANY} -- Access
	id: INTEGER
	rounds: LIST[ROUND]

	out: STRING
		do
			Result := "Game: " + id.out + "%N"
			across rounds as round
			loop
				Result := Result + round.item.out + "%N"
			end
			Result := Result + "%N"
		end
end
