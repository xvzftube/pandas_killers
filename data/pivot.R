library(tidyverse)

df_features <- readr::read_csv("tool_features.csv")

df_features %>%
  pivot_wider(id_cols=`tool`,names_from=`function`,values_from=available) %>%
  write_csv("tool_features_wide.csv")

df_summary <- readr::read_csv("summary_options.csv")

df_summary %>%
  pivot_wider(id_cols=`tool`,names_from=`function`,values_from=available) %>%
  write_csv("summary_options_wide.csv")

