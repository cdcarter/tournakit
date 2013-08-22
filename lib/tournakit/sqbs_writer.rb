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
		@output << event.teams.size.to_s + "\n"
		event.teams.each do |team|
			@output << (event.players(team).size + 1).to_s + "\n"
			@output << team + "\n"
			@output << event.players(team).join("\n")
		end

		return @output
	end
end