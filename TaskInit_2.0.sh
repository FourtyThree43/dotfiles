#!/usr/bin/env bash
# Task Initialization Script.

#
# Copyright (C) 2023 FourtyThree43 (0x43)  <https://github.com/FourtyThree43>
# LICENSE © GNU-GPL3
#

# a simple script to Initialize your ALX tasks #

## ------------ COLORS ------------ ##

# Reset #
Color_Off='\033[0m' # Text Reset

# Regular Colors #
Black='\033[0;30m'  Red='\033[0;31m'     Green='\033[0;32m'  Yellow='\033[0;33m'
Blue='\033[0;34m'   Purple='\033[0;35m'  Cyan='\033[0;36m'   White='\033[0;37m'

# Bold #
BBlack='\033[1;30m' BRed='\033[1;31m'    BGreen='\033[1;32m' BYellow='\033[1;33m'
BBlue='\033[1;34m'  BPurple='\033[1;35m' BCyan='\033[1;36m'  BWhite='\033[1;37m'

# Underline #
UBlack='\033[4;30m' URed='\033[4;31m'    UGreen='\033[4;32m' UYellow='\033[4;33m'
UBlue='\033[4;34m'  UPurple='\033[4;35m' UCyan='\033[4;36m'  UWhite='\033[4;37m'

# Background #
On_Black='\033[40m' On_Red='\033[41m'    On_Green='\033[42m' On_Yellow='\033[43m'
On_Blue='\033[44m'  On_Purple='\033[45m' On_Cyan='\033[46m'  On_White='\033[47m'

## ------------ AUTHOR ALIASES ------------ ##
author_code='FT43'
author_hex='1x43'

# Check if folder name arguments are provided
if [ $# -eq 0 ]; then
    echo -e "${BYellow}Usage:"
    echo -e "\t${BPurple}./script.sh ${BBlue}folder_name"
    echo -e "\t${BPurple}./script.sh ${BBlue}folder_name1 folder_name2 folder_name3 .. ${Color_Off}"
    exit 1
fi

# Print a colorful header
echo -e "\n${BYellow}+-------------+-----------------+"
echo -e "|   ${BPurple}Task Initialization Script  ${BYellow}|"
echo -e "+-------------+-----------------+${Color_Off}"

# Initialize the progress bar
echo -ne "${BCyan}Progress:${Color_Off}\n"
bar_length=20
progress=0

# Loop over folder name arguments
for folder_name in "$@"; do
    # Check if the directory exists
    if [[ -d "$folder_name" && -e "$folder_name" ]]; then
        echo -e "The directory ${BRed}'$folder_name'${Color_Off} already exists."
        exit 1
    else
        echo -e "Initializing Task Directory: ${UPurple}$folder_name${Color_Off}"

        # Create the directory and continue with the script.
        mkdir "$folder_name"
        cd "$folder_name" || exit 1

        current_folder_name=$(basename "$PWD")
		if [ "$current_folder_name" == "$folder_name" ]; then
		    echo -e "${BYellow}$folder_name/ ${BGreen}=> creation [✔] D O N E !${Color_Off}"
		else
		    echo "Error: Failed to change to the directory ${URed}'$folder_name'${Color_Off}"
		    exit 1
		fi

        # Check if the parent directory is a Git repository
        parent_dir=$(dirname "$PWD")
        if git -C "$parent_dir" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
            parent_repo_name=$(basename "$parent_dir")
            echo -e "Parent directory [Git repo]: ${UPurple}$parent_repo_name${Color_Off}"

            # Get repository author name
            author_name=$(git -C "$parent_dir" log --format='%aN' | head -n 1)
            if [ -n "$author_name" ]; then
                { echo -e "# $parent_repo_name\n";echo -e "## $folder_name\n"; figlet -c -f digital  "$author_name"; figlet -c -f block "$author_hex"; echo -e "## ❝ Quote ❞\n"; fortune; } >> README.md
                echo -e "${BYellow}README.md ${BGreen}=> creation [✔] D O N E !${Color_Off}"
            else
                { echo -e "# $parent_repo_name\n";echo -e "## $folder_name\n"; figlet -c -f slant "$author_hex"; figlet -c -f block "$author_code"; echo -e "## ❝ Quote ❞\n"; fortune; } >> README.md
                echo -e "${BYellow}README.md ${BGreen}=> creation [✔] D O N E !${Color_Off}"
            fi
        else
            # Get parent folder name.
            parent_dir_name=$(basename "$(dirname "$PWD")")
            echo -e "Parent directory:${UPurple} $parent_dir_name ${Color_Off}"

            { echo -e "# $parent_dir_name\n"; echo -e "## $folder_name\n"; figlet -c "$author_code"; figlet -c -f block "$author_hex"; echo -e "## ❝ Quote ❞\n"; fortune; } >> README.md
    		echo -e "${BYellow}README.md ${BGreen}=> creation [✔] D O N E !${Color_Off}"
        fi
    fi

    # Update the progress bar
    progress=$((progress + 1))
    percent=$((progress * 100 / $#))
    filled_length=$((progress * bar_length / $#))
    remaining_length=$((bar_length - filled_length))

    # Print the progress bar
    echo -ne "\n["
    printf "%-${filled_length}s" | tr ' ' '='
    printf "%-${remaining_length}s" | tr ' ' ' '
    echo -ne "] $percent%\r"
    sleep 0.1

    # Reset to the initial directory
    cd - > /dev/null || exit 1
done

# Complete the progress bar
echo ""

# Print a colored "Done!" message
echo -e "\n${BGreen}C O M P L E T E ! [✔] ${Color_Off}\n"
