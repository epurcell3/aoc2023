class
	COST_STATE
inherit
	ANY
		redefine out end
create
	make
feature {NONE} -- init
	make (p: POINT; ncost, n_straight, dir: INTEGER)
		do
			point := p
			cost := ncost
			forward_count := n_straight
			facing := dir

		end
	always_valid_moves: LINKED_LIST [INTEGER]
	sometimes_valid_moves: LINKED_LIST [INTEGER]

feature -- Access
	point: POINT
	cost: INTEGER
	forward_count: INTEGER
	facing: INTEGER

feature -- updates
	update_cost (n: INTEGER)
		do
			cost := n
		end

feature -- movement

feature -- out
	out: STRING
		do
			Result := point.out + "; cost=" + cost.out + "; forward=" + forward_count.out + "; facing=" + facing.out
		end
end
