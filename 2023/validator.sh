#! /bin/bash

# Configuration
HW=11
ProblemID="1"
Score=(500)
# -------------

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
RESET='\033[0m'

if [[ $(basename $(pwd)) = "HW$HW" ]] && [[ $(pwd) != /share* ]]; then
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

score=0
for p in $ProblemID; do
    echo -e "${YELLOW}Testing Subtask $p ...${RESET}\n-----------------------------"

    if test -f $FilePath/hw${HW} ; then rm $FilePath/hw${HW}; fi 
    gcc $FilePath/hw${HW}.c -o $FilePath/hw${HW}
    # g++ --std=c++20 $FilePath/hw${HW}.cpp -o $FilePath/hw${HW}
    if (( $? != 0 )); then 
        echo -e "${YELLOW}Compilation Error${RESET}"
        echo "-----------------------------"
        continue; 
    fi
    
    # input=$FilePath/testcase/p$p/$tc_name.in
    answer=/share/HW11/correct_answer
    usrans=$FilePath/your_answer
    if test -f $usrans; then rm $usrans; fi
    ExecResult=$(timeout 1 bash -c "$FilePath/hw${HW} /share/HW11/routing_table.txt /share/HW11/inserted_prefixes.txt /share/HW11/delete_prefixes.txt /share/HW11/trace_file.txt 8 > $usrans" 2>&1)
    ExecReturnValue=$?
    if (( $ExecReturnValue != 0 )); then
        if (( $ExecReturnValue == 124 )); then
            echo -e "${BLUE}Time Limit Exceed${RESET}"
        else
            echo -e "${YELLOW}Runtime Error${RESET}"
            echo $ExecResult
        fi
    else
        diff $usrans $answer > /dev/null 
        if (( $? == 1 )); then
            echo -e "${RED}Wrong Answer${RESET}"
            echo -e -n "\n${BLUE}Your    Answer${RESET} : \n$(cat $usrans | head -c 500)"
            if (( $(cat $usrans | wc -m) > 500)) ; then
                echo "....(more)"
            else
                echo ""
            fi
            echo -e -n "\n${BLUE}Correct Answer${RESET} : \n$(cat $answer | head -c 500)"
            if (( $(cat $answer | wc -m) > 500)) ; then
                echo "....(more)"
            else
                echo ""
            fi
            echo -e "\ndiff $usrans $answer"
            
        else
            echo -e "${GREEN}ACCEPT${RESET}"
            score=50
        fi
    fi
    echo "-----------------------------"

done
echo -e "\nTotal Score : $score/50"
exit $score
