#!/bin/bash

original_dir="$(pwd)"
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$script_dir"

#rm -rf setup-nodejs; rm -rf setup-cygwin; rm -rf setup-openjdk8; rm -rf setup-dbeaver; rm -rf setup-gitextensions; rm -rf setup-umldesigner; rm -rf setup-maven; rm -rf setup-python2; rm -rf setup-python3

cp -r _role-template_ setup-nodejs; cp -r _role-template_ setup-cygwin; cp -r _role-template_ setup-openjdk8; cp -r _role-template_ setup-openjdk11; cp -r _role-template_ setup-openjdk17; cp -r _role-template_ setup-dbeaver; cp -r _role-template_ setup-gitextensions; cp -r _role-template_ setup-umldesigner; cp -r _role-template_ setup-maven; cp -r _role-template_ setup-python2; cp -r _role-template_ setup-python3; cp -r _role-template_ test; cp -r _role-template_ finalize-system

cd "$original_dir"
