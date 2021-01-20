
# Create custom command "repos" which changes 
# the current directory to the value of "dir". 
# Accepts one parameter, which should be a subdirectory
# found under "dir". Used to navigate quickly into 
# the directory for any projects found under 
# (in this case) "c:/Projects".
repos(){
    dir=c:/Projects
    if [ "$1" ]; then
      cd "${dir}/${1}"
    else
      cd "${dir}"
    fi
}

# Custom short-cut command for clearing
# the screen and performing a git diff command.
# Can diff a folder or file if any argument is 
# passed, otherwise the whole current git repo.
# Also supports e.g. --cached to show changes that
# have been added.
# (Note: Requires current dir to be a Git repo). 
cdiff(){
    clear
    if [ "$1" ]; then
    	git diff "${1}"
    else
        git diff
    fi
}

# Custom short-cut command for clearing
# the screen and performing a git status command 
# (assuming the "stat" shortcut is set up in your .gitconfig).
# Works for a folder or file if any argument is passed, 
# otherwise the whole current git repo.
# (Note: Requires current dir to be a Git repo). 
cstat(){
    clear
    if [ "$1" ]; then
    	git stat "${1}"
    else
        git stat
    fi
}

# Custom short-cut command for clearing the screen 
# and performing a git log command (assuming the "lg" 
# shortcut is set up in your .gitconfig). Works for a 
# folder or file if any argument is passed, 
# otherwise the whole current git repo. Also supports
# other arguments, e.g. "-15" to show the last
# 15 commits, instead of the default number.
# (Note: Requires current dir to be a Git repo). 
clg(){
    clear
    if [ "$1" ]; then
    	git lg "${1}"
    else
        git lg
    fi
}
