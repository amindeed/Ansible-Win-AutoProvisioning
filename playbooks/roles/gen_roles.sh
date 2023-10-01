#!/bin/bash

original_dir="$(pwd)"
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$script_dir"

rm -rf setup-nodejs14; rm -rf setup-nodejs16; rm -rf setup-nodejs18; rm -rf setup-nodejs

cp -r _role-template_ setup-nodejs14; cp -r _role-template_ setup-nodejs16; cp -r _role-template_ setup-nodejs18; cp -r _role-template_ setup-nodejs

cd "$original_dir"
