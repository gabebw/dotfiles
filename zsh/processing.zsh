# Create a new (Java) processing sketch
processing-new(){
  if [[ -d "$1" ]]; then
    echo "Already exists"
    return 1
  fi

  if [[ "$1" == *.* ]]; then
    echo "No dots allowed in the name"
    return 1
  fi

  mkdir "$1"
  cat >> "$1/$1.pde" <<EOF
void setup() {
  size(640,360);
}

void draw() {
  background(255);
}
EOF
  vim "$1/$1.pde"
}
