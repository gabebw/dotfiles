function b --wraps bundle
  if [ (count $argv) -eq 0 ]
    if bundle check > /dev/null || bundle install --jobs=4
      bundle config set bin './bin/stubs'
      bundle binstubs --all 2>&1 | rg -v 'Bundler itself does not use binstubs because its version is selected by RubyGems'
    end
  else
    bundle $argv
  end
end
