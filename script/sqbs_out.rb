require 'tournakit'

EX = Dir["data/Example Tournament/*.xls"].map {|f| Tournakit::LilyChenParser.parse_rounds(f)}.flatten
Tournament = Tournakit::Collection.new(EX)
writer = Tournakit::SQBSWriter.new(Tournament)
File.open("output.qzx","w") {|f| f<< writer.sqbs}