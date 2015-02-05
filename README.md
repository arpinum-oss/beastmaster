# Beastmaster (bst)

> A beast does not know that he is a beast, and the nearer a man gets to being a beast, the less he knows it.
> <cite>(George MacDonald)</cite>

**Beastmaster** is a Bash tool which can run any command in your favorite projects.

Example:

    bst order my_project "git pull origin master"

## Development progress

Overall progress: 5%, stay tuned :)

* bst config: done \o/
* bst free: todo
* bst list: todo
* bst order: todo
* bst tame: todo

## Taming projects

First you have to tame your pets to keep them close. Use `tame` command.

Go in your project and type `bst tame`:

    > cd ~/code/my_project
    > bst tame
    my_project is now tamed!

You can choose a name if the default name does not suit you (the path basename):

    > bst tame --name=cool_project

Since they all look the same you can tag your pets to recognize them. Use `--tags=name1,name2` option when taming:

    > bst tame --tags=cat_related,java

For simplicity sake, tags won't work with space or comma (oh really?) in it.

## Yell orders to do the dirty work

After having tamed your little army, it's time to order some commands to test your charisma. Use `order` command.

Each command are run in the project directory.

If you want to refresh a single pet:

    > bst order my_project "git pull origin master"

To check the status of all pets tagged as git:

    > bst order --tags=git "git status"

To run the tests of all pets named like "js_project*"

    > bst order "js_project*" "npm test"

Do not forget the "..." to prevent some tricky string interpolation.

## List your projects to review the army

If you don't remember all the minions you have, just use the `list` command to display all the pets.

    > bst list
    cool-project at /home/alone/dev/cool-project (java git hobby)
    bowling-kata at /home/alone/dev/kata/bowling-kata (python training)

## Free a project when you are done with it

Sometimes the cutest pet may turn out to be perfectly useless. The `free` command can handle this situation.

    > bst free my_project
    my_project is running away...

## Tune the configuration like a pro

If you want to clean the mess, open the configuration file:

    > nano ~/.bstconfig

Pro tip: if the `EDITOR` global variable is set, you can also use the `config` shortcut:

    > bst config

The config file use this simple convention:

    name:path:tag1:tag2
    
Example:

    cool-project:/home/alone/dev/cool-project:java:git:hobby
    bowling-kata:/home/alone/dev/kata/bowling-kata:python:training
    
## License

Copyright (C) 2015, Arpinum

**Beastmaster** is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

**Beastmaster** is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with **Beastmaster**.  If not, see [http://www.gnu.org/licenses/lgpl.html].

[http://www.gnu.org/licenses/lgpl.html]: http://www.gnu.org/licenses/lgpl.html    
