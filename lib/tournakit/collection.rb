class Tournakit::Collection

	# @return [Array<Tournakit::Game>] the collection of games (from an event or perhaps packet set) to be worked on
	attr_accessor :rounds

	# @return [Array<String>] all of the team names in the collection
	def teams
		@rounds.map(&:teams).flatten.uniq
	end

	# Renames a team in all Game objects that it was in
	# @param oldname [String] of the team name to be changed
	# @param newname [String] of the name to change to
	# @return [Integer] the number of names that had to be changed
	def rename_team(oldname, newname)
		counter = 0
		@rounds.map! do |game|
			game.teams[game.teams.index(oldname)] = newname if game.teams.index(oldname)
			counter +=1 
			game
		end

		return counter
	end
end