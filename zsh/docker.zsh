# Super slow, so don't run it every time
function docker_init {
  $(boot2docker shellinit 2> /dev/null)
}
