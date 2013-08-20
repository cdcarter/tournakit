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
			game.tossups = obj["tossups"].map {|h| {:buzzes => h["buzzes"], :bpts => h["bpts"]}}
			return game
		end


		# Serializes the +Game+ to JSON for storage or wire transfer
		#
		# return:: +String+ of JSON
		def to_json
			JSON.generate(to_hash)
		end

		# Calculate the Bonus Question statistics for each team.
		#
		# Note: this function handles bouncebacks by counting bonus points earned on all tossups, but does not consider bounced back bonuses as heard.
		# I do not remember what the generally accepted method of calculating PPB in a bounceback situation is. So right now, there is no modification, it is purely bpts/bhrd.
		#
		# return:: +Array+ of two +Hash+es with the follwing keys:
		# hrd:: +Integer+ of bonuses heard by the team
		# pts:: +Integer+ of points earned on bonuses by the team
		# ppb:: a +Float+ of the points per bonus for the team
		def bonus_stats
			stats = [{hrd:0, pts:0}, {hrd:0, pts:0}]
			self.tossups.each {|tossup|
				tossup[:buzzes].each_with_index {|buzzline,team|
					stats[team][:hrd] += 1 if buzzline.any? {|buzz| buzz > 0}
				}
				tossup[:bpts].each_with_index {|pts, team|
					stats[team][:pts] += pts
				}
			}
			stats.each {|h|
				h[:ppb] = h[:pts].to_f/h[:hrd].to_f
			}
			return stats
		end

		private
		# return:: a +Hash+ containing all game information
		def to_hash
			{:event => event, :round => round, :moderator => moderator, :room => room, :teams => teams, :players => players, :score => score, :tossups => tossups}
		end
	end
end