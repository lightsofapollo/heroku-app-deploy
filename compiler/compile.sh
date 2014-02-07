#! /bin/bash -evx

usage() {
  echo
  echo "  Usage: compile [subdirectory] [output.tgz]"
  echo
  echo '  Exports the git subtree and creates a nodejs buildpack and places'
  echo '  it in $subdirectory/$output'
  echo
}

if [ "$1" == "--help" ];
then
  usage
  exit
fi

# The subtree which the app lives in
subtree=$1

# The filename to output the archive in
output_archive=$2

if [ "$subtree" == "" ];
then
  subtree=./
fi

if [ "$output_archive" == "" ];
then
  output_archive=slug.tgz
fi

# directory to export from the `app_source` git tree
source_dir=app_source/$subtree

if [ ! -d "$source_dir" ];
then
  echo "  $subtree is not a directory in the source tree"
  usage
  exit 1
fi

echo "-----> build subtree $subtree"
echo "-----> export location $subtree/$output_archive"

# create the app directory (this has special meaning and _must_ be `app`)
mkdir -p app/

# `app_source` is the current state of the git tree
cd app_source
git archive --format tar.gz -1 HEAD $subtree > ../app.tar.gz
cd ..

# expand the git archive (to simulate the git push / git checkout workflow)
tar xzf app.tar.gz -C app/ --strip-components=1

cd buildpack
./bin/compile $PWD/../app/
cd ..
# ./app is critical here if its changed heroku will not work
tar czf ./$source_dir/$output_archive ./app
