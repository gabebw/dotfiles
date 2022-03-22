function gbm -a branch
  git master-to-main-wrapper checkout -b $branch "origin/%BRANCH%"
end
