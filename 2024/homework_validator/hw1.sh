#! /bin/bash

# Configuration
HW=1
Subtask="A B C D"
Score=(20 20 20 40)
# -------------

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;36m'
ORANGE='\033[40m'
RESET='\033[0m'


if [[ $(basename $(pwd)) = "HW${HW}" ]]; then
    FilePath=$(pwd)
else
    FilePath=~/HW${HW}
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
if [[ $todo != "" ]]; then Subtask=$todo; fi

if test -d $FilePath/result ; then rm -r $FilePath/result; fi
mkdir $FilePath/result

score=0
echo -e "=> Using Path : $FilePath"

for subtask in $Subtask; do
    echo -e "${YELLOW}Testing p${subtask} ...${RESET}"

    if test -f $FilePath/p${subtask} ; then rm $FilePath/p${subtask}; fi
    
    CompileResult=$(gcc $FilePath/p${subtask}.c -o $FilePath/p${subtask} 2>&1)
    CompileReturnValue=$?

    if (( CompileReturnValue != 0 )); then
        if ! test -f $FilePath/p${subtask}.c; then
            echo -e "${RED}File p${subtask}.c not found.${RESET}"
        else
            echo -e "${YELLOW}Compilation Error${RESET}"
            echo $CompileResult
        fi
    else
        mkdir $FilePath/result/p${subtask}

        All_Pass="true"
        for tc_name in $(ls /share/HW${HW}_TC/p${subtask} | grep 'in$' | sed 's/.in//'); do
            echo "-----------------------------"

            input=/share/HW${HW}_TC/p${subtask}/$tc_name.in
            answer=/share/HW${HW}_TC/p${subtask}/$tc_name.out
            userans=$FilePath/result/p${subtask}/$tc_name.out

            echo -n "Test Case $tc_name : "
            ExecResult=$(timeout 1 bash -c "$FilePath/p${subtask} < $input > $userans" 2>&1)
            ExecReturnValue=$?
            
            if (( $ExecReturnValue != 0 )); then
                if (( $ExecReturnValue == 124 )); then
                    echo -e "${BLUE}Time Limit Exceed${RESET}"
                else
                    echo -e "${RED}Runtime Error${RESET}"
                    echo $ExecResult
                fi
                All_Pass="false"
            else
                diff $userans $answer > /dev/null 
                if (( $? == 1 )); then
                    echo -e "${RED}Wrong Answer${RESET}"
                    echo -e -n "${BLUE}Input   Data${RESET} : \n$(cat $input | head -c 50)"
                    if (( $(cat $input | wc -m) > 50)) ; then
                        echo "....(more)"
                    else
                        echo ""
                    fi
                    echo -e -n "\n${BLUE}Your    Answer${RESET} : \n$(cat $userans | head -c 50)"
                    if (( $(cat $userans | wc -m) > 50)) ; then
                        echo "....(more)"
                    else
                        echo ""
                    fi
                    echo -e -n "\n${BLUE}Correct Answer${RESET} : \n$(cat $answer | head -c 50)"
                    if (( $(cat $answer | wc -m) > 50)) ; then
                        echo "....(more)"
                    else
                        echo ""
                    fi
                    echo -e "\nYour answer : $userans"
                    echo -e "Correct answer : $answer"
                    
                    All_Pass="false"
                else
                    echo -e "${GREEN}ACCEPT${RESET}"
                fi
                
            fi
            # echo "-----------------------------"

        done

        if [ "$All_Pass" = "true" ] ; then
            (( score += ${Score[(( $(printf "%d" "'${subtask}") - 65 ))]} ))
        fi
    fi
    echo "============================="
done


echo -e "\nTotal Score : $score/100"
exit $score
