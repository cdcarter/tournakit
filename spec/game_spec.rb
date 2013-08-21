require 'spec_helper'

describe Tournakit::Game, "::parse" do
	let(:game) { Tournakit::Game.parse(File.read("data/SingleRound.json")) }
	it "parses a single game" do
		expect(game).to be_instance_of Tournakit::Game
		expect(game.teams[0]).to eq "Byron"
	end
end

describe Tournakit::Game, "#bonus_stats" do
	it "calculates ppb for both teams" do
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