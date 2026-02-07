function db-dump -a db_name_or_connection_string filename
  if string match -req 'postgresql://.*pooler.*neon.tech'
    # Don't `pg_dump` from a pooled connection:
    # https://github.com/pgbouncer/pgbouncer/issues/452
    # https://github.com/pgbouncer/pgbouncer/issues/976
    echo "Do not use pooled connection strings with this. Copy the unpooled version instead" >&2
    return 1
  end

  if [ -z "$filename" ]
    set filename "db.dump"
  end
  if [ (count $argv) -ge 1 ]
    pg_dump --clean --create --format=custom --file=$filename $db_name_or_connection_string
    and printf "\n\n\nWrote to $filename\n"
  else
    echo "Usage: db-dump <DB_NAME | CONNECTION_STRING> [FILENAME = db.dump]"
    return 1
  end
end
