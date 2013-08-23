class Tournakit::SQBSWriter
	
	# @return [Tournakit::Collection] the collection of all game results to be included
	attr_accessor :event

	# @param event [Tournakit::Collection] the collection of all game results to be included
	def initialize(event)
		@event = event
	end

	# builds a SQBS data file based on the imported event
	# @return [String] SQBS formatted data
	def sqbs
		@output = ""
		# write out the number of teams
		@output << event.teams.size.to_s + "\r\n"
		# for each team, write out its size, its name, and its players names
		event.teams.each do |team|
			@output << (event.players(team).size + 1).to_s + "\r\n"
			@output << team + "\r\n"
			@output << event.players(team).join("\r\n") + "\r\n"
		end

		# now write out the number of games
		@output << event.rounds.size.to_s + "\r\n"

		# now its game data time
		@event.rounds.each_with_index do |game,index|
			@output << index.to_s + "\r\n" # the game's unique ID
			@output << @event.teams.index(game.teams[0]).to_s + "\r\n" # the team a index
			@output << @event.teams.index(game.teams[1]).to_s + "\r\n" # the team b index
			@output << game.score[0].to_s + "\r\n" # team a score
			@output << game.score[1].to_s + "\r\n" # team b score
			@output << game.tossups.length.to_s + "\r\n" # number of tossups heard
			@output << game.round.to_s + "\r\n" # round number
			@output << game.bonus_stats[0][:hrd].to_s + "\r\n" # team a bonus heard
			@output << game.bonus_stats[0][:pts].to_s + "\r\n" # team a bonus points
			@output << game.bonus_stats[1][:hrd].to_s + "\r\n" # team b bonus heard
			@output << game.bonus_stats[1][:pts].to_s + "\r\n" # team b bonus points
			@output << ot_tossups(game) #three lines, 1: (0 or 1) OT happened? 2: team a OT tossups answered, 3: team b OT tossups answered
			@output << "0\r\n" # did the game end in forfeit? TODO: support forfeitures
			@output << "0\r\n0\r\n" # two lines of lighting round scores, not supported in mACF
			@output << player_records(game) # the 7 line player blocks for all players
		end

		@output << "1\r\n1\r\n3\r\n0\r\n1\r\n2\r\n254\r\n1\r\n1\r\n1\r\n1\r\n1\r\n1\r\n1\r\n0\r\n0\r\n1\r\n"
		@output << @event.rounds[0].event + "\r\n"
		@output << "\r\n\r\n\r\n\r\n0\r\n_rounds.html\r\n_standings.html\r\n_individuals.html\r\n_games.html\r\n_teamdetail.html\r\n_playerdetail.html\r\n_statkey.html\r\n"
		@output << "\r\n0\r\n4\r\n-1\r\n-1\r\n-1\r\n-1\r\n15\r\n10\r\n-5\r\n0\r\n0\r\n4\r\n0\r\n0\r\n0\r\n0"

		return @output
	end

	private

	def player_records(game)
		out = ""
		(0..7).each {|rep|
			team = 0
			if game.players[team].length > rep
				out << rep.to_s + "\r\n" # player index
				out << "1\r\n" # fraction of game played TODO: support GP...
				out << game.stat_lines[team][rep][:powers].to_s + "\r\n" # number of powers for that player
				out << game.stat_lines[team][rep][:tens].to_s + "\r\n" # number of tens for that player
				out << game.stat_lines[team][rep][:negs].to_s + "\r\n" # number of negs for that player
				out << "0\r\n" #always 0
				out << game.stat_lines[team][rep][:points].to_s + "\r\n" # tossup points for that player
			else
				out << "-1\r\n0\r\n0\r\n0\r\n0\r\n0\r\n0\r\n" #sqbs requires 7 player lines so fill the remaining 7 lines with emptiness
			end
			team = 1
			if game.players[team].length > rep
				out << rep.to_s + "\r\n" # player index
				out << "1\r\n" # fraction of game played TODO: support GP...
				out << game.stat_lines[team][rep][:powers].to_s + "\r\n" # number of powers for that player
				out << game.stat_lines[team][rep][:tens].to_s + "\r\n" # number of tens for that player
				out << game.stat_lines[team][rep][:negs].to_s + "\r\n" # number of negs for that player
				out << "0\r\n" #always 0
				out << game.stat_lines[team][rep][:points].to_s + "\r\n" # tossup points for that player
			else
				out << "-1\r\n0\r\n0\r\n0\r\n0\r\n0\r\n0\r\n" #sqbs requires 7 player lines so fill the remaining 7 lines with emptiness
			end
		}
		return out
	end

	# calculate if there were any OT tossups
	def ot_tossups(game)
		unless (game.tossups.length - 20) > 0
			# no ot happened.
			return "0\r\n0\r\n0\r\n"
		else
			teama=0
			teamb=0
			game.tossups[20..-1].each{
				teama += 1 if tossup[:buzzes][0].any? {|b| b > 0 }
				teamb += 1 if tossup[:buzzes][1].any? {|b| b > 0 }
			}
			return "1\r\n#{teama}\r\n#{teamb}\r\n"
		end
	end
end