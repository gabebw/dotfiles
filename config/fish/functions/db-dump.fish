function db-dump -a db_name filename
  if [ (count $argv) -eq 2 ]
    pg_dump --clean --create --format=custom --file=$filename $db_name && \
      echo "Wrote to $filename"
  else
    echo "Usage: db-dump <DB_NAME | CONNECTION_STRING> FILENAME"
    return 1
  end
end
