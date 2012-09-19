#!/bin/zsh

# USAGE: deploy_to.rb ENVIRONMENT_NAME
# Deploy to a specific environment, assuming the following:
# 1) A branch exists with the same name
# 2) A remote exists with the same name
# 3) You only deploy the branch to the remote (and don't deploy master)

# Sample output with no changes:
# $ deploy-to.sh development
# Already on 'development'
# HEAD is now at 00d54ad Users can view created/edited recipes.
#
# ---> Viewing list of new commits
# No new commits
# Continue? (Y/n) > y
#
# ---> Viewing changed files
# No changes
# Continue? (Y/n) > y
#
# ---> Merging master into development.
# Already up-to-date.
#
# ---> Pushing development -> origin.
# Everything up-to-date
#
# ---> Deploying.
# Everything up-to-date

function ask_to_continue() {
  echo -n "Continue? (Y/n) > "
  read response
  if [[ $response != y ]]
  then
    echo "Quitting!"
    exit 1
  fi
}

function message() {
  echo
  echo "---> $@"
}

function output_or() {
  local command="$1"
  local null_output="$2"
  if [[ -n `eval $command` ]]
  then
    eval $command
  else
    echo $null_output
    exit 1
  fi
}

if [[ $# == 0 ]]; then
  echo "USAGE: deploy-to.sh ENV"
  exit 1
fi

environment=$1

git checkout $environment
git reset --hard origin/$environment

message "Viewing list of new commits"
output_or "git log --format='%p (%an) %s' $environment..master" "No new commits"
ask_to_continue

message "Viewing changed files"

output_or "git diff --stat $environment master" "No changes"
ask_to_continue

message "Merging master into $environment."
git merge master

message "Pushing $environment -> origin."
git push origin $environment

# Deploy
message "Deploying."
git push -f $environment $environment:master

if [[ $? != 0 ]]
then
  echo "Pushing to heroku failed. :("
  exit 1
fi

# Introspect to make sure everything is OK
watch heroku ps --remote $environment
