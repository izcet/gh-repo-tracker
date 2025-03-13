
a pile of scripts to automate checking the health of my git repositories and what needs to be fixed for them

1. Set up an obsidian vault with a kanban plugin
2. clone this repo inside that vault
	1. I make some assumptions about defaults, such as the board being named `_KANBAN.md`, the default column to dump everything being named `## undone` and the card notes being put into `items/<username>/<projectname>`
3. Visit https://github.com/settings/repositories
	1. save the page as html 
	2. use dump-items.sh to extract the repos from the html
	3. use insert-items.sh to put the repos in your obsidian tracker
4. Visit https://gist.github.com/(yourname)
	1. save the page as html
	2. use dump-gists.sh to extract
	3. use insert-gists to put them in your tracker
5. use the new tracker! congrats!
