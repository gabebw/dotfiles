# This is a function so the `eval` runs in the context of the current shell.
# If it's in script, that script's subshell gets the Docker env then immediately
# exits, which doesn't help me very much.
#
# https://docs.docker.com/machine/get-started/
function docker-kickstart(){
  if ! command -v docker-compose > /dev/null; then
    brew install docker-compose
  fi

  if ! command -v docker-machine > /dev/null; then
    brew install docker-machine
  fi

  if ! docker-machine ls | grep -Fq default; then
    # Create a machine with 50GB of storage
    docker-machine create --driver virtualbox --virtualbox-disk-size=50000 --virtualbox-memory 8096 default
  fi

  if [[ "$(docker-machine status default)" != "Running" ]]; then
      docker-machine start default
  fi

  eval "$(docker-machine env default)"
}
