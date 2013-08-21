require 'spec_helper'

describe Tournakit::Game do
	let(:game) { Tournakit::Game.parse(File.read("data/SingleRound.json")) }

	describe "::parse" do
		it "parses a single game" do
			expect(game).to be_instance_of Tournakit::Game
			expect(game.teams[0]).to eq "Byron"
		end
	end

	describe "#bonus_stats" do
		it "calculates ppb for both teams" do
			expect(game.bonus_stats[0][:ppb]).to be_instance_of Float
			expect(game.bonus_stats[0][:ppb]).to be_within(0.5).of(7.14)
			expect(game.bonus_stats[1][:ppb]).to be_instance_of Float
			expect(game.bonus_stats[1][:ppb]).to be_within(0.5).of(8.89)
		end

		it "returns an array of hashes" do
			expect(game.bonus_stats).to be_instance_of Array
			expect(game.bonus_stats[0]).to be_instance_of Hash
		end
	end

	describe "#stat_lines" do
		let(:zachline) { {:tens => 4, :negs => 0, :powers => 0, :points => 40}}
		it "gives the stat line for a player by index" do
			expect(game.stat_lines[1][2]).to eq zachline
		end
	end
end

describe JSON, "#load" do
	it "can parse a full set of rounds" do
		games = JSON.load(File.read("data/Czupryn.json"))
		expect(games).to be_instance_of Array
		expect(games.length).to eq 10
		expect(games[3]).to be_instance_of Tournakit::Game
	end
end