export JRUBY_OPTS="--1.9 \
 -J-Dfile.encoding=UTF-8 \
 -J-Djruby.jit.threshold=10 \
 -J-Djruby.compile.mode=jit \
 -J-Xms1536m \
 -J-Xmx1536m \
 -J-XX:MaxPermSize=512m \
 -J-server"
