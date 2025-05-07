function db-restore -a db_name filename
  if [ (count $argv) -eq 2 ]
    dropdb --if-exists $db_name && \
    createdb $db_name && \
      pg_restore \
        --verbose \
        --clean \
        --no-acl \
        --no-owner \
        --jobs $(getconf _NPROCESSORS_ONLN) \
        --dbname $db_name \
        $filename
  else
    echo "Usage: db-restore DB_NAME FILENAME"
    return 1
  end
end
