#/bin/bash

if [[ ! "$TESTSPACE" = /* ]] ||
   [[ ! "$PATH_TO_REDMINE" = /* ]] ||
   [[ ! "$PATH_TO_TESTER" = /* ]] ||
   [[ ! "$NAME_OF_PLUGIN" = * ]] ||
   [[ ! "$PATH_TO_PLUGIN" = /* ]];
then
  echo "You should set"\
       " TESTSPACE, PATH_TO_REDMINE, PATH_TO_TESTER"\
       " NAME_OF_PLUGIN, PATH_TO_PLUGIN"\
       " environment variables"
  echo "You set:"\
       "$TESTSPACE"\
       "$PATH_TO_REDMINE"\
       "$PATH_TO_PLUGIN"
       "$NAME_OF_PLUGIN"
       "$PATH_TO_PLUGIN"
  exit 1;
fi

export RAILS_ENV=test

case $REDMINE_VER in
  1.4.*)  export PATH_TO_INSTALL=./vendor/plugins # for redmine < 2.0
          export GENERATE_SECRET=generate_session_store
          export MIGRATE_PLUGINS=db:migrate_plugins
          export REDMINE_GIT_REPO=git://github.com/edavis10/redmine.git
          export REDMINE_GIT_TAG=$REDMINE_VER
          ;;
  2.*)  export PATH_TO_INSTALL=./plugins # for redmine 2.0
          export GENERATE_SECRET=generate_secret_token
          export MIGRATE_PLUGINS=redmine:plugins:migrate
          export REDMINE_GIT_REPO=git://github.com/edavis10/redmine.git
          export REDMINE_GIT_TAG=$REDMINE_VER
          ;;
  master) export PATH_TO_INSTALL=./plugins # for redmine 2.0
          export GENERATE_SECRET=generate_secret_token
          export MIGRATE_PLUGINS=redmine:plugins:migrate
          export REDMINE_GIT_REPO=git://github.com/edavis10/redmine.git
          export REDMINE_GIT_TAG=$REDMINE_VER
          ;;
  v3.3.0) export PATH_TO_INSTALL=./vendor/plugins
          export GENERATE_SECRET=generate_session_store
          export MIGRATE_PLUGINS=db:migrate:plugins
          export REDMINE_GIT_REPO=http://github.com/chiliproject/chiliproject.git
          export REDMINE_GIT_TAG=$REDMINE_VER
          ;;
  *)      echo "Unsupported platform $REDMINE_VER"
          exit 1
          ;;
esac

export BUNDLE_GEMFILE=$PATH_TO_REDMINE/Gemfile

clone_redmine()
{
  set -e # exit if clone fails
  git clone -b master --depth=100 --quiet $REDMINE_GIT_REPO $PATH_TO_REDMINE
  cd $PATH_TO_REDMINE
  git fetch origin refs/tags/$REDMINE_GIT_TAG
  git checkout $REDMINE_GIT_TAG
}

run_tests()
{
  # exit if tests fail
  set -e

  cd $PATH_TO_REDMINE

  bash $PATH_TO_TESTER

}

uninstall()
{
  set -e # exit if migrate fails
  cd $PATH_TO_REDMINE
  # clean up database
  bundle exec rake $MIGRATE_PLUGINS NAME=$NAME_OF_PLUGIN VERSION=0
}

run_install()
{
# exit if install fails
set -e

# cd to redmine folder
cd $PATH_TO_REDMINE
echo current directory is `pwd`

# create a link to the backlogs plugin
ln -sf $PATH_TO_PLUGIN $PATH_TO_INSTALL/$NAME_OF_PLUGIN

# copy database.yml
cp $TESTSPACE/database.yml config/

# copy Gemfile (need if bundler >= 1.3.0?)
cp $PATH_TO_INSTALL/$NAME_OF_PLUGIN/Gemfile.local $PATH_TO_REDMINE/

# install gems
mkdir -p vendor/bundle
bundle install --path vendor/bundle

git clone git://github.com/pullmonkey/open_flash_chart.git $PATH_TO_INSTALL/open_flash_chart
mkdir -p public/plugin_assets/open_flash_chart
cp -r $PATH_TO_INSTALL/open_flash_chart/assets/* public/plugin_assets/open_flash_chart/

# run redmine database migrations
bundle exec rake db:migrate

# install redmine database
bundle exec rake redmine:load_default_data REDMINE_LANG=en

# generate session store/secret token
bundle exec rake $GENERATE_SECRET

# run backlogs database migrations
bundle exec rake $MIGRATE_PLUGINS
}

while getopts :ictu opt
do case "$opt" in
  c)  clone_redmine; exit 0;;
  i)  run_install;  exit 0;;
  t)  run_tests;  exit 0;;
  u)  uninstall;  exit 0;;
  [?]) echo "i: install; c: clone redmine; t: run tests; u: uninstall";;
  esac
done
