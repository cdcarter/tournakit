# Tournakit

*TOURNAKIT IS RAPIDLY CHANGING - Contact cdcarter for details on anything in the ecosystem. YARD docstrings should be up to date, and all specs are passing, so check them for things. The scripts are always kept up to date as well.*

`Tournakit` is format for describing results of mACF quizbowl games, as well as the reference implementation in Ruby. As an added bonus it comes with a parser for Lily Chen's wonderful [Excel scoresheets][1].

A `Game` is pretty accurately described in [schema.json][2]. 

## Why is this useful?
First of all, it just sets a standard for computer interchange of mACF results. If more than one quizbowl computer program uses this format, the programs can easily share data and or talk to each other.

Second, with the included parser (and more to come, with any luck!) it's easy to load entire tournaments worth of data into a format where they can easily be fooled around with. It's relatively easy with the stock Tournakit install to load a full tournament and get detailed tossup conversion stats. With slight modifications, one could track tossup category/player stats, or even bonus part conversions. The goal of the reference implementation is to build a toolkit for more detailed stat work like this.

## Included...
The `data/` folder includes the entire corpus of scoresheets from the standard bracket of 2010 New Trier Varsity, via Jonah Greenthal. This tournament was a mirror of the 2010 GSAC. The stats can be found on the IHSSBCA website, [here][3]. Thanks Jonah!

An [example script][4] is also included to show how you could use this to quickly calculate full tossup conversion stats for your tournament, automatically, from many scoresheet files.

## Whats next?
Check the issues tracker.

[1]:https://sites.google.com/site/hchsquizbowl/Home/excel-scoresheets
[2]:https://github.com/cdcarter/tournakit/tree/master/schema.json
[3]:http://www.ihssbca.org/statistics/2010_NTV_ADVANTAGE/2010_NTV_standard_prelims_standings.php
[4]:https://github.com/cdcarter/tournakit/tree/master/script/event.rb
