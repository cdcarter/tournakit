module Tournakit
	# Game is the main representation of the game of mACF quizbowl.
	#
	# Game objects may be created by hand by your parser class, or through the standard wire format, JSON.
	class Game
		# @return [String] the event name
		attr_accessor :event

		# @return [Integer] the round number
		# @return [Array<Integer,String>] the round number and packet name
		attr_accessor :round

		# @return [String] the name or email of the moderator for the round
		attr_accessor :moderator

		# @return [String] the name or number of the room the round took place in
		attr_accessor :room

		# @return [Array<String>] the names of the two teams in the round, in canonical order
		attr_accessor :teams

		# @return [Array<Array<String>>] arrays of player names or emails
		attr_accessor :players

		# @return [Array<Integer>] team scores
		attr_accessor :score

		# an [Array] of n +Hash+ objects, with two keys. :buzzes contains an +Array+ of two +Array+ of n player lines. :bpts contains an +Array+ of two +Integer+s, containing how many points that team got on the bonus associated with this tossup
		#
		# the :buzzes element will look like 
		#   [[0,0,0,10],[0,0,-5,0]] 
		# for a tossup where the fourth player on team A got 10 pts, and the third player on team B got -5.
		attr_accessor :tossups

		# @return [Array<Hash>] the team bonus stat lines in the form: <br/>
		#   +:hrd+ [Integer] of bonuses heard by the team <br/>
		#   +:pts+ [Integer] of points earned on bonuses by the team <br/>
		#   +:ppb+ [Float] of the points per bonus for the team
		attr_accessor :bonus_stats

		# @return [Array<Array<Hash>>] the player statlines in the form: <br/>
		#   +:points+ [Integer] the total points scored by that player <br/>
		#   +:tens+ [Integer] the number of ten point questions answered correctly by the player <br/>
		#   +:negs+ [Integer] the number of neg-fives docked against the player <br/>
		#   +:powers+ [Integer] the number of questions answered correctly by the player before the powermark
		attr_accessor :stat_lines
		
		# Turns a parsed hash of data into a Game object. For internal use only. You should probably be calling ::parse.
		# @private
		# @param obj [Hash] a hash, supplied by a JSON parser
		# @return [Game] the object
		def self.json_create(obj)
			game = self.new
			game.event = obj["event"]
			game.round = obj["round"]
			game.moderator = obj["moderator"]
			game.room = obj["room"]
			game.teams = obj["teams"]
			game.players = obj["players"]
			game.score = obj["score"]
			game.tossups = obj["tossups"].map {|h| {:buzzes => h["buzzes"], :bpts => h["bpts"]}}
			game.bonus_stats = obj["bonus_stats"].map {|h| {:hrd => h["hrd"], :pts => h["pts"], :ppb => h["ppb"]}}
			game.stat_lines = obj["stat_lines"].map {|team| team.map {|h| {:tens => h["tens"], :powers => h["powers"], :negs => h["negs"], :points => h["points"]}  }}
			return game
		end

		# Converts a JSON Game into a Ruby Game. This currently does not handle errors well.
		#
		# TODO: make sure json is well formed.
		#
		# @param json [String] the JSON representation of a game
		# @return [Game] the loaded object
		def self.parse(json)
			return self.json_create(JSON.parse(json))
		end

		# Serializes the +Game+ to JSON for storage or wire transfer. This does include a "json_class" attribute useful for roundtrip serializing back to Ruby, other parsers may feel free to ignore.
		#
		# @return [String] of JSON
		def to_json(*a)
			to_hash.to_json(*a)
		end

		private
		# @return [Hash] containing all game information
		def to_hash
			{:event => event, :round => round, :moderator => moderator, :room => room, :teams => teams, :players => players, :score => score, :bonus_stats => bonus_stats, :stat_lines => stat_lines, :tossups => tossups, JSON.create_id => self.class.name}
		end
	end
end