function b --wraps bundle
  if [ (count $argv) -eq 0 ]
    if bundle check > /dev/null || bundle install --jobs=4
      bundle binstubs --all --path=./bin/stubs
    end
  else
    bundle $argv
  end
end
