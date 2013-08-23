require 'tournakit'
require 'pp'

all_games = Dir["data/NTV/*.xls"].map {|file| Tournakit::LilyChenParser.parse_rounds(file) }

all_games.flatten!

teams = all_games.map {|g| g.teams}.flatten.uniq!

rounds = []

all_games.group_by(&:round).each{|k,v|
	rounds << {:round => k, :games => v.length}
}

pp rounds

pp teams