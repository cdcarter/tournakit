module Tournakit
	# +Tournament+s are special +Collection+s where every +Game+ is from the same event. 
	# In a +Tournament+, statistics like standing and ppg are meaningful. 
	class Tournament < Collection

		# Team is only useful in the context of a +Tournament+
		Team = Struct.new(:wins,:losses,:ties,:points,:points_against,:tens,:powers,:interrupts,:tossups_heard,
											:bonuses_heard,:bonus_points,:name,:gp,:pct,:ppg,:papg,:mrg)

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
					end
				end

				t.gp = (t.wins+t.losses+t.ties)
				t.pct = t.wins.to_f / t.gp
				t.ppg = t.points.to_f / t.gp
				t.papg = t.points_against.to_f / t.gp
				t.mrg = (t.points.to_f - t.points_against) / t.gp

				t
			end
			return @teams
		end

		# @param team [String] the name of the team you want info for
		# @return [Integer] the number of games the team won
		def wins(team)
			teams.find{|t|t.name==team}.wins
		end

		# @param (see #wins)
		# @return [Integer] number of games the team lost
		def losses(team)
			teams.find{|t|t.name==team}.losses
		end

		# @param (see #wins)
		# @return [Integer] number of games the team was in that ended in a tie
		def ties(team)
			teams.find{|t|t.name==team}.ties
		end

		# @param (see #wins)
		# @return [Integer] that team's win percentage
		def pct(team)
			teams.find{|t|t.name==team}.pct
		end

		# @param (see #wins)
		# @return [Integer] the number of ten point tossups earned
		def tens(team)
			teams.find{|t|t.name==team}.tens
		end

		# @param (see #wins)
		# @return [Integer] the number of poweers earned
		def powers(team)
			teams.find{|t|t.name==team}.powers
		end

		# @param (see #wins)
		# @return [Integer] the number of interrupts penalized against that team
		def interrupts(team)
			teams.find{|t|t.name==team}.interrupts
		end

		# @param (see #wins)
		# @return [Integer] the number of tossups heard over the tournament
		def tossups_heard(team)
			teams.find{|t|t.name==team}.tossups_heard
		end

		# @param (see #wins)
		# @return [Integer] the win margin of the team
		def mrg(team)
			teams.find{|t|t.name==team}.mrg
		end

		# @param (see #wins)
		# @return [Integer] the average number of points scored against the team
		def papg(team)
			teams.find{|t|t.name==team}.papg
		end

		# @param (see #wins)
		# @return [Integer] the average number of points scored by the team
		def ppg(team)
			teams.find{|t|t.name==team}.ppg
		end
	end
end