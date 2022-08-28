## Fuzzy text search in awk

After finding some files online I needed a way to rename them from their downloaded file name to their original filenames, which were in a text file.
Since there were quite a lot of files, I didn't want to do this by hand or copy/paste a lot, so I got reading up on fuzzy text searches and ended up reading the [Levenshtein Distance Wikipedia](https://en.wikipedia.org/wiki/Levenshtein_distance) page and some derivative algorithms (Optimal String Alignment and Damerau-Levenshtein)

These worked quite well and helped me automate the whole thing.

Here are the argorithms (direct conversion to awk from their Wikipedia examples) and two example programs to use them.

## Examples on how to use the code

Search for the string "Brown" in two sentences:<br>
```
$> awk -f fuzsearch.awk -f prog1.awk search="Brown" <<<$'How Now Brown Cow\nThe Quick Brown Fox Jumps OVer The Lazy Dog'
```

Search for the string "Monster Dee Dee" in the file `episodes.txt` using the Damerau-Levenshtein algorithm<br>
(`prog2.awk` is using a gawk-only feature to traverse an array in sorted order (`PROCINFO["sorted_in"]`), so this needs gawk to work properly.)<br>
```
$> gawk -f fuzsearch.awk -f prog2.awk -F'\t' search="Monster Dee Dee" episodes.txt
```
