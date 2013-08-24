module Tournakit
	# +Tournament+s are special +Collection+s where every +Game+ is from the same event. In a +Tournament+, statistics like standing and ppg are meaningful. 
	class Tournament < Collection

		# Team is only useful in the context of a +Tournament+
		Team = Struct.new(:wins,:losses,:ties,:points,:points_against,:tens,:powers,:interrupts,:tossups_heard,
											:bonuses_heard,:bonus_points,:name)

		# the +Tournament+ version of teams provides statistics and +team_id+s
		# @return [Array<Team>]
		def teams
			@rounds.map(&:teams).flatten.uniq.sort.map do |team|
				t = Team.new
				t.name = team
				# these are the accumulator variables, the rest of the stats will be calculated
				t.wins = 0
				t.losses = 0
				t.ties = 0
				t.points = 0
				t.points_against = 0
				t.tens = 0
				t.powers = 0
				t.interrupts = 0
				t.tossups_heard = 0
				t.bonuses_heard = 0
				t.bonus_points = 0
				@rounds.each do |round|
					tid = round.teams.index(team)
					
				end

				t
			end
		end

		def wins(team)
			@team
		end
	end
end