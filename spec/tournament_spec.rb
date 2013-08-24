require 'spec_helper'
describe Tournakit::Tournament do
	let(:event) { Tournakit::Tournament.new JSON.parse(File.read("data/EXAMPLE/example.tournakit")) }

	describe "::new" do
		it "returns a Tournament, which is a type of Collection" do
			expect(event).to be_a_kind_of Tournakit::Collection
			expect(event).to be_instance_of Tournakit::Tournament
		end
	end

	describe "standings methods" do
		describe "#wins" do
			it "reflects how many games the given team has won" do
				expect(event.wins("Chicago A")).to eq(3)
				expect(event.wins("Harvard A")).to eq(0)
			end
		end
		describe "#losses" do
			it "reflects how many games the given team has lost" do
				expect(event.losses("Chicago A")).to eq(0)
				expect(event.losses("Minnesota A")).to eq(2)
			end
		end
		describe "#ties" do
			it "reflects how many ties there are" do
				pending "totally doesn't actually do anything"
				expect(event.ties("Chicago A")).to eq(0)
			end
		end
		describe "#pct" do
			it "shows a win percentage" do
				expect(event.pct("Chicago A")).to be_within(0.01).of(1.0)
				expect(event.pct("Minnesota A")).to be_within(0.01).of(0.33)
			end
		end
	end

	describe "tossup methods" do
		describe "#tens" do
			it "returns the number of tossups the team got 10 pts on" do
				expect(event.tens "Chicago A").to eq 28
				expect(event.tens "Harvard A").to eq 18
			end
		end

		describe "#powers" do
			it "returns the number of powers the team got 10 pts on" do
				expect(event.powers "Chicago A").to eq 7
				expect(event.powers "Minnesota A").to eq 7
			end
		end

		describe "#interrupts" do
			it "returns the number of interrupts the team was penalized on" do
				expect(event.interrupts "Illinois A").to eq 6
				expect(event.interrups "Harvard A").to eq 8
			end
		end

		describe "#tossups_heard" do
			it "returns the number of tossups that team heard during the tournament" do
				expect(event.tuh "Illinois A").to eq 60
			end
		end
	end

	describe "#teams" do
		it "provides an array of teams in the tournament" do
			expect(event.teams).to have(4).teams
			expect(event.teams[0].name).to eq("Chicago A")
		end
	end
end