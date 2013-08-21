# Tournakit

`Tournakit` is protocol for describing results of mACF quizbowl games, as well as the reference implementation in Ruby. As an added bonus it comes with a parser for Lily Chen's wonderful Excel scoresheets [1].

A `Game` is pretty accurately described in [schema.json]("https://github.com/cdcarter/tournakit/tree/master/schema.json"). 

Once you have a bunch of games loaded, it might be cool to look and see how certain tossups get converted! Or maybe go through and de-dup player names. I dunno. Utilities are coming next.


[1]:https://sites.google.com/site/hchsquizbowl/Home/excel-scoresheets