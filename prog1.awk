{
  search = search ? search : ENVIRON["search"]
  perc1 = levDistance(search, $0)
  perc2 = OSAdistance(search, $0)
  perc3 = DamLevDistance(search, $0)

  printf("Lev: %5.1f%% / OSA: %5.1f%% / Dam-Lev: %5.1f%% \"%s\" -> \"%s\"\n", perc1, perc2, perc3, search, $0)
}
