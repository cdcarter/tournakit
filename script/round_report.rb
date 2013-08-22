require 'tournakit'
require 'erb'
require 'webrick'

EX = Dir["data/Example Tournament/*.xls"].map {|f| Tournakit::LilyChenParser.parse_rounds(f)}.flatten
Tournament = Tournakit::Collection.new(EX)

class RoundStats
	def initialize(data,round)
		@data = data
		@round = round
		@event = data.rounds[0].event
	end

	def games
		@games ||= @data.rounds.select {|r| r.round == @round }
	end

	def ppg
		scores = games.map(&:score).flatten
		avg = scores.inject(0){|memo, el| memo + el }.to_f / scores.size
		return ("%.2f" % avg)
	end

	def ppb
		stats = games.map(&:bonus_stats).flatten
		pts = 0
		hrd = 0
		stats.each {|g|
			pts += g[:pts]
			hrd += g[:hrd]
		}
		avg = pts.to_f/hrd.to_f
		return ("%.2f" % avg)
	end

	def tossups
		val = Array.new(20) {{heard:0,converted:0,powered:0,negged:0}}
		(0..19).each do |tossup|
			games.each do |game|
				val[tossup][:heard] += 1
				buzzes = game.tossups[tossup][:buzzes].flatten
				if buzzes.include? -5
					val[tossup][:negged] += 1
				end
				if buzzes.include? 15
					val[tossup][:powered] += 1
					val[tossup][:converted] += 1
				end
				if buzzes.include? 10
					val[tossup][:converted] += 1
				end
			end
		end
		return val
	end

	def get_binding
		binding
	end
end

r = RoundStats.new(Tournament,1)
template = ERB.new(DATA.read)
result = template.result(r.get_binding)
server = WEBrick::HTTPServer.new(:Port => 8000)
server.mount_proc '/' do |req, res| res.body = result end
trap 'INT' do server.shutdown end

server.start

__END__
<html>
<head><title><%= @event %> Round Report</title>
<link rel="stylesheet" href="http://bootswatch.com/spacelab/bootstrap.min.css"></head>
<body>
	<div class="container">
	<h1>Round Report for <%= @round %></h1>

	<h2>General Stats</h2>
	<table class="table">
		<tr><td>Average PPG</td><td><%= ppg %></td></tr>
		<tr><td>Average PPB</td><td><%= ppb %></td></tr>
	</table>

	<h2>Conversion Stats</h2>
	<table class="table">
		<tr><th>Tossup</th><th># times heard</th><th># Converted</th><th># Powered</th><th># Negged</th></tr>
		<% tossups.each_with_index do |tossup,idx| %>
		<tr><td><%=idx+1%></td><td><%=tossup[:heard]%></td><td><%=tossup[:converted]%></td><td><%=tossup[:powered]%></td><td><%=tossup[:negged]%></td></tr>
		<% end %>
	</table>
	</div>
</body>
</html>