module Tournakit
	class Game
		attr_accessor :event, :round, :moderator, :room, :teams, :players, :score, :tossups
	end

	class LilyChenParser
		def initialize(file)
			@spreadsheet = ::Roo::Excel.new(file)
		end

		def parse(round="01")
			sheet = @spreadsheet.sheet(round)
			game = Game.new 
			game.event = sheet.cell("B",1)
			game.round = sheet.cell("B",2)
			game.moderator = sheet.cell("I",2)
			game.room = sheet.cell("O",2)
			game.teams = [sheet.cell("B",3),sheet.cell("K",3)]
			game.players = parse_players(sheet)
			game.score = [sheet.cell("B",26),sheet.cell("K",26)]
			game.tossups = parse_tossups(sheet)
			return game
		end

		def parse_players(sheet)
			team_a = (2..6).map {|col| sheet.cell(4,col)}
			team_b = (11..15).map {|col| sheet.cell(4,col)}
			return [team_a,team_b]
		end

		def parse_tossups(sheet)
			(5..24).map do |trow|
				buzzes = [(2..6).map {|col| sheet.cell(trow,col)},(11..15).map {|col| sheet.cell(trow,col)}]
				bpts = [sheet.cell(trow,"G"),sheet.cell(trow,"P")]
				{:buzzes => buzzes, :bpts => bpts}
			end
		end
	end
end