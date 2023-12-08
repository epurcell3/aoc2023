note
	description: "An AoC Camel Poker playing card type"
expanded class CAMEL_CARD
inherit
	HASHABLE
		redefine is_equal, default_create end
	COMPARABLE
		redefine is_equal, default_create end
	ANY
		redefine is_equal, default_create end
create
	default_create,
	make_from_character,
	make_from_character2
feature
	value: INTEGER
feature
	joker: INTEGER = 0
	two: INTEGER = 1
	three: INTEGER = 2
	four: INTEGER = 3
	five: INTEGER = 4
	six: INTEGER = 5
	seven: INTEGER = 6
	eight: INTEGER = 7
	nine: INTEGER = 8
	ten: INTEGER = 9
	jack: INTEGER = 10
	queen: INTEGER = 11
	king: INTEGER = 12
	ace: INTEGER = 13
	
feature {NONE} -- init
	default_create
		do
			value := two
		end
	make_from_character (c: CHARACTER)
		do
			if c = '2' then
				value := two
			elseif c = '3' then
				value := three
			elseif c = '4' then
				value := four
			elseif c = '5' then
				value := five
			elseif c = '6' then
				value := six
			elseif c = '7' then
				value := seven
			elseif c = '8' then
				value := eight
			elseif c = '9' then
				value := nine
			elseif c = 'T' then
				value := ten
			elseif c = 'J' then
				value := jack
			elseif c = 'Q' then
				value := queen
			elseif c = 'K' then
				value := king
			--elseif c = 'A' then
			-- not ideal, but... AoC not real code
			else
				value := ace
			end
		end
	make_from_character2 (c: CHARACTER)
		do
			if c = '2' then
				value := two
			elseif c = '3' then
				value := three
			elseif c = '4' then
				value := four
			elseif c = '5' then
				value := five
			elseif c = '6' then
				value := six
			elseif c = '7' then
				value := seven
			elseif c = '8' then
				value := eight
			elseif c = '9' then
				value := nine
			elseif c = 'T' then
				value := ten
			elseif c = 'J' then
				value := joker
			elseif c = 'Q' then
				value := queen
			elseif c = 'K' then
				value := king
			--elseif c = 'A' then
			-- not ideal, but... AoC not real code
			else
				value := ace
			end
		end

feature -- comparisson
	is_less alias "<" (other: CAMEL_CARD): BOOLEAN
		do
			Result := value < other.value
		end
	is_equal (other: CAMEL_CARD): BOOLEAN
		do
			Result := value = other.value
		end

feature -- hashing
	hash_code: INTEGER
		do
			Result := value
		end

invariant
	value = joker or
	value = two or
	value = three or
	value = four or
	value = five or
	value = six or
	value = seven or
	value = eight or
	value = nine or
	value = ten or
	value = jack or
	value = queen or
	value = king or
	value = ace
end
