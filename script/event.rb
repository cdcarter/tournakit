require 'tournakit'
require 'pp'

all_games = Dir["data/*.xls"].map {|file| Tournakit::LilyChenParser.parse_rounds(file) }

all_games.flatten!

teams = all_games.map {|g| g.teams}.flatten.uniq!


round1 = all_games.group_by(&:round)[1] 

tossup_stats = Array.new(20) {{tens:0,negs:0,powers:0}}

round1.map do |game| 
	game.tossups.each_with_index do |tossup, tossup_idx|
		tossup[:buzzes].flatten.each do |buzz|
			case buzz
			when 10
				tossup_stats[tossup_idx][:tens] += 1
			when 15
				tossup_stats[tossup_idx][:powers] += 1
			when -5
				tossup_stats[tossup_idx][:negs] += 1
			end
		end
	end
end

pp tossup_stats

pp teams