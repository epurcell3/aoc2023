note
	description: "Code for Advent of Code Day 2"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DAY02

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
		local
			new_game: GAME
		do
			create games.make
			across lines as line
			loop
				create new_game.make (line.item)
				games.extend (new_game)
			end
		end

feature {NONE} -- properties
	games: LINKED_LIST[GAME]

feature {ANY} -- operations
	-- find the sum of all ids w/ no more than
	-- 12 red
	-- 13 green
	-- 14 blue
	part_1: INTEGER
		do
			Result := 0
			across games as game
			loop
				if game.item.rounds.for_all (agent test) then
					Result := Result + game.item.id
				end
			end
		end

	-- find the sum of the "power" (red * green * blue) of the
	-- minimum set of cubes for each game
	part_2: INTEGER
		do
			Result := 0
			across games as game
			loop
				Result := Result + power (minimum_set (game.item))
			end
		end

feature {NONE} -- part 1
	-- Ensure the round has no more than the following:
	-- 12 red
	-- 13 green
	-- 14 blue
	test (round: ROUND): BOOLEAN
		do
			Result := round.RED <= 12 and
				round.GREEN <= 13 and
				round.BLUE <= 14
		end
feature {NONE} -- part 2
	-- find the minimum set of a game
	minimum_set (game: GAME): ROUND
		local
			r_max, g_max, b_max: INTEGER
		do
			across game.rounds as round
			loop
				if round.item.red > r_max then
					r_max := round.item.red
				end
				if round.item.green > g_max then
					g_max := round.item.green
				end
				if round.item.blue > b_max then
					b_max := round.item.blue
				end
			end
			create Result.make_with_values(r_max, g_max, b_max)
		end

	-- "power"
	power (set: ROUND): INTEGER
		do
			Result := set.red
				* set.green
				* set.blue
		end
end
