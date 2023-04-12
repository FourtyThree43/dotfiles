#!/bin/bash

## ------------ COLORS ------------ ##

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

check_output=$(find . -name '*.py' -exec pycodestyle --show-source --statistics {} +)

if [[ $check_output == "" ]]; then
  printf "${BGreen}Check Done!${Color_off} ${BYellow}No errors found.${Color_off}\n"
else
  printf "${BGreen}Check Done!${Color_off} ${BPurple}Errors found:${Color_off}\n"
  #printf "${White}$check_output${Color_off}\n"
  #echo "$check_output" | perl -F: -lane 'if ($F[0] =~ /^\.\//) {printf "\033[0;33m%s\033[0m:%s:%s\033[1;31m:%s:\033[0m \033[1;36m%s\033[0m\n", $F[0], $F[1], $F[2], $F[3], $F[4]} else {print}'
  echo "$check_output" | awk -F':' '{if (index($1, "./") == 1) printf "\033[0;33m%s\033[0m:%s:%s\033[1;31m:%s:\033[0m \033[1;36m%s\033[0m\n", $1, $2, $3, $4, $5; else print}'
fi
