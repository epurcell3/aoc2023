expanded class RANK
inherit
	COMPARABLE
		redefine is_equal, default_create end
	ANY
		redefine is_equal, default_create end
create
	default_create,
	make_from_int
feature
	value: INTEGER
feature
	high_card: INTEGER = 1
	one_pair: INTEGER = 2
	two_pair: INTEGER = 3
	three_of_a_kind: INTEGER = 4
	full_house: INTEGER = 5
	four_of_a_kind: INTEGER = 6
	five_of_a_kind: INTEGER = 7
feature {NONE} -- init
	make_from_int (n: INTEGER)
		do
			value := n
		end
	default_create
		do
			value := 1
		end
feature -- comparisson
	is_less alias "<" (other: RANK): BOOLEAN
		do
			Result := value < other.value
		end
	is_equal (other: RANK): BOOLEAN
		do
			Result := value = other.value
		end
invariant
	value = high_card or
	value = one_pair or
	value = two_pair or
	value = three_of_a_kind or
	value = full_house or
	value = four_of_a_kind or
	value = five_of_a_kind
end
