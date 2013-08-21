module Tournakit
	# Game is the main representation of the game of mACF quizbowl.
	#
	# Game objects may be created by hand by your parser class, or through the standard wire format, JSON.
	class Game
		# a +String+ containing the event name
		attr_accessor :event

		# an +Integer+ containing the round number, or an +Array+ of +[Integer,String]+
		attr_accessor :round

		# a +String+ containing the round moderator's name or email address
		attr_accessor :moderator

		# a +String+ containing the room name or number
		attr_accessor :room

		# an +Array+ of two Strings, containing the names of the teams playing. the order these names are in will be used throughout the game object
		attr_accessor :teams

		# an +Array+ of two +Arrays+, each of size n containing that team's player names or emails.
		attr_accessor :players

		# an +Array+ of two +Integers+, containing that team's score
		attr_accessor :score

		# an +Array+ of n +Hash+ objects, with two keys. :buzzes contains an +Array+ of two +Array+ of n player lines. :bpts contains an +Array+ of two +Integer+s, containing how many points that team got on the bonus associated with this tossup
		#
		# the :buzzes element will look like 
		#   [[0,0,0,10],[0,0,-5,0]] 
		# for a tossup where the fourth player on team A got 10 pts, and the third player on team B got -5.
		attr_accessor :tossups

		# [Array<Hash,Hash>] with keys
		#   * :+hrd+ [Integer] of bonuses heard by the team
		#   * :+pts+ [Integer] of points earned on bonuses by the team
		#   * :+ppb+ [Float] of the points per bonus for the team
		attr_accessor :bonus_stats

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

		# @overload stat_line(team_idx,player_idx)
		#   Returns the statline for a player by index.
		#   @param team_idx [Integer] +0+ or +1+, indicating which of the two teams in the round the player is on
		#   @param player_idx [Integer] index of the player, as in the order they are in the +@players+ array
		# @overload stat_line(name)
		#   Returns the statline for a player given their name.
		#   @param name [String] the name of a player in the round.
		# 
		# @return [Hash] of the statline
		#  * +:tens+ [Integer] of tens earned
		#  * +:powers+ [Integer] of powers earned
		#  * +:negs+ [Integer] of negs racked up
		#  * +:points+ [Integer] of total points scored by player
		def stat_line(*args)
		end

		private
		# @return [Hash] containing all game information
		def to_hash
			{:event => event, :round => round, :moderator => moderator, :room => room, :teams => teams, :players => players, :score => score, :bonus_stats => bonus_stats, :tossups => tossups, JSON.create_id => self.class.name}
		end
	end
end