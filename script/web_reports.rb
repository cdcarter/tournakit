require 'tournakit'
require 'erb'
require 'webrick'

EX = Dir["data/EXAMPLE/*.xls"].map {|f| Tournakit::LilyChenParser.parse_rounds(f)}.flatten
ETournament = Tournakit::Tournament.new(EX)

class WebStandings
	def initialize(event)
		@event = event
	end

	def get_binding
		binding
	end

	def teams
		@event.teams.sort_by {|team| team.pct }.reverse
	end

	def event
		@event.rounds[0].event
	end
end

r = WebStandings.new(ETournament)
standings = ERB.new(File.read("templates/standings.erb.html"))
result = standings.result(r.get_binding)
server = WEBrick::HTTPServer.new(:Port => 8000)
server.mount_proc '/' do |req, res| res.body = result end
trap 'INT' do server.shutdown end

server.start
