class Tournakit::Collection

	include Enumerable

	# @return [Array<Tournakit::Game>] the collection of games (from an event or perhaps packet set) to be worked on
	attr_accessor :rounds

	# @param rounds [Array<Tournakit::Game>] the rounds for this collection
	def initialize(rounds=[])
		@rounds=rounds
	end

	# defer this call to the +rounds+ [Array<Tournakit::Game>]
	def each(*args,&blk)
		@rounds.each(*args,&blk) 
	end

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
			if game.teams.index(oldname)
				game.teams[game.teams.index(oldname)] = newname 
				counter +=1 
			end
			game
		end

		return counter
	end
end