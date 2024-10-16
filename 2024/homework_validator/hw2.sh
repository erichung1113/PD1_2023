#! /bin/bash

# Configuration
HW=2
Subtask="A B C D E"
Score=(20 20 20 20 20)
# -------------

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;36m'
ORANGE='\033[40m'
RESET='\033[0m'

if [[ $(basename $(pwd)) == "HW${HW}" ]]; then
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

echo -e "=> Using Path : $FilePath"
if ! test -d $FilePath ; then 
    echo -e "${RED}Can not find directory${RESET}" 
    exit 0
fi

cd $FilePath

check_answer() {
    local userans=$1
    local answer=$2
    local input=$3

    if [[ "$subtask" == "B" ]]; then 
        compare_fraction $userans $answer
    elif [[ "$subtask" == "C" && $userans != $Userans ]]; then 
        compare_fraction $userans $answer
    else
        diff $userans $answer > /dev/null
    fi

    if (( $? == 1 )); then
        echo -e "${RED}Wrong Answer${RESET}"
        echo -e -n "${BLUE}Input   Data${RESET} : \n$(cat $input | head -c 50)"
        if (( $(cat $input | wc -m) > 50)) ; then
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
        echo -e -n "\n${BLUE}Your    Answer${RESET} : \n$(cat $userans | head -c 50)"
        if (( $(cat $userans | wc -m) > 50)) ; then
            echo "....(more)"
        else
            echo ""
        fi

        echo -e -n "\n${BLUE}Compare${RESET} : \n"
        diff $answer $FilePath/$userans
        
        echo -e "\nInput Data : $input"
        echo -e "Correct answer : $answer"
        echo -e "Your answer : $FilePath/$userans"
        
        All_Pass="false"
        output="true"
    else
        if [[ "$subtask" != "C" ]]; then 
            echo -e "${GREEN}ACCEPT${RESET}"
        fi
    fi
}

if test -d result ; then rm -r result; fi
mkdir result

score=0
for subtask in $Subtask; do
    echo -e "${YELLOW}Testing p${subtask} ...${RESET}"

    if test -f p${subtask} ; then rm p${subtask}; fi
    
    CompileResult=$(gcc p${subtask}.c -o p${subtask} 2>&1)
    CompileReturnValue=$?

    if (( CompileReturnValue != 0 )); then
        if ! test -f p${subtask}.c; then
            echo -e "${RED}File p${subtask}.c not found.${RESET}"
        else
            echo -e "${YELLOW}Compilation Error${RESET}"
            echo $CompileResult
        fi
    else
        mkdir result/p${subtask}

        All_Pass="true"
        for tc_name in $(ls /share/HW${HW}_TC/p${subtask} | grep 'in$' | sed 's/.in//'); do
            echo "-----------------------------"

            Input=/share/HW${HW}_TC/p${subtask}/$tc_name.in
            Answer=/share/HW${HW}_TC/p${subtask}/$tc_name.out
            Userans=result/p${subtask}/$tc_name.out
            argv=/share/HW${HW}_TC/p${subtask}/$tc_name.argv
            
            echo -n "Test Case $tc_name : "
            ExecuteCommand="./p${subtask}"
            if test -f $argv ; then ExecuteCommand="$ExecuteCommand $(cat $argv)"; fi
            echo $ExecuteCommand

            ExecResult=$(timeout 1 bash -c "$ExecuteCommand < $Input > $Userans" 2>&1)
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
                if [[ "$subtask" == "B" ]]; then 
                    check_answer answer.txt $Answer $Input
                elif [[ "$subtask" == "C" ]]; then
                    output="false"
                    check_answer $Userans $Answer $Input
                    if [[ "$tc_name" == "1" ]]; then 
                        check_answer output01.txt /share/HW${HW}_TC/p${subtask}/output01.txt $Input
                        check_answer banana.txt /share/HW${HW}_TC/p${subtask}/banana.txt $Input
                    else
                        check_answer output02.txt /share/HW${HW}_TC/p${subtask}/output02.txt $Input
                        check_answer output03.txt /share/HW${HW}_TC/p${subtask}/output03.txt $Input
                    fi

                    if [ "$output" = "false" ] ; then
                        echo -e "${GREEN}ACCEPT${RESET}"
                    fi
                else
                    check_answer $Userans $Answer $Input
                fi
                
            fi

        done

        if [ "$All_Pass" = "true" ] ; then
            (( score += ${Score[(( $(printf "%d" "'${subtask}") - 65 ))]} ))
        fi
    fi
    echo "============================="
done


echo -e "\nTotal Score : $score/100"
exit $score
