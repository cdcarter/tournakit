require 'tournakit'
require 'yaml'

NTV = Tournakit::Collection.new(JSON.parse(File.read("data/NTV/NTV.json")))

TEAM = "Byron"

puts "Number of players on team #{TEAM}: #{NTV.players(TEAM).size}"
puts "Loading YAML"
names = YAML.load(File.read("script/transient.yaml"))
names[TEAM].each {|hash|
	hash.each {|newname, oldnames|
		oldnames.each {|oldname|
			NTV.rename_player(TEAM,oldname,newname)
			puts "Replacing #{oldname} with #{newname}"
		}
	}
}
puts "Replaced names!"
puts "Number of players on team #{TEAM}: #{NTV.players(TEAM).size}"