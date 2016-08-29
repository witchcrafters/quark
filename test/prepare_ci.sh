#!/bin/bash
# ensure exit codes other than 0 fail the build
set -e

# asdf
# -- install if not installed before
# -- add plugins if not added before
function asdfPlugin {
  asdf plugin-add $1 https://github.com/HashNuke/asdf-$1.git
}

# Set up Figaro environment variables
# This line can be removed if our PR to FigaroElixir is accepted:
# https://github.com/KamilLelonek/figaro-elixir/pull/1
touch $HOME/$CIRCLE_PROJECT_REPONAME/config/application.yml

if ! asdf | grep version; then git clone https://github.com/HashNuke/asdf.git ~/.asdf; fi
if ! asdf plugin-list | grep erlang; then $(asdfPlugin "erlang"); fi
if ! asdf plugin-list | grep elixir; then $(asdfPlugin "elixir"); fi

# extract vars from elixir_buildpack.config
. elixir_buildpack.config

# write .tool-versions
if [ ! -f .tool-versions ]; then
  echo "erlang $erlang_version" >> .tool-versions
  echo "elixir $elixir_version" >> .tool-versions
fi

# install erlang/elixir
asdf install erlang $erlang_version
asdf install elixir $elixir_version

# get dependencies
if [ ! -e $HOME/.mix/rebar ]; then
  yes | mix local.rebar
fi

yes | mix deps.get

# exit successfully
exit 0
