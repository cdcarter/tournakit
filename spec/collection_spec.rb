require 'spec_helper'
describe Tournakit::Collection do
	let(:games) { JSON.load(File.read("data/Czupryn.json")) }
	let(:collection) { Tournakit::Collection.new }

	describe "#teams" do
		it "contains all the team names in the collection" do
			collection.rounds = games
			expect(collection.teams).to have(11).items
		end
		it "returns an array of strings" do
			collection.rounds = games
			expect(collection.teams).to be_instance_of Array
			expect(collection.teams[1]).to be_instance_of String
		end
	end

	describe "#rename_team" do
		it "renames an existing team" do
			collection.rounds = games
			collection.rename_team("Loyola C","Loyola Academy C")
			expect(collection.teams).to_not include("Loyola C")
		end

		it "returns how many teams it renamed" do
			collection.rounds = games
			count = collection.rename_team("Loyola C","LA C")
			expect(count).to eq(2)
		end

		it "returns 0 when no teams with the old name were there" do
			collection.rounds = games
			count = collection.rename_team("Loyola R","LA C")
			expect(count).to eq(0)
		end

		it "doesn't delete anything" do
			collection.rounds = games
			team_num = collection.teams.size
			collection.rename_team("Loyola C","Loyola Academy C")
			expect(collection.teams).to have(team_num).items
		end
	end
end
