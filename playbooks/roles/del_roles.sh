#!/bin/bash

original_dir="$(pwd)"
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$script_dir"

rm -rf setup-7zip; rm -rf setup-adobereader; rm -rf setup-beyondcompare; rm -rf setup-drawio; rm -rf setup-firefox; rm -rf setup-greenshot; rm -rf setup-kdiff3; rm -rf setup-keepass; rm -rf setup-keystoreexplorer; rm -rf setup-marktext; rm -rf setup-notepadpp; rm -rf setup-openssl; rm -rf setup-pandoc; rm -rf setup-software; rm -rf setup-vscode; rm -rf setup-msoffice; rm -rf setup-regshot; rm -rf setup-sysinternals; rm -rf setup-dependencywalker; rm -rf setup-treesize; rm -rf setup-nodejs; rm -rf setup-cygwin; rm -rf setup-openjdk8; rm -rf setup-openjdk11; rm -rf setup-openjdk17; rm -rf setup-dbeaver; rm -rf setup-gitextensions; rm -rf setup-umldesigner; rm -rf setup-maven; rm -rf setup-python2; rm -rf setup-python3; rm -rf install-psmodules

#find . -mindepth 1 -type d ! -name "_role-template_*" -exec rm -r {} \;

cd "$original_dir"
