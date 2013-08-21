module Tournakit
	class LilyChenParser

		# a +String+ containing a path to an +.xls+ workbook
		attr_accessor :file

		# Parse an entire Excel workbook into Game objects.
		#
		# file:: a +String+ containing a path to a workbook with many sheets, each of which contains a round of mACF quizbowl
		# return:: an +Array+ of n Game objects
		def self.parse_rounds(file)
			ss = self.new(file)
			ss.rounds.map {|round| ss.parse(round) }
		end

		# Create a new parser object
		def initialize(file)
			@file = file
			@spreadsheet = ::Roo::Excel.new(file)
		end

		# Returns a list of the names of the sheets in the workbook, which are assumed to be round labels.
		#
		# return:: +Array+
		def rounds
			@spreadsheet.sheets
		end

		# Parses a LilyChen Scoresheet into a Game object.
		#
		# round:: a +String+ with the name of the sheet to be parsed, or an +Integer+ with the index of that round
		# return:: a Game object of that round
		def parse(round="01")
			sheet = @spreadsheet.sheet(round)
			game = Game.new 
			game.event = sheet.cell("B",1)
			game.round = sheet.cell("B",2).to_i
			game.moderator = sheet.cell("I",2)
			game.room = sheet.cell("O",2).to_s
			game.teams = [sheet.cell("B",3),sheet.cell("K",3)]
			game.players = parse_players(sheet)
			game.score = [sheet.cell("B",26).to_i,sheet.cell("K",26).to_i]
			game.tossups = parse_tossups(sheet)
			game.stat_lines = parse_stat_lines(sheet)
			game.bonus_stats = parse_bonus_stats(sheet,game)
			return game
		end

		private
		def parse_stat_lines(sheet)
			
		end

		def parse_bonus_stats(sheet,game)
			stats = [{pts: sheet.cell("G",33).to_i, ppb: sheet.cell("B",34), hrd:0 },
							 {pts: sheet.cell("P",33).to_i, ppb: sheet.cell("K",34), hrd:0 }]
			game.tossups.each {|tossup|
				tossup[:buzzes].each_with_index {|buzzline,team|
					stats[team][:hrd] += 1 if buzzline.any? {|buzz| buzz > 0}
				}
				tossup[:bpts].each_with_index {|pts, team|
					stats[team][:pts] += pts
				}
			}
			return stats
		end

		def parse_players(sheet)
			team_a = (2..6).map {|col| sheet.cell(4,col)}
			team_b = (11..15).map {|col| sheet.cell(4,col)}
			return [team_a,team_b]
		end

		def parse_tossups(sheet)
			(5..24).map do |trow|
				buzzes = [(2..6).map {|col| sheet.cell(trow,col).to_i},(11..15).map {|col| sheet.cell(trow,col).to_i}]
				bpts = [sheet.cell(trow,"G").to_i,sheet.cell(trow,"P").to_i]
				{:buzzes => buzzes, :bpts => bpts}
			end
		end
	end
end