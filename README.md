# Beastmaster (bst) - beta [![Travis build status]](https://travis-ci.org/arpinum/beastmaster) [![Drone build status]](https://drone.io/github.com/arpinum/beastmaster/latest)

> A beast does not know that he is a beast, and the nearer a man gets to being a beast, the less he knows it.
> <cite>(George MacDonald)</cite>

**Beastmaster** is a Bash tool which can run any command in your favorite projects (aka projects).

Example:

    bst order my_project git status

## Installation

Copy [bst latest release] in your `/usr/local/bin` or use the automated script below:

    \curl -sSL http://git.io/A3R2 | bash -s

## Taming projects

First you have to tame your project to keep them close. Use `tame` command.

Go in your project and type `bst tame`:

    > cd ~/code/my_project
    > bst tame
    my_project is now tamed!

You can choose a name if the default name does not suit you (the path basename):

    > bst tame cool_project

If the directory is a root directory containing projects, you can tame them all with `--root`:

    > ls
    cool_project crasy_stuff
    > bst tame --root
    cool_project is now tamed!
    crasy_stuff is now tamed!

The taming directory is the current one but you can override this with `--directory`:

    > bst tame --directory ~/code/my_project

Since they all look the same you can tag your projects to recognize them. Use `--tags name1,name2` option when taming:

    > bst tame --tags cat_related,java

For simplicity sake, tags won't work with comma or eol (oh really?) in it.

## Yell orders to do the dirty work

After having tamed your little army, it's time to order some commands to test your charisma. Use `order` command.

Each command are run in the project directory.

If you want to refresh a single project:

    > bst order my_project git pull origin master

To check the status of all projects tagged as github:

    > bst order --tags github git status

To run the tests of all projects named like "js_project*"

    > bst order "js_project*" npm test

Do not forget the "..." to prevent some tricky string interpolation.

`bst order` options should be placed before name (if any) and command to not mess with command own options.

## List your projects to review the army

If you don't remember all the minions you have, just use the `list` command to display all the projects.

    > bst list
    cool-project at /home/alone/dev/cool-project #java #git #hobby
    bowling-kata at /home/alone/dev/kata/bowling-kata #python #training

## Free a project when you are done with it

Sometimes the cutest project may turn out to be perfectly useless. The `free` command can handle this situation.

    > bst free my_project
    my_project is running away...

## Tune the configuration like a pro

If you want to clean the mess, open the configuration file:

    > nano ~/.bst/config

Pro tip: if the `EDITOR` global variable is set, you can also use the `config` shortcut:

    > bst config

The config file use this simple convention:

    name:path:tag1:tag2
    
Example:

    cool-project:/home/alone/dev/cool-project:java:git:hobby
    bowling-kata:/home/alone/dev/kata/bowling-kata:python:training

## Thanks

I would like to thank those awesome and inspiring projects below. I have learn a lot using them.

* [Commander] / [Commander.js]
* [Jump]

## License

Copyright (C) 2015, Arpinum

**Beastmaster** is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

**Beastmaster** is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with **Beastmaster**.  If not, see [http://www.gnu.org/licenses/lgpl.html].

[http://www.gnu.org/licenses/lgpl.html]: http://www.gnu.org/licenses/lgpl.html    
[Travis build status]: https://travis-ci.org/arpinum/beastmaster.png?branch=master
[Drone build status]: https://drone.io/github.com/arpinum/beastmaster/status.png
[Commander]: https://github.com/tj/commander
[Commander.js]: https://github.com/tj/commander.js
[Jump]: https://github.com/flavio/jump
[bst latest release]: https://github.com/arpinum/beastmaster/blob/master/releases/bst
