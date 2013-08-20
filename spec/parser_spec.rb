require 'spec_helper'

describe Tournakit::LilyChenParser, "#parse" do
	it "returns a game object when passed a valid spreadsheet" do
		parser = Tournakit::LilyChenParser.new("data/Czupryn.xls")
		result = parser.parse
		result.class.should eq(Tournakit::Game)
	end
end