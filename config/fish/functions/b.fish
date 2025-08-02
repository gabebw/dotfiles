function b --wraps bundle
  if [ (count $argv) -eq 0 ]
    if bundle check > /dev/null || bundle install --jobs=4
      bundle config set bin './bin/stubs'
      bundle binstubs --all
    end
  else
    bundle $argv
  end
end
