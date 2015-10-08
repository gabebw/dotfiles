PATH="./.cabal-sandbox/bin:$HOME/.cabal/bin:$PATH"
PATH="$HOME/Library/Haskell/bin:$PATH"

# Just type-check the file. Don't compile it.
alias hcompile="ghc -fno-code"

function cabal-new() {
  local name="$1"
  local file="./$1.cabal"
  cp ~/.basic-cabal-file "$file"
  sed -i '' "s/{NAME}/$1/g" "$file"
}
