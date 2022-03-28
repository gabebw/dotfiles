function new-project
  if [ (count $argv) -eq 0 ]
    read -P "Project name? " project_name
  else
    set -f project_name $argv[1]
  end
  set -f project_name (string replace --all ' ' '-' $project_name)
  pushd personal
  if [ -d "$project_name" ]
    echo "!! Project directory with that name already exists" >&2
    return 1
  end
  if [ -f "$project_name" ]
    echo "!! Project *file* with that name already exists" >&2
    return 1
  end
  mkdir $project_name && tcd "./$project_name"
  popd
end
