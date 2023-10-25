#! /bin/bash

# Configuration
HW=4
ProblemID="A B"
Score=(50 50)
# -------------

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
RESET='\033[0m'

if [[ $(basename $(pwd)) = "HW$HW" ]]; then
    FilePath=$(pwd)
else
    FilePath=~/HW$HW
fi

while (( $# != 0 )); do
    if [[ $1 = "-p" ]]; then
        shift 1
        FilePath=$1
    else
        todo="$todo $1"
    fi
    shift 1
done
if [[ $todo != "" ]]; then ProblemID=$todo; fi

echo "=> Using path : $FilePath"

if ! test -d $FilePath/your_answer ; then mkdir $FilePath/your_answer; fi
if test -d $FilePath/testcase ; then rm -r $FilePath/testcase; fi 
mkdir $FilePath/testcase
cp -r /share/HW${HW}_TestCase/* $FilePath/testcase

score=0
for p in $ProblemID; do
    echo -e "${YELLOW}Testing p$p.c ...${RESET}\n-----------------------------"

    if ! test -d $FilePath/your_answer/p$p ; then mkdir $FilePath/your_answer/p$p; fi
    if test -f $FilePath/$p ; then rm $FilePath/$p; fi 
    gcc $FilePath/p$p.c -o $FilePath/$p
    if (( $? != 0 )); then 
        echo -e "${YELLOW}Compilation Error${RESET}"
        echo "-----------------------------"
        continue; 
    fi
    Pass_TC_Cnt=0
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
            diff $result $answer >> /dev/null
            if (( $? != 0 )); then
                echo -e "${RED}WA${RESET}"
                echo -e "${BLUE}Input   Data${RESET}   : \n$(cat $input)"
                echo -e "${BLUE}Your    Answer${RESET} : \n$(cat $result)"
                echo -e "${BLUE}Correct Answer${RESET} : \n$(cat $answer)"
                echo -e "${YELLOW}Note: You can use the following command to compare your code's output with the TA's answer :${RESET}\ndiff ~/HW$HW/your_answer/p$p/$tc_name.out ~/HW$HW/testcase/p$p/$tc_name.out" 
            else
                echo -e "${GREEN}AC${RESET}"
                (( Pass_TC_Cnt++ ))
            fi
        fi
        echo "-----------------------------"
    done

    TC_Cnt=$(ls $FilePath/testcase/p$p | grep 'in$' | wc -l)
    if (( $Pass_TC_Cnt == $TC_Cnt )); then
        (( score += ${Score[(( $(printf "%d" "'$p") - 65 ))]} ))
    fi
done
echo -e "\nTotal Score : $score/100"
exit $score
