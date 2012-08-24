#!/bin/zsh

# USAGE: deploy_to.rb ENVIRONMENT_NAME
# Deploy to a specific environment, assuming the following:
# 1) A branch exists with the same name
# 2) A remote exists with the same name
# 3) You only deploy the branch to the remote (and don't deploy master)

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
  local output=$1
  local null_output=$2
  if [[ -n $output ]]
  then
    echo $output
  else
    echo $null_output
  fi
}

environment=$1

git checkout $environment
git reset --hard origin/$environment

message "Viewing list of new commits"
output_or `git log $environment..master` "No new commits"
ask_to_continue

message "Viewing changed files"

output_or `git diff --stat $environment master` "No changes"
ask_to_continue

message "Merging master into $environment."
git merge master

message "Pushing $environment -> origin."
git push origin $environment

# Deploy
message "Deploying."
git push $environment $environment:master

# Introspect to make sure everything is OK
watch heroku ps --remote $environment
