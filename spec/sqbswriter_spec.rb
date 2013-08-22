require 'spec_helper'

describe Tournakit::SQBSWriter do
	let(:event) { Tournakit::Collection.new JSON.parse(File.read("data/Example Tournament/example.tournakit")) }
	let(:file) { File.read("data/Example Tournament/EXAMPLEsqbs") }

	describe "#sqbs" do
		it "returns a String " do
			writer = Tournakit::SQBSWriter.new(event)
			expect(writer.sqbs).to be_instance_of String
		end
		it "returns data that ostensibly is from the input" do
			writer = Tournakit::SQBSWriter.new(event)
			expect(writer.sqbs.split("\n")).to include "Andrew Hart"
		end
	end
end