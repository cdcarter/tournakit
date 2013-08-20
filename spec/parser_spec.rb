require 'spec_helper'

describe Tournakit::LilyChenParser, "#parse" do
	it "returns a game object when passed a valid spreadsheet" do
		parser = Tournakit::LilyChenParser.new("data/Czupryn.xls")
		result = parser.parse
		result.class.should eq(Tournakit::Game)
	end

	it "returns a game object thats useful" do
		parser = Tournakit::LilyChenParser.new("data/Czupryn.xls")
		result = parser.parse
		result.teams.length.should eq 2
		result.teams[0].should eq "Byron"
	end

	it "supports more than one round on a spreadsheet" do
		parser = Tournakit::LilyChenParser.new("data/Czupryn.xls")
		result = parser.parse("02")
		result.teams.length.should eq 2
		result.teams[0].should eq "Fenton"
	end
end

describe Tournakit::LilyChenParser, "::parse_rounds" do
	it "should parse every worksheet in the file" do
		games = Tournakit::LilyChenParser.parse_rounds("data/Czupryn.xls")
		games.length.should eq 10
	end
	it "should be able to handle the whole data set" do
		all_games = Dir["data/*.xls"].map {|file| Tournakit::LilyChenParser.parse_rounds(file) }
		all_games.length.should eq 12
		all_games[5].length.should eq 10
	end
end