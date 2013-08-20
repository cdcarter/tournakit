module Tournakit
	class LilyChenParser
		def initialize(file)
			@spreadsheet = ::Roo::Excel.new(file)
		end

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
			return game
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