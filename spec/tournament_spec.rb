require 'spec_helper'
describe Tournakit::Tournament do
	let(:event) { Tournakit::Tournament.new JSON.parse(File.read("data/EXAMPLE/example.tournakit")) }

	describe "::new" do
		it "returns a Tournament, which is a type of Collection" do
			expect(event).to be_a_kind_of Tournakit::Collection
			expect(event).to be_instance_of Tournakit::Tournament
		end
	end

	describe "#team" do
		it "selects a team record" do
			expect(event.team("Chicago A")).to be_instance_of Tournakit::Tournament::Team
			expect(event.team("Chicago A").pct).to be_within(0.1).of(1.0)
		end

		it "returns nil when not found" do
			expect(event.team("Beer")).to be_nil
		end
	end

	describe Tournakit::Tournament::Team do
		describe "#wins" do
			it "reflects how many games the given team has won" do
				expect(event.team("Chicago A").wins).to eq(3)
				expect(event.team("Harvard A").wins).to eq(0)
			end
		end
		describe "#losses" do
			it "reflects how many games the given team has lost" do
				expect(event.team("Chicago A").losses).to eq(0)
				expect(event.team("Minnesota A").losses).to eq(2)
			end
		end
		describe "#ties" do
			it "reflects how many ties there are" do
				pending "totally doesn't actually do anything"
				expect(event.team("Chicago A").ties).to eq(0)
			end
		end
		describe "#pct" do
			it "shows a win percentage" do
				expect(event.team("Chicago A").pct).to be_within(0.01).of(1.0)
				expect(event.team("Minnesota A").pct).to be_within(0.01).of(0.33)
			end
		end

		describe "#tens" do
			it "returns the number of tossups the team got 10 pts on" do
				expect(event.team("Chicago A").tens).to eq 28
				expect(event.team("Harvard A").tens).to eq 18
			end
		end

		describe "#powers" do
			it "returns the number of powers the team got 10 pts on" do
				expect(event.team("Chicago A").powers).to eq 7
				expect(event.team("Minnesota A").powers).to eq 7
			end
		end

		describe "#interrupts" do
			it "returns the number of interrupts the team was penalized on" do
				expect(event.team("Illinois A").interrupts).to eq 6
				expect(event.team("Harvard A").interrupts).to eq 8
			end
		end

		describe "#tossups_heard" do
			it "returns the number of tossups that team heard during the tournament" do
				expect(event.team("Illinois A").tossups_heard).to eq 60
				pending "depends on round#tossups to exist, because right now TUH isn't being stored for a round."
			end
		end

		describe "#pptuh" do
			it "returns the points per tossup heard" do
				expect(event.team("Illinois A").pptuh).to be_within(0.1).of(16.3)
			end
		end

		describe "#ppi" do
			it "returns the powers per interrupts" do
				expect(event.team("Illinois A").ppi).to be_within(0.1).of(1.67)
			end
		end

		describe "#gpi" do
			it "returns the gets (tens+powers) per interrupt" do
				expect(event.team("Minnesota A").gpi).to be_within(0.1).of(4)
			end
		end

		describe "#bonus_points" do
			it "should contain the total bpts" do
				expect(event.team("Chicago A").bonus_points).to eq 770
			end
		end

		describe "#bonuses_heard" do
			it "should contain the # of bonuses heard" do
				expect(event.team("Chicago A").bonuses_heard).to eq 35
			end
		end

		describe "#ppb" do
			it "should contain the bonus conversion" do
				expect(event.team("Chicago A").ppb).to be_within(0.1).of(22.0)
			end
		end

		describe "#ppg" do
			it "calculates ppg" do
				expect(event.team("Illinois A").ppg).to be_within(0.1).of(326.7)
			end
		end

		describe "#papg" do
			it "calculates papg" do
				expect(event.team("Illinois A").papg).to be_within(0.1).of(293.3)
			end
		end

		describe "#mrg" do
			it "calculates win margin" do
				expect(event.team("Illinois A").mrg).to be_within(0.1).of(33.3)
			end
		end

		describe "#players" do
			it "contains the players on that team" do
				expect(event.team("Minnesota A").players).to include a_player_named("Andrew Hart")
			end
		end
	end

	describe Tournakit::Tournament::Player do
		let(:andrew) {event.team("Minnesota A").players.sort_by{|p| p.name}[0]}
		let(:sorice) {event.team("Illinois A").players.find {|p| p.name == "Mike Sorice"}}

		describe "#team" do
			it "contains the team the player is a member of" do
				expect(sorice.team).to eq "Illinois A"
			end
		end

		describe "#tens" do
			it "contains the number of tens that player got" do
				expect(andrew.tens).to eq 4
			end
		end

		describe "#powers" do
			it "contains the number of powers the player got" do
				expect(sorice.powers).to eq 8
			end
		end

		describe "#interrupts" do
			it "contains the number of interrupts the player docked" do
				expect(andrew.interrupts).to eq 1
			end
		end

		describe "#gp" do
			it "contains the number of games the player has played" do
				expect(sorice.gp).to be_within(0.0001).of(3.0)
			end

			it "gives fractions for partial games" do
				pending "no test data has partial games yet"
			end
		end

		describe "#tossups_heard" do
			it "contains the number of tossups the player has heard" do
				expect(sorice.tossups_heard).to eq 60
			end
		end

		describe "#pptuh" do
			it "calculates pptuh" do
				expect(sorice.pptuh).to be_within(0.1).of(3.75)
			end
		end

		describe "#points" do
			it "contains the total points scored by player" do
				expect(sorice.points).to eq 225
			end
		end

		describe "#ppg" do
			it "calculates ppg" do
				expect(andrew.ppg).to be_within(0.01).of(16.67)
			end
		end

		describe "#ppi" do
			it "calculates ppi" do
				expect(andrew.ppi).to be_within(0.01).of(1)
			end
		end

		describe '#gpi' do
			it "calculates gpi" do
				expect(sorice.gpi).to be_within(0.01).of(19)
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