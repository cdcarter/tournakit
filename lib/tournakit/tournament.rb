module Tournakit
	# +Tournament+s are special +Collection+s where every +Game+ is from the same event. 
	# In a +Tournament+, statistics like standing and ppg are meaningful. 
	class Tournament < Collection

		# Team is only useful in the context of a +Tournament+
		Team = Struct.new(:wins,:losses,:ties,:points,:points_against,:tens,:powers,:interrupts,:tossups_heard,
											:bonuses_heard,:bonus_points,:name,:gp,:pct,:ppg,:papg,:mrg,:pptuh,:ppi,:gpi,:ppb, :players)

		# the +Tournament+ version of teams provides statistics and +team_id+s
		# @return [Array<Team>] the teams in this tournament, with statistics and standings
		def teams
			@teams ||= @rounds.map(&:teams).flatten.uniq.sort.map do |team|
				t = Team.new

				t.players = self.players(team)

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
					# make sure the team is in the round, and if it is, put its index in +tid+, and the other team in +otid+
					if tid = round.teams.index(team)
						otid = [true,false][tid] ? 1 : 0
						round.score[tid] > round.score[otid] ? t.wins +=1 : t.losses += 1

					round.stat_lines[tid].each do |line|
						t.tens += line[:tens]
						t.powers += line[:powers]
						t.interrupts += line[:negs]
					end

					t.tossups_heard += round.tossups.length

					t.points += round.score[tid]
					t.points_against += round.score[otid]

					t.bonuses_heard += round.bonus_stats[tid][:hrd]
					t.bonus_points += round.bonus_stats[tid][:pts]
					end
				end

				t.gp = (t.wins+t.losses+t.ties)
				t.pct = t.wins.to_f / t.gp
				t.ppg = t.points.to_f / t.gp
				t.papg = t.points_against.to_f / t.gp
				t.mrg = (t.points.to_f - t.points_against) / t.gp

				t.pptuh = t.points.to_f / t.tossups_heard
				t.ppi = t.powers.to_f / t.interrupts
				t.gpi = (t.powers+t.tens).to_f / t.interrupts

				t.ppb = t.bonus_points.to_f / t.bonuses_heard

				t
			end
			return @teams
		end


		# Get the stats for a single team.
		# @param team [String] the name of the team
		# @return [Team] the stats for that team
		def team(team)
			teams.find{|t| t.name == team}
		end
	end

end