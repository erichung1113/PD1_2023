#! /bin/bash

# Configuration
HW=3
ToDo="A B C D"
# -------------

if (( $# != 0 )); then
    ToDo=$@
fi

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
RESET='\033[0m'

if ! test -d ~/HW$HW/your_answer ; then mkdir ~/HW$HW/your_answer; fi
if test -d ~/HW$HW/testcase ; then rm -r ~/HW$HW/testcase; fi 
mkdir ~/HW$HW/testcase
cp -r /share/HW$HW/* ~/HW$HW/testcase

for p in $ToDo; do
    echo -e "${YELLOW}Testing p$p.c ...${RESET}\n-----------------------------"

    if ! test -d ~/HW$HW/your_answer/p$p ; then mkdir ~/HW$HW/your_answer/p$p; fi
    if test -f ~/HW$HW/$p ; then rm ~/HW$HW/$p; fi 
    g++ ~/HW$HW/p$p.c -o ~/HW$HW/$p
	if (( $? != 0 )); then 
		echo -e "${YELLOW}Compilation Error${RESET}"
  		echo "-----------------------------"
		continue; 
	fi

    for tc_name in $(ls ~/HW$HW/testcase/p$p | grep 'in$' | sed 's/.in//'); do
        input=~/HW$HW/testcase/p$p/$tc_name.in
        answer=~/HW$HW/testcase/p$p/$tc_name.out
        result=~/HW$HW/your_answer/p$p/$tc_name.out
        echo -n "$tc_name : "
		ExecResult=$(timeout 1 bash -c "~/HW$HW/$p < $input > $result" 2>&1)
		ExecReturnValue=$?
		if (( $ExecReturnValue != 0 )); then 
	    	if (( $ExecReturnValue == 124 )); then
				echo -e "${BLUE}Time Limit Exceed${RESET}"
			else
				echo -e "${YELLOW}Runtime Error${RESET}"
				echo $ExecResult		
   			fi
		else
	        diff $result $answer >> /dev/null
	        if (( $? != 0 )); then
	            echo -e "${RED}WA${RESET}"
	            echo "Input   Data   : $(cat $input)" 
	            echo "Your    Answer : $(cat $result)" 
	            echo "Correct Answer : $(cat $answer)" 
	        else
	            echo -e "${GREEN}AC${RESET}"
	        fi
		fi
        echo "-----------------------------"
    done
done
