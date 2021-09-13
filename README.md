# [Command Line Pandas Killers](https://xvzftube.xyz/posts/pandas_killers/)

The purpose of this work is to compare some of the popular command line data
manipulation tools. I make an attempt to cover many of the highly used
operations in a data manipulation work flow.

# Conclusion 

No one tool has everything. Here I found strength in diversity. With the
exception of pivots, the popular data manipulation functions were present.

As of 2021 the command line options for data manipulation are strong. Though we
can't do without data manipulation libraries like
`pandas`,`dplyr`,`datatable`,etc., it is nice that we are starting to see more
features ported to the command line. I hope this trend continues in the future.


#### Table 1: Feature Set

tool       |  summary  |  grouped count  |  grouped summary  |  filter  |  slice  |  arrange  |  select-inclusive  |  select-exclusive  |  relocate  |  mutate  |  rename  |  bind_cols  |  bind_rows  |  left_join  |  inner_join  |  full_join  |  pivot_longer  |  pivot_wider
-----------|-----------|-----------------|-------------------|----------|---------|-----------|--------------------|--------------------|------------|----------|----------|-------------|-------------|-------------|--------------|-------------|----------------|-------------
xsv        |  1        |  1              |  1                |  1       |  1      |  1        |  1                 |  1                 |  1         |  0       |  0       |  1          |  1          |  1          |  1           |  1          |  0             |  0
csvtk      |  1        |  1              |  1                |  1       |  1      |  1        |  1                 |  1                 |  1         |  1       |  1       |  0          |  0          |  1          |  1           |  1          |  0             |  0
tsv-utils  |  1        |  1              |  1                |  1       |  0      |  0        |  1                 |  1                 |  1         |  0       |  0       |  0          |  0          |  0          |  0           |  0          |  0             |  0
mlr        |  1        |  1              |  1                |  1       |  1      |  1        |  1                 |  1                 |  1         |  1       |  1       |  0          |  0          |  1          |  0           |  0          |  0             |  0
q          |  1        |  1              |  1                |  1       |  0      |  1        |  1                 |  0                 |  1         |  1       |  1       |  0          |  0          |  1          |  1           |  0          |  0             |  0


#### Table 2: Summary Functions

tool       |  sum  |  min  |  max  |  mean  |  sd  |  median  |  mode  |  cardinality  |  udf
-----------|-------|-------|-------|--------|------|----------|--------|---------------|-----
xsv        |  1    |  1    |  1    |  1     |  1   |  1       |  1     |  1            |  0
csvtk      |  1    |  1    |  1    |  1     |  1   |  1       |  0     |  1            |  0
tsv-utils  |  1    |  1    |  1    |  1     |  1   |  1       |  1     |  1            |  0
mlr        |  1    |  1    |  1    |  1     |  1   |  1       |  1     |  0            |  1
q          |  1    |  1    |  1    |  1     |  0   |  0       |  0     |  1            |  1

# Awards 

I considered comparing the various tools by total features or speed, but I wanted to be a little more creative.
I don't want to influence someone to use or not use a tool based off performance or an arbitrary feature set. 
Also, all of the tools I tested are fantastic! All of them are open source and the package authors/maintainers
volunteer many hours. Each tool is a gift. Be grateful and don't reject a tool because of a couple summary metrics. 

# `xsv`: Stonehenge

This tool feels rock solid and peppy. It has a large feature set. It can
calculate grouped statistics, filter, select, join, etc. It does not lack in
features. I gave it the Stonehenge award because the source code is clean the
tool is compiled, memory safe, and will stand the test of time. In other words,
this tool is not going anywhere.

One thing that felt clunky with this tools was the `--everything` flag when
calculating grouped stats. As far as I am aware the majority of grouped stats
can only be accessed by using this flag. 

# `csvtk`: The Orator

I enjoyed how expressive csvtk is. I also enjoyed that many of the verbs it
used were similar to `dplyr ` verbs `summary`, `rename`, `mutate`. I am big
into the grammar of tools. I think having a language of sorts that makes sense
makes the commands easier to remember. If you think about it, "google-time"
takes longer than compute time in most cases.  A good grammar keeps the
development speed fast. For this reason `csvtk` gets The Orator award

I would like if csvtk removed NAs by default like xsv. They do have an option 
to remove the NAs so this is not much of a problem.

# `tsv-utils`: The Ranger

I thought it was cool to see that `tsv-utils` broke up their dataframe operations into
separate utilities. Because each of the main operations had its own binary they also
had their own man pages. This made it a little easier for me to focus on the syntax of
the specific thing I wanted to do. Like an Archer has a quiver of arrows `tsv-utils` had
a package of utilities. These utilities also had very convenient names like `tsv-select`
or `tsv-filter`. 

A quiver of utilities was not the only thing that earned its place as a Ranger.
Like a Ranger it takes a road less traveled from all of the other utilities. It
works alone in that it does not work on csvs. It only works on tsvs. They
provide a `csv2tsv` utility so this is not an issue. It is just worth pointing
out that this is a pretty big difference.

What tsv-utils does, it does well and very fast. The problem for me was that it
does a lot less than the other utilities. 

# `mlr`: The Scientist

Miller is a big tool. There is not much it can't do. I call it the scientist because it 
provides so much functionality that are of interest to data scientists. Not only does it
do many data manipulation functions, it can also do things like linear regression and 
bootstrap. 

The one part that was unintuitive for me was joins.

# `q`: Defense of the Ancients

`q`s defining characteristic is that it is SQL expressions -- SQL dialects being among
the original ways to manipulate data. Since I have a lot of experience with SQL q was
very natural. For many functions I did not look up the documentation I just tried 
writing SQL and many times it worked.

It is not as feature complete as sql. So don't expect it to be a replacement for a 
formal database language.

