require 'spec_helper'

describe Tournakit::LilyChenParser, "#parse" do
	let(:parser) { Tournakit::LilyChenParser.new("data/Czupryn.xls") }
	let(:result) { parser.parse }

	it "returns a game object when passed a valid spreadsheet" do
		expect(result).to be_instance_of Tournakit::Game
	end

	it "returns a game object thats useful" do
		expect(result.teams.length).to eq 2
		expect(result.teams[0]).to eq "Byron"
	end

	it "supports more than one round on a spreadsheet" do
		result2 = parser.parse("02")
		expect(result2.teams.length).to eq 2
		expect(result2.teams[0]).to eq "Fenton"
	end
end

describe Tournakit::LilyChenParser, "::parse_rounds" do
	it "parses every worksheet in the file" do
		games = Tournakit::LilyChenParser.parse_rounds("data/Czupryn.xls")
		expect(games.length).to eq 10
	end

	# skipped by default cause it sucks
	it "is able to handle the whole data set", :skip => true do
		all_games = Dir["data/*.xls"].map {|file| Tournakit::LilyChenParser.parse_rounds(file) }
		expect(all_games.length).to eq 12
		expect(all_games[5].length).to eq 10
	end
end