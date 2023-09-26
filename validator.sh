#! /bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
RESET='\033[0m'

if ! test -d ~/HW2/your_answer ; then mkdir ~/HW2/your_answer; fi
if test -d ~/HW2/testcase ; then rm -r ~/HW2/testcase; fi 
mkdir ~/HW2/testcase
cp -r /share/HW2/* ~/HW2/testcase


ToDo=$@
if (( $# == 0 )); then
    ToDo="A B C D"
fi

for p in $ToDo; do
    echo -e "${YELLOW}Testing p$p...${RESET}\n-----------------------------"

    if ! test -d ~/HW2/your_answer/p$p ; then mkdir ~/HW2/your_answer/p$p; fi
    if test -f ~/HW2/$p ; then rm ~/HW2/$p; fi 
    g++ ~/HW2/p$p.cpp -o ~/HW2/$p

    tcNum=$(find ~/HW2/testcase/p$p -type f -name 'sample_*.in' | wc -l)

    for i in $(seq 1 $tcNum); do
        input=~/HW2/testcase/p$p/sample_$i.in
        answer=~/HW2/testcase/p$p/sample_$i.out
        result=~/HW2/your_answer/p$p/sample_$i.out
        echo -n "Sample Testcase $i : "
        ~/HW2/$p < $input > $result
        diff $result $answer >> /dev/null
        if (( $? != 0 )); then
            echo -e "${RED}WA${RESET}"
            echo "Input   Data   : $(cat $input)" 
            echo "Your    Answer : $(cat $result)" 
            echo "Correct Answer : $(cat $answer)" 
        else
            echo -e "${GREEN}AC${RESET}"
        fi
        echo "-----------------------------"
    done


    for i in {1..3}; do
        input=~/HW2/testcase/p$p/$i.in
        answer=~/HW2/testcase/p$p/$i.out
        result=~/HW2/your_answer/p$p/$i.out
        echo -n "Testcase $i : "
        ~/HW2/$p < $input > $result
        diff $result $answer >> /dev/null
        if (( $? != 0 )); then
            echo -e "${RED}WA${RESET}"
            echo "Input   Data   : $(cat $input)" 
            echo "Your    Answer : $(cat $result)" 
            echo "Correct Answer : $(cat $answer)" 
        else
            echo -e "${GREEN}AC${RESET}"
        fi
        echo "-----------------------------"
    done
done
