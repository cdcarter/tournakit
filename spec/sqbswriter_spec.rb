require 'spec_helper'

describe Tournakit::SQBSWriter do
	let(:event) { Tournakit::Collection.new JSON.parse(File.read("data/EXAMPLE/example.tournakit")) }
	let(:file) { File.read("data/EXAMPLE/EXAMPLEsqbs") }

	describe "#sqbs" do
		it "returns a String " do
			writer = Tournakit::SQBSWriter.new(event)
			expect(writer.sqbs).to be_instance_of String
		end
		it "returns data that ostensibly is from the input" do
			writer = Tournakit::SQBSWriter.new(event)
			expect(writer.sqbs.split("\r\n")).to include "Andrew Hart"
		end
	end
end