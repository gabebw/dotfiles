function it
  icopy -t tumblr/(string replace --all ' ' '-' (string join ' ' $argv))
end
