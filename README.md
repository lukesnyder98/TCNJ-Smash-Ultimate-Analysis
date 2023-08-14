# TCNJ-Smash-Ultimate-Analysis
 An analysis of Glicko rankings of Super Smash Bros. Ultimate players at The College of New Jersey.

Before graduating from The College of New Jersey in 2020, I spent much of my time at the college collecting and maintaining data for Lions Gaming (formerly the Competitive Gaming Club)'s *Super Smash Bros. for Wii U* and *Super Smash Bros. Ultimate* tournaments. This was primarily done through the website braacket.com, on which I created and hosted leagues for *Wii U* and *Ultimate*. The Ultimate league can be found ![here.](https://braacket.com/league/tcnjultimate/ranking) Player rankings used the Glicko algorithm, which is built into the website, and pulled match data from tournaments hosted on challonge.com and start.gg. These rankings were created for each semester and were used as the basis for TCNJ Lions Gaming's *Super Smash Bros.* power rankings.

In this project, I aimed to analyze these rankings using PostgreSQL to discover interesting statistics. First, the rankings were each semester were exported as individual CSV files (another feature built into braacket.com), then they were loaded into pgAdmin, where multiple queries were performed to generate new tables featuring players' peak ranks, players' peak Glicko scores', players who had their peak score/rank before or after the COVID-19 quarantine in 2020, etc. These tables were exported into their own CSV files, which can be found in the query_results folder.

My personal favorite statistic is that the only player whose Glicko score increased from fall 2022 to spring 2023 is flackito, currently the #3 player at TCNJ. At the first biweekly tournament of the semester, he upset #1 seed Ralphie to eventually place 5th, and at King 2023, he took advantage of a somewhat lucky bracket to place 13th, narrowly beating out mrguy321 for the #3 spot. Hopefully his improvement continues into the fall 2023 semester.

This repository may be updated with more queries in the future. For example, I may take a look at results for certain characters, such as average or peak Glicko scores among their players.
