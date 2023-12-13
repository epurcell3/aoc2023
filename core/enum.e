note
	description: "Taken from <https://www.eiffel.org/node/237>"

expanded class
	ENUM

inherit
	COMPARABLE
		redefine
			is_less
		end

	HASHABLE
		undefine
			is_equal
		redefine
			hash_code
		end

feature -- Implementation of deferred

	is_less alias "<" (other: like Current): BOOLEAN
	external
		"built_in"
	end

	hash_code: INTEGER
	external
		"built_in"
	end

feature -- Set

	items: LIST[like Current]
	external
		"built_in"
	end

invariant
	-- Consistency is enforced by the compiler

end
