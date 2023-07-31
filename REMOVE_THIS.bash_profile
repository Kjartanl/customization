
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

# Call powershell script which in turn enables
# system-wide proxy settings (environment 
# variables for the User scope):
proxy-on(){
    powershell /c/users/<username>/proxy-on.ps1
}

# Call powershell script which in turn disables
# system-wide proxy settings (environment 
# variables for the User scope):
proxy-off(){
    powershell /c/users/<username>/proxy-off.ps1
}



# Get logs from today (default), or logs from
# X number of days ago by looking up all log 
# files from /c/logs/ with filenames that 
# start with the date.
daylogs(){
    if [ "$1" ]; then
      desired_date=$(date -d "$1 days ago" -I)
    else
      desired_date=$(date -I)
    fi

    find /c/logs/ -name "{$desired_date}*" 
}

# Move all log files into the archive-directory
archlogs(){
    log_dir="/c/logs"
    arch_dir_name="archive"
    todays_date_dir_name=$(date +%FT%T)
    log_arch_dir="$log_dir/$arch_dir_name/$todays_date_dir_name"

    if [ ! -d "$log_arch_dir" ]; then
        mkdir -p "$log_arch_dir"
    fi

    # Move all directories in "log_dir" except "arch_dir_name" into "log_arch_dir":
    find "$log_dir"/* -maxdepth 0 ! -name "$arch_dir_name" -type d -exec mv {} "$log_arch_dir" \;

echo "Moved all logs into {$log_arch_dir}"
}


# Move all log files into the archive-directory
clearlogs(){
    log_dir="/c/logs"
    arch_dir_name="archive"

    # Delete all directories in "log_dir" except "arch_dir_name":
    find "$log_dir"/* -maxdepth 0 ! -name "$arch_dir_name" -type d -exec rm -rf {} "$log_arch_dir" \;

    echo "Cleared all non-archived logs in /c/logs/"
}


