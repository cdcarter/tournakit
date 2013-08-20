module Tournakit
	class Game
		# Game is the main representation of the game of mACF quizbowl.

		attr_accessor :event, :round, :moderator, :room, :teams, :players, :score, :tossups

		# event:: a String containing the event name
		attr_accessor :event

		# round:: an Integer containing the round number, or an Array of [Integer,String]
		attr_accessor :round

		# moderator:: a String containing the round moderator's name or email address
		attr_accessor :moderator

		# room:: a String containing the room name or number
		attr_accessor :room

		# teams:: an Array of two Strings, containing the names of the teams playing. the order these names are in will be used throughout the game object
		attr_accessor :teams

		# players:: an Array of two Arrays, each of size n containing that team's player names or emails.
		attr_accessor :players

		# score:: an Array of two Integers, containing that team's score
		attr_accessor :score

		# tossups:: an array of n Hash objects, with two keys. :buzzes contains an Array of two Arrays of n player lines. :bpts contains an Array of two Integers, containing how many points that team got on the bonus associated with this tossup
		# the :buzzes line will look like 
		#   [[0,0,0,10],[0,0,-5,0]]
		# for a tossup where the fourth player on team A got 10 pts, and the third player on team B got -5.
		attr_accessor :tossups
	end
end