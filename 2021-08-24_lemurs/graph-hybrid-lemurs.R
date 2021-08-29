library(tidyverse)
library(rkroki)


load("2021-08-24_lemurs/lemurs-data.Rdata")

parents_child <- lemurs %>%
  select(
    dlc_id,
    taxon,
    name,
    sex,
    dam_id,
    dam_name,
    dam_taxon,
    sire_id,
    sire_name,
    sire_taxon
  ) %>%
  distinct() %>%
  mutate(
    diff_dam = (taxon != dam_taxon),
    diff_sire = (taxon != sire_taxon)
  ) %>%
  group_by(
    taxon,
    dam_taxon,
    sire_taxon
  ) %>%
  count() %>%
  mutate(
    diff_dam = (taxon != dam_taxon),
    diff_sire = (taxon != sire_taxon)
  )

hybrids <- parents_child %>%
  filter(diff_dam | diff_sire) %>%
  select(-diff_dam, -diff_sire) %>%
  left_join(
    taxons %>% select(taxon, child_taxon_name = common_name),
    by = "taxon"
  ) %>%
  left_join(
    taxons %>% select(dam_taxon =  taxon, dam_taxon_name = common_name),
    by = "dam_taxon"
  ) %>%
  left_join(
    taxons %>% select(sire_taxon = taxon, sire_taxon_name = common_name),
    by = "sire_taxon"
  ) %>%
  mutate(
    child_taxon_name = str_to_sentence(child_taxon_name),
    dam_taxon_name = str_to_sentence(dam_taxon_name),
    sire_taxon = replace_na(sire_taxon, "Unknown"),
    sire_taxon_name = replace_na(sire_taxon_name, "Unknown") %>%
      str_to_sentence(),
    rel_str = paste0(
      '"', dam_taxon_name, ' (', dam_taxon, '♀) + ',
      sire_taxon_name, ' (', sire_taxon, '♂)" -> "',
      child_taxon_name,  '\\n(', taxon, ')" [label = "N: ',
      n,'"];'
    )
  )

hybrids_diagram <- paste0(
  'digraph G {\nrankdir = "LR";\nnode[shape="box"];\n',
  'graph[
    labelloc = t;
    shape="plain",
    label=<
      <table border="0">
      <tr><td align="center"><b><font color="#a13d2d" point-size="42">Hybrid Lemurs</font></b></td></tr>
      <tr><td align="center"><font color="darkgrey" point-size="30">#TidyTuesday 2021-08-24</font></td></tr>
      <tr><td align="right"><font color="black" point-size="24">@jmcastagnetto, Jesus M. Castagnetto</font></td></tr> </table>
      >
  ]\n',
  paste0(hybrids$rel_str, collapse = "\n"),
  "\n}"
)

write(
  hybrids_diagram,
  file = "2021-08-24_lemurs/hybrid-lemurs.dot"
)

res <- kroki_call(hybrids_diagram, "graphviz", format = "png")
kroki_write_ouput(res, "2021-08-24_lemurs/hybrid-lemurs.png", overwrite = TRUE)
¸