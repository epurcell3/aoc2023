deferred class
	LIGHT_MECHANISM
feature
	adjust_beam (dir: INTEGER): LIST [INTEGER]
		require
			valid_direction: dir = Up or dir = Down or dir = Left or dir = Right
		deferred
		ensure
			no_more_than_two_results: Result.count <= 2
			at_least_one_result: Result.count > 0
		end

	Up: INTEGER = 0
	Left: INTEGER = 1
	Down: INTEGER = 2
	Right: INTEGER = 3
end
