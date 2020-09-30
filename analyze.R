#!/usr/bin/env Rscript

library(tidyverse)
library(vegan)
library(cowplot)

# Load beta diversity data

beta_tibble <- read_tsv("beta.tsv") %>%
  # check that all sample names are in the columns and rows
  { stopifnot(all(names(.) == c("X1", .$X1))); . } %>%
  # sort the rows
  arrange(X1) %>%
  # sort the columns
  select_at(c("X1", .$X1))

# Load metadata
metadata <- read_tsv("metadata.tsv") %>%
  filter(direction == 1) %>%
  select(sample_id, donor, donation, run)

# Cast beta diversity matrix as a "long" table
beta_long <- beta_tibble %>%
  rename(sample_id1 = X1) %>%
  pivot_longer(-sample_id1, names_to = "sample_id2") %>%
  # merge in the metadata
  left_join(rename_all(metadata, ~ str_c(., "1")), by = "sample_id1") %>%
  left_join(rename_all(metadata, ~ str_c(., "2")), by = "sample_id2")


# Beta diversity (JSD) analysis ---------------------------------------

# Group pairs of samples by whether they are same-donor/different-run,
# same-run/different-donor, or same-donor/same-run
beta_compare <- beta_long %>%
  # only keep 1 comparison per pair; exclude self-self
  filter(sample_id1 < sample_id2) %>%
  mutate(
    group = case_when(
      donor1 == donor1 & run1 != run2 ~ "same_donor",
      run1 == run2 & donor1 != donor2 ~ "same_run",
      donor1 == donor2 & run1 == run2 ~ "same_both"
    )
  )

if (any(is.na(beta_compare$group))) stop("Incomplete group scheme")

telegraph <- function(x, width = 72) {
  if (str_length(x) > width) stop("Message too long")
  cat(str_c("\n", x, " ", str_dup("-", width - str_length(x) - 1), "\n\n"))
}

sink("results/jsd.txt")

telegraph("Median JSD by group")
beta_compare %>%
  group_by(group) %>%
  summarize_at("value", median)

telegraph("Omnibus test: do JSDs differ by group?")
kruskal.test(value ~ group, data = beta_compare)

telegraph("Compare same-donor and same-run")
beta_compare %>%
  filter(group %in% c("same_donor", "same_run")) %>%
  with({ wilcox.test(value ~ group) })

sink()

# Plot the 3 groups
labels <- c(
  same_both = "Same donor & run",
  same_donor = "Same donor",
  same_run = "Same run"
)

plot <- beta_compare %>%
  mutate_at("group", ~ factor(., levels = names(labels), labels = labels)) %>%
  ggplot(aes(group, value)) +
  geom_boxplot() +
  geom_blank(data = tibble(group = "Same donor & run", value = 0)) +
  theme_cowplot() +
  labs(
    title = "Beta diversity among samples, by donor and run",
    x = "",
    y = "Jensen-Shannon divergence"
  )

ggsave("results/jsd.pdf", plot = plot)


# PCOA plot -----------------------------------------------------------

pcoa <- read_tsv("pcoa.tsv", col_names = c("sample_id", "coord1", "coord2"), skip = 1)

plot <- pcoa %>%
  left_join(metadata, by = "sample_id") %>%
  # group_by(donor) %>%
  # summarize_at(c("coord1", "coord2"), mean) %>%
  ggplot(aes(coord1, coord2, color = factor(run))) +
  geom_point() +
  theme_cowplot()

ggsave("results/pcoa.pdf", plot = plot)


# PERMANOVA and R^2 ---------------------------------------------------

beta <- beta_tibble %>%
  select(-X1) %>%
  as.matrix() %>%
  as.dist()

metadata <- read_tsv("metadata.tsv") %>%
  filter(sample_id %in% beta_tibble$X1, direction == 1) %>%
  arrange(sample_id)

permanova <- adonis2(beta ~ donor + run, data = metadata, by = "margin")

sink("results/permanova.txt")
permanova
sink()
