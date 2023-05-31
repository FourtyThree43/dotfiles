#!/usr/bin/env bash
# Task Initialization Script.


# Check if folder name arguments are provided
if [ $# -eq 0 ]; then
	echo "Folder name argument is missing."
    echo -e "Usage:\n $0 folder_name\n $0 folder_name1 folder_name2 folder_name3 .."
    exit 1
fi

# Print a colorful header
echo -e "\033[1;33m+-------------------------------+"
echo -e "|   \033[1;35mTask Initialization Script  \033[1;33m|"
echo -e "+-------------------------------+\033[0m"

# Initialize the progress bar
echo -ne "Progress:\n"
bar_length=30
progress=0

# Loop over folder name arguments
for folder_name in "$@"; do
    # Check if the directory exists
    if [[ -d "$folder_name" && -e "$folder_name" ]]; then
        echo "The directory '$folder_name' already exists."
        exit 1
    else
        echo "Initializing Task Directory: '$folder_name'"

        # Create the directory and continue with the script.
        mkdir "$folder_name"
        cd "$folder_name" || exit 1

        current_folder_name=$(basename "$PWD")
		if [ "$current_folder_name" == "$folder_name" ]; then
		    echo "$folder_name/. => creation [✔] D O N E !"
		else
		    echo "Error: Failed to change to the directory '$folder_name'"
		    exit 1
		fi

        # Check if the parent directory is a Git repository
        parent_dir=$(dirname "$PWD")
        if git -C "$parent_dir" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
            parent_repo_name=$(basename "$parent_dir")
            echo "Parent directory is a Git repository with name: $parent_repo_name"

            # Get repository author name
            author_name=$(git -C "$parent_dir" log --format='%aN' | head -n 1)
            if [ -n "$author_name" ]; then
                { echo -e "# $parent_repo_name\n";echo -e "$folder_name\n"; figlet -c -f smkeyboard "$author_name"; figlet -c -f Doh "1x43"; } >> README.md
                echo "README.md => creation [✔] D O N E !"
            else
                { echo -e "# $parent_repo_name\n";echo -e "$folder_name\n"; figlet -c -f Epic "1x43"; figlet -c -f Doh "FT43"; } >> README.md
                echo "README.md => creation [✔] D O N E !"
            fi
        else
            # Get current and parent folder names
            parent_folder_name=$(basename "$(dirname "$PWD")")
            echo "Parent folder: $parent_folder_name"

            { echo -e "# $parent_folder_name\n"; echo -e "$folder_name\n"; figlet -c -f Doh "FT43"; figlet -c -f larry3d "1x43"; } >> README.md
    		echo "README.md => creation [✔] D O N E !"
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
echo -e "\n\033[1;32mC O M P L E T E ! [✔] \033[0m"
