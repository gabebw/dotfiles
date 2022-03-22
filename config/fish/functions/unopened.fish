function unopened
  if [ (count $argv) -eq 0 ]
    search_spotlight_files \
      "(kMDItemLastUsedDate != '*') && (kMDItemContentType != 'public.folder')"
  else
    search_spotlight_files \
      "(kMDItemLastUsedDate != '*') && (kMDItemContentType != 'public.folder')" |
      head -n $argv[1]
  end
end
