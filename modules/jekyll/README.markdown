# jekyll #

This is the jekyll module. It provides...

## Parameters
* `showDrafts - boolean` (false by default) toggle showing draft posts
* `showFuture - boolean` (false by default) toggle showing future dated posts

## Notes
When running in a Windows host, remember to run [dos2unix](http://dos2unix.sourceforge.net/) to convert the `templates/jekyll.sh.erb` file or else the service startup script will fail.  
Jekyll typically runs on port 4000


## Running locally
* `vagrant up blog-test`
* The `ubuntu.vm.synced_folder "~/IdeaProjects/ahopgood.github.io", "/blog"` location should point to where the jekyll project is located
* You may need to create a `published_blog` directory for the generated output to be stored in.
* Blog can be found on [http://192.168.33.28:4000/](http://192.168.33.28:4000/)
