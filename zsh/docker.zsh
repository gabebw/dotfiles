$(boot2docker shellinit 2> /dev/null)

function book_build(){
  docker run --volume "$PWD:/book" thoughtbot/paperback build
}
