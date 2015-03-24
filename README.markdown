Redmine Charts
==============

Plugin which integrates with Redmine following charts: burndown, burndown with progress, timeline, ratios of logged hours and issues, deviations of logged hours.

[![Build Status](https://travis-ci.org/drakontia/redmine_charts.png)](https://travis-ci.org/drakontia/redmine_charts)

## Instalation

*If you use bundler, please add prefix `bundle exec` when you execute ruby commands.*

Download the sources and put them to your Plugins folder.

    $ cd {REDMINE_ROOT}

    #for Redmine 2.x
    $ git clone git://github.com/drakontia/redmine_charts.git plugins/redmine_charts

    #for Redmine 1.4.x
    $ git clone git://github.com/drakontia/redmine_charts.git vendor/plugins/redmine_charts

Install OpenFlashChart plugin.

    #for Redmine 2.x
    $ rails g plugin git://github.com/pullmonkey/open_flash_chart.git
    mkdir -p public/plugin\_assets/open\_flash\_chart
    cp -r plugins/open\_flash\_chart/assets/* public/plugin\_assets/open_flash_chart/

    #for Redmine 1.4.x
    $ ./script/plugin install git://github.com/pullmonkey/open_flash_chart.git
    mkdir -p public/plugin\_assets/open\_flash\_chart
    cp -r vendor/plugins/open\_flash\_chart/assets/* public/plugin\_assets/open_flash_chart/

Migrate database.

    #for Redmine 2.x
    $ rake redmine:plugins:migrate RAILS_ENV=production

    #for Redmine 1.4.x
    $ rake db:migrate:plugins RAILS_ENV=production

Populate tables with old data.

    $ rake charts:migrate RAILS_ENV=production

Run Redmine and have a fun!

## Troubleshouting

### I don't see any data in charts / I don't see my old data in charts

Run migration task "charts:migrate" to populate tables used by plugin with Your old data.

### I don't see charts tab / I don't see link to add new saved condition

Add permission to Your user.

## Contributor

### Developments

- [alminium](https://github.com/alminium)
- [basyura](https://github.com/basyura)
- [cforce](https://github.com/cforce)

### Translations

- ja by In Dow
- pt-br by Enderson Maia
- nl by onno-schuit
- en by Maciej Szczytowski and Rocco Stanzione
- ru by Vadim Kruchkov
- es by Rafael Lorenzo, José Javier Sianes Ruiz
- pl by Maciej Szczytowski
- fr by Yannick Quenec'hdu
- ko by Ki Won Kim
- da by Jakob Skjerning
- de by Bernd Engelsing
- sv by Martin Bagge

Thanks for the contribution.

## Changelog

### 0.2.1
- copatible with Redmine 2.1.x (alminium)

### 0.2.0
- compatible with Redmine 2.0.x
- compatible with Ruby 1.8.x (basyura)
- change tests from Test::Unit to Rspec.
- models tests is all green.
- lib tests is all green.
- update Readme for Redmine 2.0.x

### 0.1.5
- compatible with Ruby 1.8.7 (for RM1.4.x branch)

### 0.1.4
- compatible with Redmine 1.4.x and Ruby 1.9.x (not support Ruby 1.8.7 )
- fix about bugs on charts\_deviations.

### 0.1.3
- Corresponding to sub-projects.

### 0.1.2
- Fix of error & notice message is also displayed on the next screen.

### 0.1.1
- compatible with Redmine 1.1.2
- Only list active projects, fix from Anton Kravchenko's fork.
- weeks starts from 0 - yondo
- support version has no tickets case Anton Kravchenko (author)
- avoid error  kzgs (author)
- use Version#start\_date for start date of burndown chart  kzgs (author)
- fixing bug where the index is not found in range[:keys] from: Michael Co...

### 0.1.0

- migration to Redmine 0.9.x
- new conditions (owners, authors, statuses and projects)
- conditions in burndown chart
- multiselection in conditions (#3)
- new issue chart (#2)
- issues with closed status are considered as 100% complete (#1)
- new translations (ko, da, de)
- new chart - burndown with velocity (#12)
- support for subissues (#36)
- saved condition (#24)

### 0.0.14

- new translations (fr)

### 0.0.13

- bug fixes (#13, #15)
- saving charts as images (#14)

### 0.0.12

- many bug fixes (#6, #7, #8, #9, #10)
- new conditions (trackers, priorities, versions)
- pages on deviations chart (#5)
- hours logged for project and not estimated issues on deviations chart
