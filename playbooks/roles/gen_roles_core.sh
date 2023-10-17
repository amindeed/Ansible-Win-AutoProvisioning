#!/bin/bash

original_dir="$(pwd)"
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$script_dir"

#rm -rf setup-7zip; rm -rf setup-adobereader; rm -rf setup-beyondcompare; rm -rf setup-drawio; rm -rf setup-firefox; rm -rf setup-greenshot; rm -rf setup-kdiff3; rm -rf setup-keepass; rm -rf setup-keystoreexplorer; rm -rf setup-marktext; rm -rf setup-notepadpp; rm -rf setup-openssl; rm -rf setup-pandoc; rm -rf setup-software; rm -rf setup-vscode; rm -rf setup-msoffice; rm -rf setup-regshot; rm -rf setup-sysinternals; rm -rf setup-dependencywalker; rm -rf setup-treesize

cp -r _role-template_ setup-7zip; cp -r _role-template_ setup-adobereader; cp -r _role-template_ setup-beyondcompare; cp -r _role-template_ setup-drawio; cp -r _role-template_ setup-firefox; cp -r _role-template_ setup-greenshot; cp -r _role-template_ setup-kdiff3; cp -r _role-template_ setup-keepass; cp -r _role-template_ setup-keystoreexplorer; cp -r _role-template_ setup-marktext; cp -r _role-template_ setup-notepadpp; cp -r _role-template_ setup-openssl; cp -r _role-template_ setup-pandoc; cp -r _role-template_ setup-software; cp -r _role-template_ setup-vscode; cp -r _role-template_ setup-msoffice; cp -r _role-template_ setup-regshot; cp -r _role-template_ setup-sysinternals; cp -r _role-template_ setup-dependencywalker; cp -r _role-template_ setup-treesize

cd "$original_dir"
