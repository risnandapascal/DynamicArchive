#!/bin/bash
set -e

usage() {
    echo -e "\nPenggunaan: $0"
    echo "1) Mengarsipkan folder menjadi file tar (encrypted)"
    echo "2) Mengekstrak file tar yang terenskripsi"
    echo "3) Mengarsipkan folder menjadi file zip (encrypted)"
    echo "4) Mengekstrak file zip yang terenskripsi"
    echo -e "Silakan pilih opsi (1, 2, 3, atau 4):\n"
}

error_message() {
    echo -e "\e[31mKesalahan: $1\e[0m" 
}

display_menu() {
    clear

    echo -e "\e[1;34m==============================\e[0m" 
    echo -e "\e[1;32m      DynamicArchive          \e[0m"  
    echo -e "\e[1;32m      https://github.com/risnandapascal/DynamicArchive\e[0m"  
    echo -e "\e[1;34m==============================\e[0m"
    
    echo -e "\e[1;33m      Pilihan Archive        \e[0m" 
    echo -e "\e[1;33m==============================\e[0m"  
    echo "1) Mengarsipkan folder menjadi file tar (encrypted)"
    echo "2) Mengekstrak file tar yang terenskripsi"
    
    echo -e "\e[1;33m==============================\e[0m"  
    echo -e "\e[1;33m      Pilihan ZIP           \e[0m"  
    echo -e "\e[1;33m==============================\e[0m"  
    echo "3) Mengarsipkan folder menjadi file zip (encrypted)"
    echo "4) Mengekstrak file zip yang terenskripsi"
    
    echo -e "\e[1;34m==============================\e[0m" 
}

trap 'echo -e "\nDynamicArchive dihentikan."; exit' INT

validate_filename() {
    if [[ "$1" =~ [^a-zA-Z0-9._-] ]]; then
        error_message "Nama file tidak valid. Hanya karakter alfanumerik, titik, garis bawah, dan tanda hubung yang diperbolehkan."
        return 1
    fi
    return 0
}

while true; do
    display_menu
    read -p "Masukkan pilihan (1, 2, 3, atau 4): " choice

    case $choice in
        1)
            read -p "Masukkan jalur folder yang ingin diarsipkan: " folder
            if [ -d "$folder" ]; then
                read -p "Masukkan nama file output (misal: output.tar): " output
                if validate_filename "$output"; then
                    tar -cvf "$output" -C "$(dirname "$folder")" "$(basename "$folder")" || error_message "Gagal mengarsipkan folder."
                    gpg -c "$output" && rm "$output" || error_message "Gagal mengenkripsi file."
                    echo -e "\e[1;32mFolder '$folder' telah diarsipkan dan dienkripsi menjadi '$output.gpg'.\e[0m" 
                fi
            else
                error_message "Folder '$folder' tidak ditemukan."
            fi
            ;;
        2)
            read -p "Masukkan nama file tar yang terenskripsi (misal: output.tar.gpg): " input
            if [ -f "$input" ]; then
                gpg -d "$input" > "${input%.gpg}" || error_message "Gagal mendekripsi file."
                tar -xvf "${input%.gpg}" || error_message "Gagal mengekstrak file."
                rm "${input%.gpg}"
                echo -e "\e[1;32mFile '$input' telah didekripsi dan diekstrak.\e[0m" 
            else
                error_message "File '$input' tidak ditemukan."
            fi
            ;;
        3)
            read -p "Masukkan jalur folder yang ingin diarsipkan: " folder
            if [ -d "$folder" ]; then
                read -p "Masukkan nama file output (misal: output.zip): " output
                if validate_filename "$output"; then
                    zip -r "$output" "$folder" || error_message "Gagal mengarsipkan folder."
                    gpg -c "$output" && rm "$output" || error_message "Gagal mengenkripsi file."
                    echo -e "\e[1;32mFolder '$folder' telah diarsipkan dan dienkripsi menjadi '$output.gpg'.\e[0m" 
                fi
            else
                error_message "Folder '$folder' tidak ditemukan."
            fi
            ;;
        4)
            read -p "Masukkan nama file zip yang terenskripsi (misal: output.zip.gpg): " input
            if [ -f "$input" ]; then
                gpg -d "$input" > "${input%.gpg}" || error_message "Gagal mendekripsi file."
                unzip "${input%.gpg}" || error_message "Gagal mengekstrak file."
                rm "${input%.gpg}" 
                echo -e "\e[1;32mFile '$input' telah didekripsi dan diekstrak.\e[0m" 
            else
                error_message "File '$input' tidak ditemukan."
            fi
            ;;
        *)
            error_message "Pilihan tidak valid. Silakan coba lagi."
            usage
            ;;
    esac

    read -p "Apakah kamu ingin melakukan operasi lain? (y/n): " continue_choice
    if [[ ! "$continue_choice" =~ ^[Yy]$ ]]; then
        echo -e "\e[1;34mTerima kasih telah menggunakan DynamicArchive. #KeepSecure!\e[0m" 
        break
    fi
done
