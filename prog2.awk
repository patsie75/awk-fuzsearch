{
  # search variable either "-v search=term" or via environment variable
  search = search ? search : ENVIRON["search"]

  # this data has double-quotes around column 3, let's remove them
  gsub(/^"|"$/, "", $3)

  # calculate the Damerau-Levenshtein distance
  perc = DamLevDistance(search, $3)

  # store the result in a list/array
  list[perc]["episode"] = $1
  list[perc]["seasoneps"] = $2
  list[perc]["name"] = $3
  list[perc]["airdate"] = $(NF-1)
}

END {
  # show top 5 entries
  top = 5

  # gawk specific feature to traverse array in sorted order
  PROCINFO["sorted_in"] = "@ind_num_desc"
  for (perc in list) {
    if (++cnt > top) break
    printf("%5.1f%% Episode %s: %20s airdate: %s\n", perc, list[perc]["episode"], "\""list[perc]["name"]"\"", list[perc]["airdate"])
  }
}
