# Table of Contents
# --------------------------------------------------------
## Summarize Rows
### [ ] summary
### [ ] grouped count
### [ ] grouped summary 
## Extract Rows
### [ ] inclusive filter
### [ ] exclusive filter
### [ ] distinct 
### [ ] slice
### [ ] arrange low to high
### [ ] arrange high to low
## Extract columns
### [ ] select 
### [ ] relocate/reorder
### [ ] mutate (new column as function of other column(s))
### [ ] rename
## Combine Tables
### [ ] bind cols
### [ ] bind rows
### [ ] left join
### [ ] inner join
### [ ] full join

cat <<EOF >data/tool_features.csv
tool,function,available
xsv,summary,1
xsv,grouped count,1
xsv,grouped summary,1
xsv,filter,1
xsv,slice,1
xsv,arrange,1
xsv,select-inclusive,1
xsv,select-exclusive,1
xsv,relocate,1
xsv,mutate,0
xsv,rename,0
xsv,bind_cols,1
xsv,bind_rows,1
xsv,left_join,1
xsv,inner_join,1
xsv,full_join,1
xsv,pivot_longer,0
xsv,pivot_wider,0
csvtk,summary,1
csvtk,grouped count,1
csvtk,grouped summary,1
csvtk,filter,1
csvtk,slice,1
csvtk,arrange,1
csvtk,select-inclusive,1
csvtk,select-exclusive,1
csvtk,relocate,1
csvtk,mutate,1
csvtk,rename,1
csvtk,bind_cols,0
csvtk,bind_rows,0
csvtk,left_join,1
csvtk,inner_join,1
csvtk,full_join,1
csvtk,pivot_longer,0
csvtk,pivot_wider,0
tsv-utils,summary,1
tsv-utils,grouped count,1
tsv-utils,grouped summary,1
tsv-utils,filter,1
tsv-utils,slice,0
tsv-utils,arrange,0
tsv-utils,select-inclusive,1
tsv-utils,select-exclusive,1
tsv-utils,relocate,1
tsv-utils,mutate,0
tsv-utils,rename,0
tsv-utils,bind_cols,0
tsv-utils,bind_rows,0
tsv-utils,left_join,0
tsv-utils,inner_join,0
tsv-utils,full_join,0
tsv-utils,pivot_longer,0
tsv-utils,pivot_wider,0
mlr,summary,1
mlr,grouped count,1
mlr,grouped summary,1
mlr,filter,1
mlr,slice,1
mlr,arrange,1
mlr,select-inclusive,1
mlr,select-exclusive,1
mlr,relocate,1
mlr,mutate,1
mlr,rename,1
mlr,bind_cols,0
mlr,bind_rows,0
mlr,left_join,1
mlr,inner_join,0
mlr,full_join,0
mlr,pivot_longer,0
mlr,pivot_wider,0
q,summary,1
q,grouped count,1
q,grouped summary,1
q,filter,1
q,slice,0
q,arrange,1
q,select-inclusive,1
q,select-exclusive,0
q,relocate,1
q,mutate,1
q,rename,1
q,bind_cols,0
q,bind_rows,0
q,left_join,1
q,inner_join,1
q,full_join,0
q,pivot_longer,0
q,pivot_wider,0
EOF
cat data/tool_features.csv | tv -n 50



# Pandas Killers Competitors
# --------------------------------------------------------
#### [ ] xsv
#### [ ] csvtk
#### [ ] tsv-utils
#### [ ] mlr (miller)
#### [ ] q

# Available summary functions
# --------------------------------------------------------
# type,sum,min,max,min_length,max_length,mean,stddev,median,mode,cardinality

cat <<EOF >data/summary_options.csv
tool, function, available
xsv, sum, 1
xsv, min, 1
xsv, max, 1
xsv, mean, 1
xsv, sd, 1
xsv, median, 1
xsv, mode, 1
xsv, cardinality, 1
xsv, udf, 0
csvtk, sum, 1
csvtk, min, 1
csvtk, max, 1
csvtk, mean, 1
csvtk, sd, 1
csvtk, median, 1
csvtk, mode, 0
csvtk, cardinality, 1
csvtk, udf, 0
tsv-utils, sum, 1
tsv-utils, min, 1
tsv-utils, max, 1
tsv-utils, mean, 1
tsv-utils, sd, 1
tsv-utils, median, 1
tsv-utils, mode, 1
tsv-utils, cardinality, 1
tsv-utils, udf, 0
mlr, sum, 1
mlr, min, 1
mlr, max, 1
mlr, mean, 1
mlr, sd, 1
mlr, median, 1
mlr, mode, 1
mlr, cardinality, 0
mlr, udf, 1
q, sum, 1
q, min, 1
q, max, 1
q, mean, 1
q, sd, 0
q, median, 0
q, mode, 0
q, cardinality, 1
q, udf, 1
EOF
cat data/summary_options.csv | tv -n 50


# Code
# --------------------------------------------------------

df='data/weather.csv'

## Summarize Rows
### summary (sum, min, max, mean, stddev, median, mode, cardinality)
#### [ ] xsv

# field,type,sum,min,max,min_length,max_length,mean,stddev,median,mode,cardinality
# xsv gives the option of showing median, cardinality, and mode via a flag
# other summary stats are obtained using the `--everything` flag.
# I think it is a little clunky that some arbitrary stats have individual flags
# and others are only possible to get to using the `--everything` flag.
# For stats of interests the summary table could be trimmed down by using
# selection on the columns.
# xsv performs automatic null removal in summary. If this is not wanted the
# nulls may be included with a flag
xsv stats -s temp,humid --everything $df

#### [ ] csvtk
# I like the colon syntax. `mode` is not part of the summary functions.
# NAs are not ignored by defauls. They can be ignored with `--ignore-non-numbers`
# summary may result in long lines. I am not aware of a way to break up the line length
# summary stats are clear and explicit.
csvtk summary -f temp:sum,temp:min,temp:max,temp:mean,temp:stdev,temp:median,temp:countunique,humid:sum,humid:min,humid:max,humid:mean,humid:stdev,humid:median,humid:countunique\
  --ignore-non-numbers $df |\
  tv

#### [ ] tsv-utils
# tsv-utils requires the extra overhead of converting csv to tsv
# tsv-utils does not think NAs are missing values. It treats them as characters.
# I used sed for NA replace
# -auto NA replace
csv2tsv data/weather.csv > data/weather.tsv
df_tsv='data/weather.tsv'

sed 's/NA//g' $df_tsv |\
  tsv-summarize --x --header --sum temp,humid --min temp,humid --max temp,humid \
  --stdev temp,humid --median temp,humid --mode temp,humid --unique-count temp,humid| tsv-pretty


#### [ ] mlr (miller)
# Like tsv-utils I did not see an options to exclude "NA" strings.
# I used sed for NA replace
# I did not see an option to use cardinality
# -cardinality
sed 's/NA//g' $df |\
  mlr --icsv --ocsv stats1 -a sum,min,max,mean,stddev,median,mode,count -f temp,humid | tv


#### [ ] q
# I have SQL experience so this was very easy to use
# I did not see a function for standard deviaion
# -stddev, stdev, sd
# -median
# -mode
# In general I could not find information on which summary functions
# were available
cat $df | q -HOd , "\
  select 
    sum(temp) as sum_temp \
    ,min(temp) as min_temp \
    ,max(temp) as max_temp \
    ,avg(temp) as mean_temp \
    ,count(distinct(temp)) as count_temp\
  from -"|\
  tv

### count
# Count the number of variables in each group

#### xsv
#-no grouped count function found

#### csvtk
csvtk summary -f humid:countn $df -i -g origin

#### tsv-utils
tsv-summarize --header --group-by origin --count data/weather.tsv

#### mlr (miller)
mlr --icsv --ocsv stats1 -a count -f origin -g origin $df

#### q
cat $df | q -HOd , "\
  select 
  count(origin) as count_origin\
  from -
  group by origin"


### [ ] grouped summary 
#### [ ] xsv
# I did not see a grouped stats function

#### [ ] csvtk
csvtk summary -f temp:sum,temp:min,temp:max,temp:mean,temp:stdev,temp:median,temp:countunique,humid:sum,humid:min,humid:max,humid:mean,humid:stdev,humid:median,humid:countunique\
  -g origin\
  --ignore-non-numbers $df |
  tv

#### [ ] tsv-utils
sed 's/NA//g' $df_tsv |\
  tsv-summarize --x --header --group-by origin --sum temp,humid --min temp,humid --max temp,humid --stdev temp,humid --median temp,humid --unique-count temp,humid | tsv-pretty

#### [ ] mlr (miller)
sed 's/NA//g' $df |\
  mlr --icsv --ocsv stats1 -a sum,min,max,mean,stddev,median,mode,count -f temp,humid -g origin |\
  tv

#### [ ] q
# missing median, mode, count
sed 's/NA//g' $df |\
q -HOd , "\
  select 
    sum(temp) as sum_temp \
    ,min(temp) as min_temp \
    ,max(temp) as max_temp \
    ,avg(temp) as mean_temp \
    ,count(distinct(temp)) as count_temp\
  from - group by origin" |\
  tv

## Extract Rows
### [ ] inclusive filter
#### [ ] xsv
xsv search --select origin LGA $df |\
  xsv search --select month 6 |\
  xsv search --select day 1 |\
  tv

#### [ ] csvtk
csvtk grep --fields origin --pattern LGA $df |\
  csvtk grep --fields month --pattern 6 $df |\
  csvtk grep --fields day --pattern 1 $df |\
  tv

#### [ ] tsv-utils
tsv-filter -H --str-eq origin:LGA --eq month:6 --eq day:1 $df |\
  tsv-pretty |\
  head

#### [ ] mlr (miller)
mlr --icsv --ocsv filter '$origin == "LGA" && $month == 6 && day == 1' $df |\
  tv

#### [ ] q
sed 's/NA//g' $df |\
q -HOd , "\
  select *
  from -
  where origin == 'LGA'
  and month == 6
  and day == 1" |\
    tv

### [ ] exclusive filter
#### [ ] xsv
xsv search --select origin -v LGA $df |\
  xsv search --select month -v 6 |\
  xsv search --select day -v 1 |\
  tv

#### [ ] csvtk
csvtk grep --fields origin,month,day -v --pattern LGA,6,1 $df |\
  tv

#### [ ] tsv-utils
tsv-filter -H --str-ne origin:LGA --ne month:6 --ne day:1 $df |\
  tsv-pretty |\
  head

#### [ ] mlr (miller)
mlr --icsv --ocsv filter '$origin != "LGA" && $month != 6 && day != 1' $df |\
  tv

#### [ ] q
sed 's/NA//g' $df |\
q -HOd , "\
  select *
  from -
  where origin != 'LGA'
  and month != 6
  and day != 1" |\
    tv

### [ ] slice - subset rows by position
#### [ ] xsv
xsv slice -s 5 -e 10 $df
#### [ ] csvtk
# I did not see a slice option
#### [ ] tsv-utils
# I did not see a slice option
#### [ ] mlr (miller)
# I did not see a slice option
#### [ ] q
# I did not see a slice option

### [ ] arrange
#### [ ] xsv
# -R goes after column, -N for numbers
xsv sort --select origin -R $df |\
  xsv sort --select month -NR |\
  xsv sort --select day -N |\
  tv

#### [ ] csvtk
# like how concise this syntax is
csvtk sort -k origin:Nr,month:nr,day:n $df |\
  tv

#### [ ] tsv-utils
# non
#### [ ] mlr (miller)
mlr --icsv --ocsv sort -r origin -nr month -n day $df |\
  tv

#### [ ] q
q -HOd , "\
  select origin, month, day
  from - order by origin desc, month desc, day asc" |\
    tv

## Extract columns (include/exclude)
### [ ] select 

#### [ ] xsv
xsv select origin,year,month,temp $df | tv
xsv select '!origin,year,month,temp' $df | tv

#### [ ] csvtk
csvtk cut -f origin,year,month,temp $df | tv
csvtk cut -f -origin,-year,-month,-temp $df | tv

#### [ ] tsv-utils
tsv-select -H -f origin,year,month,temp $df_tsv | tsv-pretty | head
tsv-select -H --exclude origin,year,month,temp $df_tsv | tsv-pretty | head

#### [ ] mlr (miller)
mlr --icsv --ocsv cut -f origin,year,month,temp $df | tv
mlr --icsv --ocsv cut -x -f origin,year,month,temp $df | tv

#### [ ] q
cat $df |\
q -HOd , "select origin, month, day from - " |\
    tv

### [ ] relocate/reorder
#### [ ] xsv
xsv select day,month,year $df | tv

#### [ ] csvtk
csvtk cut -f day,month,year $df | tv

#### [ ] tsv-utils
tsv-select -H -f day,month,year $df_tsv | tsv-pretty | head

#### [ ] mlr (miller)
mlr --icsv --ocsv cut -f day,month,year $df | tv

#### [ ] q
cat $df |\
q -HOd , "select day,month,year from - " |\
    tv

### [ ] mutate (new column as function of other column(s))
#### [ ] xsv
# none
#### [ ] csvtk
csvtk cut -f temp $df |\
csvtk mutate2 -e '$temp > 32 ? "liquid" : "solid"' --name 'water_phase' |\
tv

#### [ ] tsv-utils
# none
#### [ ] mlr (miller)
mlr --icsv --ocsv cut -f temp,humid $df |\
mlr --icsv --ocsv put '$a_feature = $temp/$humid'|\
tv

#### [ ] q
cat $df |\
q -HOd , "select 
            temp  
            ,humid
            ,temp/humid as a_feature from - " |\
    tv

### [ ] rename
#### [ ] xsv
# non
#### [ ] csvtk
csvtk cut -f temp,humid $df |\
csvtk rename -f temp,humid -n temperature,humidity |\
tv

#### [ ] tsv-utils
# non
#### [ ] mlr (miller)
mlr --icsv --ocsv cut -f temp,humid $df |\
  mlr --icsv --ocsv rename -r temp,temperature,humid,humidity |\
  tv

#### [ ] q
cat $df |\
q -HOd , "select 
            ,temp as temperature
            ,humid as humidity
            from - " |\
    tv

## Combine Tables
### [ ] bind cols
### [ ] left join
### [ ] right join
### [ ] inner join
### [ ] full join
### [ ] bind rows

#### set up for table operations
cat <<EOF >data/x.csv
a,b,c
a,t,1
b,u,2
c,v,3
EOF
cat data/x.csv | tv
cat <<EOF >data/y.csv
e,f,g
a,t,3
b,u,2
d,w,1
EOF
cat data/y.csv | tv


### [ ] bind cols
#### [ ] xsv
xsv cat columns data/x.csv data/y.csv | tv

#### [ ] csvtk
# none
#### [ ] tsv-utils
cat <<EOF >data/filter.csv
a
EOF
csv2tsv data/x.csv >> data/x.tsv
csv2tsv data/y.csv >> data/y.tsv
csv2tsv data/filter.csv >> data/filter.tsv

# none
#### [ ] mlr (miller)
# none
#### [ ] q
# none

### [ ] bind rows
#### [ ] xsv
xsv cat rows data/x.csv data/y.csv | tv

#### [ ] csvtk
# none
#### [ ] tsv-utils
# idk
# none
#### [ ] mlr (miller)
# none
#### [ ] q
# none

### [ ] left join
#### [ ] xsv
xsv join --left 1 data/x.csv 1 data/y.csv

#### [ ] csvtk
csvtk join -f 1 data/x.csv data/y.csv --left-join --na NA

#### [ ] tsv-utils
# idk
#### [ ] mlr (miller)
# none
#### [ ] q
q -HOd , "select * \
  from data/x.csv 
  left join data/y.csv
  on a=e"


### [ ] right join
#### [ ] xsv
xsv join --right 1 data/x.csv 1 data/y.csv

#### [ ] csvtk a left join is a right join if the tables are switched
csvtk join -f 1 data/y.csv data/x.csv --left-join --na NA

#### [ ] tsv-utils
# idk
#### [ ] mlr (miller)
# idk
#### [ ] q
q -HOd , "select * \
  from data/y.csv 
  left join data/x.csv
  on a=e"

### [ ] inner join
#### [ ] xsv
xsv join 1 data/x.csv 1 data/y.csv

#### [ ] csvtk
csvtk join -f 1 data/x.csv data/y.csv --na NA

#### [ ] tsv-utils
# idk
#### [ ] mlr (miller)
# idk
# none
#### [ ] q
q -HOd , "select * \
  from data/x.csv 
  inner join data/y.csv
  on a=e"

### [ ] full join
#### [ ] xsv
xsv join --full 1 data/x.csv 1 data/y.csv

#### [ ] csvtk
csvtk join -f 1 data/y.csv data/x.csv --outer-join --na NA | tv

#### [ ] tsv-utils
# idk
#### [ ] mlr (miller)
mlr --icsv --ocsv join -j a -r e --ul --ur -f data/x.csv then unsparsify data/y.csv

#### [ ] q
# none
