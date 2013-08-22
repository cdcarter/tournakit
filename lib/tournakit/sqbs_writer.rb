class Tournakit::SQBSWriter
	
	# @return [Tournakit::Collection] the collection of all game results to be included
	attr_accessor :event

	# @param event [Tournakit::Collection] the collection of all game results to be included
	def initialize(event)
		@event = event
	end

	
end