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
			game.bonus_stats, game.stat_lines = parse_stats(sheet,game)
			return game
		end

		private
		def parse_stat_lines(sheet)
			
		end

		def parse_stats(sheet,game)
			bonus_stats = [{pts: sheet.cell("G",33).to_i, ppb: sheet.cell("B",34), hrd:0 },
							 {pts: sheet.cell("P",33).to_i, ppb: sheet.cell("K",34), hrd:0 }]
			stat_lines = [Array.new(game.players[0].size) { {tens: 0, powers: 0, points:0, negs:0}}, Array.new(game.players[1].size){ {tens: 0, powers: 0, points:0, negs:0}}]
			game.tossups.each {|tossup|
				tossup[:buzzes].each_with_index {|buzzline,team|
					buzzline.each_with_index { |buzz,player|
						# if any player scored on this TU, then that team heard a bonus.
						if buzz > 0
							bonus_stats[team][:hrd] += 1
						end
						case buzz
						when 10
							stat_lines[team][player][:tens] += 1
							stat_lines[team][player][:points] += 10
						when 15
							stat_lines[team][player][:powers] += 1
							stat_lines[team][player][:points] += 15
						when -5
							stat_lines[team][player][:negs] += 1
							stat_lines[team][player][:points] -= 5
						end
					}
				}
				tossup[:bpts].each_with_index {|pts, team|
					bonus_stats[team][:pts] += pts
				}
			}
			return [bonus_stats, stat_lines]
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