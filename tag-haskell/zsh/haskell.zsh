PATH="./.cabal-sandbox/bin:$HOME/.cabal/bin:$PATH"
PATH="$HOME/Library/Haskell/bin:$PATH"

# Just type-check the file. Don't compile it.
alias hcompile="ghc -fno-code"

function cabal-init(){
  cabal init \
    --non-interactive \
    --package-name "$1" \
    --license MIT \
    --synopsis "This is a synopsis" \
    --is-executable \
    --author="Gabe Berke-Williams"
}

# Start a new haskell project named $1
function haskell-new(){
  projectname=$1
  cabalfile="${projectname}.cabal"
  print "Cool, creating a project named ${fg_bold[yellow]}${projectname}${reset_color}"

  mkdir "$projectname" &&
    cd "$projectname" &&
    cabal sandbox init &&
    echo ".cabal-sandbox/" >> .gitignore &&
    echo "cabal.sandbox.config" >> .gitignore &&
    echo "dist/" >> .gitignore &&
    cabal-init "$projectname" &&
    echo 'main = putStrLn "It works!"' > Main.hs &&
    sed -i '' 's/ +$//g' *cabal &&
    git init &&
    cabal run >/dev/null &&
    print "${fg_bold[green]}Edit Main.hs, run it with \`cabal run\`${reset_color}"
}
