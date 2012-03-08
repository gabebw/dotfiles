email='gab'
email=$email'ebw'
email=$email'@'
email=$email'gmail.com'
alias add-me-as-a-merchant="./script/runner 'User.find_by_email(%<$email>).tap{|x| x.merchant_id = 133; x.save! }'"
alias dump-levelup-database="pg_restore --verbose --clean --no-acl --no-owner -d levelup_development ~/Downloads/b313.dump"
alias aggregate-levelup='bake levelup:{merchant:touch_demographics,loyalty:aggregate,order:aggregate}'
# Ensure db:drop:all succceeds first, because something else may be accessing it
alias dump-levelup='bake db:drop:all && bake db:create:all && dump-levelup-database ; migrate && add-me-as-a-merchant'
