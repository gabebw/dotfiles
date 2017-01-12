arduino-new(){
  if [[ -d "$1" ]]; then
    echo "Already exists"
    return 1
  fi

  if [[ "$1" == *.* ]]; then
    echo "No dots allowed in the name"
    return 1
  fi

  mkdir "$1"
  cat >> "$1/$1.ino" <<EOF
void setup(){

}

void loop(){

}
EOF

  vim "$1/$1.ino"
}
