require 'spec_helper'
describe Tournakit::Tournament do
	let(:event) { Tournakit::Tournament.new JSON.parse(File.read("data/EXAMPLE/example.tournakit")) }

	describe "::new" do
		it "returns a Tournament, which is a type of Collection" do
			expect(event).to be_a_kind_of Tournakit::Collection
			expect(event).to be_instance_of Tournakit::Tournament
		end
	end

	describe "#wins" do
		it "returns how many games the given team has won" do
			expect(event.wins("Chicago A")).to eq(3)
			expect(event.wins("Harvard A")).to eq(0)
		end
	end

	describe "#teams" do
		it "provides an array of teams in the tournament" do
			expect(event.teams).to have(4).teams
			expect(event.teams[0].name).to eq("Chicago A")
		end
	end
end