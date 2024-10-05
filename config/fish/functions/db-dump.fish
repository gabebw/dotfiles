function db-dump -a db_name filename
  set -q $filename[1]; or set filename "db.dump"
  if [ (count $argv) -ge 1 ]
    pg_dump --clean --create --format=custom --file=$filename $db_name
    and printf "\n\n\nWrote to $filename\n"
  else
    echo "Usage: db-dump <DB_NAME | CONNECTION_STRING> [FILENAME = db.dump]"
    return 1
  end
end
