function curl-debug
  # --disable must be the first argument
  # Do *not* add a space in `Accept-Encoding:gzip` because then it prints the
  # entire body to the terminal instead of just `[866 bytes data]`.
  command curl \
    --disable \
    --verbose \
    --silent \
    --show-error \
    --output /dev/null \
    -H Fastly-debug:1 \
    -H Accept-Encoding:gzip \
    $argv \
    2>&1
end
