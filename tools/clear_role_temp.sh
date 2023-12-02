#!/bin/bash

directory="/home/amine/Ansible_Windows_Auto_Provisioning/main/playbooks/roles/ans-win-auto-prov/temp"

gitignore_path="$directory/.gitignore"
if [ -e "$gitignore_path" ]; then
    find "$directory" -mindepth 1 ! -name '.gitignore' -exec rm -r {} \;
else
    echo "The .gitignore file is not found directly in the directory."
fi

