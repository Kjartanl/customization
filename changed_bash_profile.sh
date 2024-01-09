# Verify that the two .bash_profile files (in c:/users and /f/) 
# are identical:
#
echo "------------------"
echo -e "\033[32mVerifying that the two profile files are identical..\033[0m"
profilestatus=$(diff /c/Users/KJLER/.bash_profile /f/.bash_profile)
if [ "$profilestatus" ]; then
echo "--------------------------------------------------------------"
    echo -e "\033[33mWARNING! DIFFERENCES BETWEEN PROFILE FILES: \033[0m"
echo "--------------------------------------------------------------"
    echo -e "\033[31m${profilestatus}\033[0m"
echo "--------------------------------------------------------------"
else
    echo -e "\033[32mAll good! Carrying on...\033[0m"
echo "------------------"
fi

# List the commands available here
lst(){
    echo -e "\033[32mreload\033[0m: Clear, reload bash profile (NB: Won't clear vars etc!)."
    echo -e "\033[32mrepos [repo-name]\033[0m: cd to the specified repo"
    echo -e "\033[32mice\033[0m: cd to the ICE repo "
    echo -e "\033[32mcdiff\033[0m: Clear screen, git diff"
    echo -e "\033[32mcstat\033[0m: Clear screen, git stat"
    echo -e "\033[32mclg\033[0m: Clear screen, git log"
    echo -e "\033[32mprev\033[0m: Save current branch name in local var '\$prev'".
    echo -e "\033[32mproxy-on\033[0m"
    echo -e "\033[32mproxy-off\033[0m"
    echo -e "\033[32mcleardns\033[0m"
    echo -e "\033[32mdaylogs [X]\033[0m: List log files changed today, or up to X days ago"
    echo -e "\033[32marchlogs\033[0m: Move all logs into the archive directory"
    echo -e "\033[32mclearlogs\033[0m: Delete all logs except those in the archive directory"
    echo -e "\033[32mdevtools\033[0m: Run Ice Dev Tools from the command line"
    echo -e "\033[32mazrt\033[0m: Run Azurite Start from /c/azurite/" 
    echo -e "\033[32mazfunc [pip]\033[0m: Activate Py VEnv, Run Ice Az.functions from the command line (optionally running pip install first)"
}

reload(){
    clear
    source ~/.bash_profile
}

# Create custom command "repos" which changes 
# the current directory to the value of "dir". 
# Accepts one parameter, which should be a subdirectory
# found under "dir". Used to navigate quickly into 
# the directory for any projects found under 
# (in this case) "c:/Projects".
repos(){
    dir=c:/appl
    if [ "$1" ]; then
      cd "${dir}/${1}"
    else
      cd "${dir}"
    fi
}

ice(){
    dir=c:/appl/ioc-ice
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
    	git lgi "${1}"
    else
        git lgi
    fi
}

# Store the name of the current git branch in the local 
# variable "prev" (so it will be available as $prev).
prev(){
        prev=$(cstat| grep -o "On branch.*" | sed 's/On branch //g')
}

# Call powershell script which in turn enables
# system-wide proxy settings (environment 
# variables for the User scope):
proxy-on(){
    powershell /c/users/kjler/proxy-on.ps1
}

# Call powershell script which in turn disables
# system-wide proxy settings (environment 
# variables for the User scope):
proxy-off(){
    powershell /c/users/kjler/proxy-off.ps1
}

cleardns(){
	powershell -Command "Start-Process 'powershell' -ArgumentList 'c:\Users\KJLER\clear-dns.ps1' -Verb RunAs"
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

    cd /c/logs
    find -name "$desired_date*" 
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

devtools(){
     cd /c/appl/icedevtools/IceDevTools
    dotnet run
}

azrt(){
    cd /c/azurite
    eval "azurite start"
}

azfunc(){
    cd /c/appl/ioc-ice-azfunctions
    if  [ "$1" ]; then
        if [ "$1" = "pip" ]; then
            echo "Running pip install before AZFunctions..."
            ./.venv/Scripts/python -m pip install -r requirements_dev.txt
        else
            echo "Use 'azfunc pip' to run pip install"
        fi
    fi

    source .venv/Scripts/activate 
    func host start
}

