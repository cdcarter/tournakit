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