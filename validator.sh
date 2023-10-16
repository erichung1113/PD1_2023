#! /bin/bash

# Configuration
HW=4
ToDo="A B"
# -------------

FilePath=~/HW$HW

if (( $# != 0 )); then
    if [[ $1 =~ /* ]]; then
        FilePath=$1
    else
        ToDo=$@
    fi
fi

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
RESET='\033[0m'

if ! test -d $FilePath/your_answer ; then mkdir $FilePath/your_answer; fi
if test -d $FilePath/testcase ; then rm -r $FilePath/testcase; fi 
mkdir $FilePath/testcase
cp -r /share/HW$HW/* $FilePath/testcase

for p in $ToDo; do
    echo -e "${YELLOW}Testing p$p.c ...${RESET}\n-----------------------------"

    if ! test -d $FilePath/your_answer/p$p ; then mkdir $FilePath/your_answer/p$p; fi
    if test -f $FilePath/$p ; then rm $FilePath/$p; fi 
    gcc $FilePath/p$p.c -o $FilePath/$p
    if (( $? != 0 )); then 
        echo -e "${YELLOW}Compilation Error${RESET}"
        echo "-----------------------------"
        continue; 
    fi

    for tc_name in $(ls $FilePath/testcase/p$p | grep 'in$' | sed 's/.in//'); do
        input=$FilePath/testcase/p$p/$tc_name.in
        answer=$FilePath/testcase/p$p/$tc_name.out
        result=$FilePath/your_answer/p$p/$tc_name.out
        echo -n "$tc_name : "
        ExecResult=$(timeout 1 bash -c "$FilePath/$p < $input > $result" 2>&1)
        ExecReturnValue=$?
        if (( $ExecReturnValue != 0 )); then 
            if (( $ExecReturnValue == 124 )); then
                echo -e "${BLUE}Time Limit Exceed${RESET}"
            else
                echo -e "${YELLOW}Runtime Error${RESET}"
                echo $ExecResult
            fi
        else
            # diff $result $answer >> /dev/null
            /usr/local/bin/hw4_tester $p $result $answer
            if (( $? == 0 )); then
                echo -e "${RED}WA${RESET}"
	    	echo -e "${BLUE}Input   Data${RESET}   : \n$(cat $input)"
	    	echo -e "${BLUE}Your    Answer${RESET} : \n$(cat $result)"
	    	echo -e "${BLUE}Correct Answer${RESET} : \n$(cat $answer)"
            echo -e "${YELLOW}Note: You can use the following command to compare your code's output with the TA's answer :${RESET}\ndiff ~/HW$HW/your_answer/p$p/$tc_name.out ~/HW$HW/testcase/p$p/$tc_name.out" 
            else    
                echo -e "${GREEN}AC${RESET}"
            fi
        fi
        echo "-----------------------------"
    done
done
