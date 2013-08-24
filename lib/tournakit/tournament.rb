module Tournakit
	# +Tournament+s are special +Collection+s where every +Game+ is from the same event. 
	# In a +Tournament+, statistics like standing and ppg are meaningful. 
	class Tournament < Collection

		# Team is only useful in the context of a +Tournament+
		Team = Struct.new(:wins,:losses,:ties,:points,:points_against,:tens,:powers,:interrupts,:tossups_heard,
											:bonuses_heard,:bonus_points,:name,:gp,:pct)

		# the +Tournament+ version of teams provides statistics and +team_id+s
		# @return [Array<Team>] the teams in this tournament, with statistics and standings
		def teams
			@teams ||= @rounds.map(&:teams).flatten.uniq.sort.map do |team|
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
					# make sure the team is in the round, and if it is, put its index in +tid+
					if tid = round.teams.index(team)
						otid = [true,false][tid] ? 1 : 0
						round.score[tid] > round.score[otid] ? t.wins +=1 : t.losses += 1
					end
				end

				t.gp = (t.wins+t.losses+t.ties)
				t.pct = t.wins.to_f / t.gp

				t
			end
			return @teams
		end

		# @param team [String] the name of the team you want info for
		# @return [Integer] the number of games the team won
		def wins(team)
			teams.find{|t|t.name==team}.wins
		end

		# @param team [String] the name of the team you want info for
		# @return [Integer] number of games the team lost
		def losses(team)
			teams.find{|t|t.name==team}.losses
		end

		# @param team [String] the name of the team you want info for
		# @return [Integer] number of games the team was in that ended in a tie
		def ties(team)
			teams.find{|t|t.name==team}.ties
		end

		# @param team [String] the name of the team you want info for
		# @return [Integer] that team's win percentage
		def pct(team)
			teams.find{|t|t.name==team}.pct
		end
	end
end