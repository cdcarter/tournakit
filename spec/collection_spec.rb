require 'spec_helper'
describe Tournakit::Collection do
	let(:games) { JSON.load(File.read("data/Czupryn.json")) }
	let(:collection) { Tournakit::Collection.new }

	describe "#teams" do
		it "should contain all the team names in the collection" do
			collection.rounds = games
			expect(collection.teams.size).to eq(11)
		end
		it "should return an array of strings" do
			collection.rounds = games
			expect(collection.teams).to be_instance_of Array
			expect(collection.teams[1]).to be_instance_of String
		end
	end
end
