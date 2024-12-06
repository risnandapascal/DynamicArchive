#!/bin/bash
set -e

usage() {
    echo -e "\nUsage: $0"
    echo "1) Archive a folder into an encrypted tar file 📦🔒"
    echo "2) Extract an encrypted tar file 📥🔒"
    echo "3) Archive a folder into an encrypted zip file 📦🔒"
    echo "4) Extract an encrypted zip file 📥🔒"
    echo "5) Archive a folder into an encrypted 7z file 📦🔒"
    echo "6) Extract an encrypted 7z file 📥🔒"
    echo "7) Archive a folder into an encrypted gz file 📦🔒"
    echo "8) Extract an encrypted gz file 📥🔒"
    echo -e "Please choose an option (1, 2, 3, 4, 5, 6, 7, or 8):\n"
}

error_message() {
    echo -e "\e[31mError: $1\e[0m" 
}

display_menu() {
    clear
    echo -e "\e[1;34m==================================================================\e[0m"
    echo -e "\e[1;32m      DynamicArchive          \e[0m"  
    echo -e "\e[1;32m      https://github.com/risnandapascal/DynamicArchive\e[0m"        
    echo -e "\e[1;34m==================================================================\e[0m"
    echo -e
    
    echo -e "\e[1;33m========== TAR ==========\e[0m" 
    echo "1) Archive 📦🔒"
    echo "2) Extract 📥🔒"
    echo -e "\e[1;33m========================\e[0m"    
    echo -e
    
    echo -e "\e[1;33m========== ZIP ==========\e[0m"  
    echo "3) Archive 📦🔒"
    echo "4) Extract 📥🔒"
    echo -e "\e[1;33m========================\e[0m"  
    echo -e

    echo -e "\e[1;33m========== 7z ==========\e[0m"  
    echo "5) Archive 📦🔒"
    echo "6) Extract 📥🔒"
    echo -e "\e[1;33m========================\e[0m"   
    echo -e

    echo -e "\e[1;33m========== GZ ==========\e[0m"  
    echo "7) Archive 📦🔒"
    echo "8) Extract 📥🔒"
    echo -e "\e[1;33m========================\e[0m"  
    echo -e

    echo -e "\e[1;34m==============================\e[0m" 
}

trap 'echo -e "\nDynamicArchive has been terminated."; exit' INT

validate_filename() {
    if [[ "$1" =~ [^a-zA-Z0-9._-] ]]; then
        error_message "Invalid filename. Only alphanumeric characters, dots, underscores, and hyphens are allowed."
        return 1
    fi
    return 0
}

check_command() {
    command -v "$1" >/dev/null 2>&1 || { error_message "$1 is not installed. Please install $1 and try again."; exit 1; }
}

check_command gpg
check_command tar
check_command zip
check_command 7z

while true; do
    display_menu
    read -p "Enter your choice (1, 2, 3, 4, 5, 6, 7, or 8): " choice

    case $choice in
        1)
            read -p "Enter the path of the folder you want to archive: " folder
            if [ -d "$folder" ]; then
                read -p "Enter the output filename (e.g., output.tar): " output
                if validate_filename "$output"; then
                    tar -cvf "$output" -C "$(dirname "$folder")" "$(basename "$folder")" || error_message "Failed to archive the folder."
                    gpg -c "$output" && rm "$output" || error_message "Failed to encrypt the file."
                    echo -e "\e[1;32mFolder '$folder' has been archived and encrypted into '$output.gpg'. 🎉\e[0m" 
                fi
            else
                error_message "Folder '$folder' not found."
            fi
            ;;
        2)
            read -p "Enter the name of the encrypted tar file (e.g., output.tar.gpg): " input
            if [ -f "$input" ]; then
                gpg -d "$input" > "${input%.gpg}" || error_message "Failed to decrypt the file."
                tar -xvf "${input%.gpg}" || error_message "Failed to extract the file."
                rm "${input%.gpg}"
                echo -e "\e[1;32mFile '$input' has been decrypted and extracted. 📂\e[0m" 
            else
                error_message "File '$input' not found."
            fi
            ;;
        3)
            read -p "Enter the path of the folder you want to archive: " folder
            if [ -d "$folder" ]; then
                read -p "Enter the output filename (e.g., output.zip): " output
                if validate_filename "$output"; then
                    zip -r "$output" "$folder" || error_message "Failed to archive the folder."
                    gpg -c "$output" && rm "$output" || error_message "Failed to encrypt the file."
                    echo -e "\e[1;32mFolder '$folder' has been archived and encrypted into '$output.gpg'. 🎉\e[0m" 
                fi
            else
                error_message "Folder '$folder' not found."
            fi
            ;;
        4)
            read -p "Enter the name of the encrypted zip file (e.g., output.zip.gpg): " input
            if [ -f "$input" ]; then
                gpg -d "$input" > "${input%.gpg}" || error_message "Failed to decrypt the file."
                unzip "${input%.gpg}" || error_message "Failed to extract the file."
                rm "${input%.gpg}" 
                echo -e "\e[1;32mFile '$input' has been decrypted and extracted. 📂\e[0m" 
            else
                error_message "File '$input' not found."
            fi
            ;;
        5)
            read -p "Enter the path of the folder you want to archive: " folder
            if [ -d "$folder" ]; then
                read -p "Enter the output filename (e.g., output.7z): " output
                if validate_filename "$output"; then
                    7z a "$output" "$folder" || error_message "Failed to archive the folder."
                    gpg -c "$output" && rm "$output" || error_message "Failed to encrypt the file."
                    echo -e "\e[1;32mFolder '$folder' has been archived and encrypted into '$output.gpg'. 🎉\e[0m" 
                fi
            else
                error_message "Folder '$folder' not found."
            fi
            ;;
        6)
            read -p "Enter the name of the encrypted 7z file (e.g., output.7z.gpg): " input
            if [ -f "$input" ]; then
                gpg -d "$input" > "${input%.gpg}" || error_message "Failed to decrypt the file."
                7z x "${input%.gpg}" || error_message "Failed to extract the file."
                rm "${input%.gpg}" 
                echo -e "\e[1;32mFile '$input' has been decrypted and extracted. 📂\e[0m" 
            else
                error_message "File '$input' not found."
            fi
            ;;
        7)
            read -p "Enter the path of the folder you want to archive: " folder
            if [ -d "$folder" ]; then
                read -p "Enter the output filename (e.g., output.gz): " output
                if validate_filename "$output"; then
                    tar -czf "$output" -C "$(dirname "$folder")" "$(basename "$folder")" || error_message "Failed to archive the folder."
                    gpg -c "$output" && rm "$output" || error_message "Failed to encrypt the file."
                    echo -e "\e[1;32mFolder '$folder' has been archived and encrypted into '$output.gpg'. 🎉\e[0m" 
                fi
            else
                error_message "Folder '$folder' not found."
            fi
            ;;
        8)
            read -p "Enter the name of the encrypted gz file (e.g., output.gz.gpg): " input
            if [ -f "$input" ]; then
                gpg -d "$input" > "${input%.gpg}" || error_message "Failed to decrypt the file."
                tar -xzf "${input%.gpg}" || error_message "Failed to extract the file."
                rm "${input%.gpg}" 
                echo -e "\e[1;32mFile '$input' has been decrypted and extracted. 📂\e[0m" 
            else
                error_message "File '$input' not found."
            fi
            ;;
        *)
            error_message "Invalid choice. Please try again."
            usage
            ;;
    esac

    read -p "Would you like to perform another operation? (y/n): " continue_choice
    if [[ ! "$continue_choice" =~ ^[Yy]$ ]]; then
        echo -e "\e[1;34mThank you for using DynamicArchive. #Security! 🛡️\e[0m" 
        break
    fi
done
