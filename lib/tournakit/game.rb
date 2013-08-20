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

		# Converts a JSON Game into a Ruby Game. This currently does not handle errors well.
		#
		# TODO: make sure json is well formed.
		#
		# json:: +String+ of JSON containing a game
		# return:: +Game+ object
		def self.parse(json)
			obj = JSON.parse(json)
			game = self.new
			game.event = obj["event"]
			game.round = obj["round"]
			game.moderator = obj["moderator"]
			game.room = obj["room"]
			game.teams = obj["teams"]
			game.players = obj["players"]
			game.score = obj["score"]
			game.tossups = obj["tossups"]
		end
	end
end