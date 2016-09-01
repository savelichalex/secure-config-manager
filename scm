#!/bin/sh

#  scm.sh
#  secure-config-manager
#  Easily create secret configs for swift projects, that should be on main bundle
# after compilation, but not shown on git repo
#
#  Created by savelichalex on 31.08.16.
#  Copyright © 2016 savelichalex. All rights reserved.

# Basic vars

rc_file=.scmrc
config_file_name="config"
config_file="$config_file_name.yml"

# Functions

parse_yaml2() {
    local prefix=$2
    local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
    sed -ne "s|^\($s\)\($w\)$s:$s\"\(.*\)\"$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
    awk -F$fs '{
        indent = length($1)/2;
        vname[indent] = $2;
        for (i in vname) {if (i > indent) {delete vname[i]}}
        if (length($3) > 0) {
            vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
            printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, $2, $3);
        }
    }'
}

init() {
    printf "target: swift\n" > $rc_file
    printf "example: key" > $config_file
    printf "example: key" > "$config_file.sample"
    echo "scm files generated, please update $rc_file and $config_file"
}

help() {
cat <<-EOM
SCM - Easily create secret configs for swift projects

Usage: scm [-i|--init]
           [-g|--generate]
           [-pre|--precompile]
           [-post|--postcompile]
EOM
}

# Get attributes

IS_GENERATE=false
IS_PRECOMPILE=false

for i in "$@"
do
case $i in
    -i|--init)
    init
    exit 0
    shift
    ;;
    -g|--generate)
    IS_GENERATE=true
    shift
    ;;
    -pre|--precompile)
    IS_PRECOMPILE=true
    shift
    ;;
    -post|--postcompile)
    IS_GENERATE=true
    shift
    ;;
    -h|--help)
    help
    exit 0
    shift
    ;;
esac
done

# Create 'prototype' props

project_folder="."
target="swift"
gen_interface_name="SecretConfig"
# also
# config_file_name

# Parse config for util that might replace 'prototype' props
eval $(parse_yaml2 ".scmrc")

config_file="$config_file_name.yml"

# Create path to real app config
config_path="$project_folder/$config_file"

# Parse config and create interface
prefix="___user_config___"
eval $(parse_yaml2 $config_path $prefix)
from_config_vars=($(compgen -v $prefix))
for ((i=0; i<${#from_config_vars[@]}; i++))
do
    var=${from_config_vars[$i]}
    name=${var#$prefix}
    interface_empty_str+="    static let $name: String? = nil\n"
    interface_full_str+="    static let $name: String? = \""${!var}"\"\n"
done

# Write result

SOURCE_FILE="$project_folder/$gen_interface_name.$target"

if [ "$IS_GENERATE" == true ]; then
echo "Generate interface in $SOURCE_FILE"
printf "class $gen_interface_name {\n$interface_empty_str}" > $SOURCE_FILE
elif [ "$IS_PRECOMPILE" == true ]; then
echo "Generate actual config in $SOURCE_FILE"
printf "class $gen_interface_name {\n$interface_full_str}" > $SOURCE_FILE
fi
