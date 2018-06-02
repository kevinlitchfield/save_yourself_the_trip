# Save Yourself the Trip

Prevent redundant ActiveRecord queries to find primary keys when you already have the foreign key: raise or warn when looking up an association to find its primary key, if that primary key is present on the original object as a foreign key.

**Save Yourself the Trip** will make (according to your preference) soft or loud noise if you mistakenly write (for example) `apartment.building.id`, and recommend using `apartment.building_id` instead.

Inspired by the far more useful [Bullet](https://github.com/flyerhzm/bullet), which does the same thing for N+1 queries.


## Installation

Install the gem in your project, then run `SaveYourselfTheTrip.on!` after ActiveRecord classes are loaded.


## Why?

Spelunking in legacy code, you tend to see a lot of inefficient ActiveRecord statements. Wanted something to catch them so they could quickly be refactored and save a few milliseconds.
