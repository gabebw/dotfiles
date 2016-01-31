PATH="./.cabal-sandbox/bin:$HOME/.cabal/bin:$PATH"

# Add GHC 7.10.2 to the PATH, via https://ghcformacosx.github.io/
GHC_DOT_APP="/Applications/ghc-7.10.2.app"
if [ -d "$GHC_DOT_APP" ]; then
  PATH="$HOME/.local/bin:$GHC_DOT_APP/Contents/bin:$PATH"
fi

# Just type-check the file. Don't compile it.
alias hcompile="ghc -fno-code"

command -v stack > /dev/null && eval "$(stack --bash-completion-script stack)"

new-yesod-project() {
  name=$1
  stack new "$1" yesod-postgres
  cd "$1"
  stack install yesod-bin cabal-install --install-ghc
  stack build
  echo "Run the server: stack exec -- yesod devel"
}
