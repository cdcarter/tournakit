module Tournakit
	# +Tournament+s are special +Collection+s where every +Game+ is from the same event. 
	# In a +Tournament+, statistics like standing and ppg are meaningful. 
	class Tournament < Collection

		# Team is only useful in the context of a +Tournament+
		Team = Struct.new(:wins,:losses,:ties,:points,:points_against,:tens,:powers,:interrupts,:tossups_heard,
											:bonuses_heard,:bonus_points,:name,:gp,:pct,:ppg,:papg,:mrg,:pptuh,:ppi,:gpi,:ppb, :players)
		class Team
		# @!attribute wins
		# 	@return [Integer] the number of games that team has won
		# @!attribute losses
		#   @return [Integer] the number of games that team has lost
		# @!attribute ties
		#   @return [Integer] the number of games that team tied in
		# @!attribute points
		#   @return [Integer] the total number of points that team earned
		# @!attribute points_against
		#   @return [Integer] the total number of points scored against that team
		# @!attribute tens
		#   @return [Integer] the number of 10 point tossups answered correctly by that team
		# @!attribute powers
		#   @return [Integer] the number of tossups that the team powered
		# @!attribute interrupts
		#   @return [Integer] the number of interrupts the team was penalized for
		# @!attribute tossups_heard
		#   @return [Integer] the number of tossups the team heard over the tournament
		# @!attribute bonuses_heard
		#   @return [Integer] the number of bonus questions the team heard over the tournament
		# @!attribute bonus_points
		#   @return [Integer] the number of bonus points the team earned
		# @!attribute name
		#   @return [String] the name of the team
		# @!attribute gp
		#   @return [Float] the number of games the team played
		# @!attribute pct
		#   @return [Floar] the percentage of games the team won during the tournament
		# @!attribute ppg
		#   @return [Float] the average number of points scored in a game by the team
		# @!attribute papg
		#   @return [Float] the avergae number of points scored against the team during the tournament
		# @!attribute mrg
		#   @return [Float] the average win margin for the team
		# @!attribute pptuh
		#   @return [Float] the average number of points scored per tossup heard
		# @!attribute ppi
		#   @return [Float] the ratio of powers to interrupts for the team
		# @!attribute gpi
		#   @return [Float] the ratio of gets (that is, the number of tossups correctly answered for 10 or 15 pts) to interrupts
		# @!attribute ppb
		#   @return [Float] the the number of bonus points earned per bonus heard. 30 is a perfect score.
		# @!attribute players
		#   @return [Array<Player>] the players on the team
		end

		# Player is also a data structure for use in a Tournament, but not a part of the Tournakit wire format
		class Player < Struct.new(:name, :team, :gp, :tens, :powers, :interrupts, :tossups_heard, :points,
															:pptuh, :ppi, :gpi, :ppg)
		# @!attribute name
		#   @return [String] the name of the player
		# @!attribute team
		#   @return [String] the name of the player's team
		# @!attribute gp
		#   @return [Float] the number of games the player played
		# @!attribute tens
		#   @return [Integer] the number of regular tossups the player answered
		# @!attribute powers
		#   @return [Integer] the number of powers the player earned
		# @!attribute interrupts
		#   @return [Integer] the number of interrupts the player was penalized
		# @!attribute tossups_heard
		#   @return [Integer] the number of tossups the player heard
		# @!attribute points
		#   @return [Integer] the total number of points the player earned over the tournament
		# @!attribute pptuh
		#   @return [Float] the number of points earned per tossups played
		# @!attribute ppi
		#   @return [Float] the ratio of powers to interrupts
		# @!attribute gpi
		#   @return [Float] the ratio of gets (that is, the number of tossups correctly answered for 10 or 15 pts) to interrupts
		# @!attribute ppg
		#   @return [Float] the average number of tossup points scored per game by that player
		end


		def initialize(*args)
			super(*args)
			calculate_stats
		end

		# @return [Array<Team>] the teams in this tournament, with statistics and standings 
		attr_reader :teams

		# Calculate the stats for the tournament
		def calculate_stats
			@teams = @rounds.map(&:teams).flatten.uniq.sort.map do |team|
				t = Team.new

				t.players = self.players(team).map {|p| Player.new(p)}

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

		end


		# Get the stats for a single team.
		# @param team [String] the name of the team
		# @return [Team] the stats for that team
		def team(team)
			teams.find{|t| t.name == team}
		end
	end

end