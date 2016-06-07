#!/bin/bash

# Dir of runner.sh
MAIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Install developed gem if does not installed yet
if [ $(gem list funny_db -i) != true ]; then
  cd /developed_lib/pkg
  gem install funny_db

  cd $MAIN_DIR
fi

# Let's run example!
ruby main.rb
