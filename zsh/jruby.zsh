# Max memory = 2048m
JRUBY_OPTS=-J-Xmx2048m

# Avoid OutOfMemoryError
JRUBY_OPTS="$JRUBY_OPTS -J-XX:+CMSClassUnloadingEnabled"

# Disable JIT for faster startup
JRUBY_OPTS="$JRUBY_OPTS -X-C"

export JRUBY_OPTS
