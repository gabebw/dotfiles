# https://github.com/mjoldfield/Arduino-Makefile

function arduino-new() {
  local ARDMK_DIR="$HOME/.dotfiles/arduino/Arduino-Makefile"
  local arduino_makefile_path="$ARDMK_DIR/arduino-mk/Arduino.mk"

  if [[ -n $1 ]]
  then
    mkdir $1
    pushd $1

    cat > Makefile <<EOL
      BOARD_TAG     = uno
      ARDUINO_PORT  = /dev/tty.usbmodem*
      ARDUINO_DIR   = /Applications/Arduino.app/Contents/Resources/Java
      ARDMK_DIR     = $ARDMK_DIR

      include $arduino_makefile_path
EOL

    sed -i '' 's/^ +//' Makefile

    touch "$1.ino"
    popd
  else
    echo "Need a project name!"
  fi
}
