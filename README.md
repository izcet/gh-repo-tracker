
a pile of scripts to automate checking the health of my git repositories and what needs to be fixed for them

1. Visit https://github.com/settings/repositories
	1. save the page as html 
	2. use dump-items.sh to extract the repos from the html
	3. use insert-items.sh to put the repos in your obsidian tracker
	4. it makes a lot of assumptions about your file structure, for example, my default column is titled "undone" and I'm saving the indvidual pages in items/
2. Visit https://gist.github.com/(yourname)
	1. this part is still WIP