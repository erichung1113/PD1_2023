#! /bin/bash

# Configuration
HW=7
Subtask="1 2 3 4 5 6 7 8"
Score=(10 10 10 10 10 10 10 30)
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

clean="False"

while (( $# != 0 )); do
    if [[ $1 = "clean" ]]; then
        clean="True"
    elif [[ $1 = "-p" ]]; then
        shift 1
        FilePath=$1
    else
        todo="$todo $1"
    fi
    shift 1
done

if [[ $clean == "True" ]]; then 
    rm -r $FilePath/bin $FilePath/result
    exit 0
fi


if [[ $todo != "" ]]; then Subtask=$todo; fi

if test -d $FilePath ; then 
    echo -e "=> Using Path : $FilePath"
    cd $FilePath
else
    echo -e "${RED}Can not find path: ${FilePath}${RESET}"
    exit 0
fi

check_answer() {
    local userans=$1
    local answer=$2
    local input=$3

    diff -Z $userans $answer > /dev/null
    if (( $? == 1 )); then
        output+="${RED}Wrong Answer${RESET}\n"
        output+="${BLUE}Input   Data${RESET} : \n$(cat $input | head -c 50)"
        if (( $(cat $input | wc -m) > 50)) ; then
            output+="....(more)\n"
        else
            output+="\n"
        fi
        output+="\n${BLUE}Correct Answer${RESET} : \n$(cat $answer | head -c 50)"
        if (( $(cat $answer | wc -m) > 50)) ; then
            output+="....(more)\n"
        else
            output+="\n"
        fi
        output+="\n${BLUE}Your    Answer${RESET} : \n$(cat $userans | head -c 50)"
        if (( $(cat $userans | wc -m) > 50)) ; then
            output+="....(more)\n"
        else
            output+="\n"
        fi

        output+="\n${BLUE}Difference${RESET} : \n$(diff $answer $userans | head -c 50)"
        if (( $(diff $answer $userans | wc -m) > 50)) ; then
            output+="....(more)\n"
        else
            output+="\n"
        fi

        output+="\n\nInput Data : $input\n"
        output+="Correct answer : $answer\n"
        output+="Your answer : $FilePath/$userans\n"
        
        All_Pass="false"
    else
        output+="${GREEN}ACCEPT${RESET}\n"
    fi
}

if test -d result ; then rm -r result; fi
mkdir result

if test -d bin ; then rm -r bin; fi
mkdir bin

score=0
for subtask in $Subtask; do
    cp /share/HW${HW}_TC/hw${HW}-${subtask}/main.c main_p${subtask}.c
    CompileCommand="gcc main_p${subtask}.c hw${HW}-${subtask}.c -o bin/hw${HW}-${subtask}"
    if (( subtask == 3 )); then
        CompileCommand="gcc main_p${subtask}.c hw7-3.c hw7-2.c -o bin/hw${HW}-${subtask}"
    fi
    if (( subtask == 6 )); then
        CompileCommand="gcc main_p${subtask}.c hw7-6.c hw7-3.c hw7-2.c -o bin/hw${HW}-${subtask}"
    fi
    if (( subtask == 8 )); then
        CompileCommand="gcc main_p${subtask}.c hw7-1.c hw7-2.c hw7-3.c hw7-4.c hw7-5.c hw7-6.c hw7-7.c -o bin/hw${HW}-${subtask}"
    fi

    CompileResult=$( $CompileCommand 2>&1)
    CompileReturnValue=$?
    rm main_p${subtask}.c

    output=""
    All_Pass="true"
    if (( CompileReturnValue != 0 )); then
        if ! test -f hw${HW}-${subtask}.c; then
            output+="File hw${HW}-${subtask}.c not found.\n"
        else
            output+="${YELLOW}Compilation Error${RESET}\n"
            output+="$CompileResult\n"
        fi
        All_Pass="false"
    else
        mkdir result/hw${HW}-${subtask}
        
        for tc_name in $(ls /share/HW${HW}_TC/hw${HW}-${subtask} | grep 'in$' | sed 's/.in//'); do
            output+="-----------------------------\n"
            output+="Test Case $tc_name : "
            
	    Input=/share/HW${HW}_TC/hw${HW}-${subtask}/$tc_name.in
            Answer=/share/HW${HW}_TC/hw${HW}-${subtask}/$tc_name.out
            Userans=result/hw${HW}-${subtask}/$tc_name.out
            argv=/share/HW${HW}_TC/hw${HW}-${subtask}/$tc_name.argv
            
            ExecuteCommand="bin/hw${HW}-${subtask}"
            if test -f $argv ; then ExecuteCommand="$ExecuteCommand $(cat $argv)"; fi
            # output+="$ExecuteCommand\n"

            ExecResult=$(timeout 1 bash -c "$ExecuteCommand < $Input > $Userans" 2>&1)
            ExecReturnValue=$?
            
            if (( $ExecReturnValue != 0 )); then
                if (( $ExecReturnValue == 124 )); then
                    output+="${BLUE}Time Limit Exceed${RESET}\n"
                else
                    output+="${RED}Runtime Error${RESET}\n"
                    output+="$ExecResult\n"
                fi
                All_Pass="false"
            else
                check_answer $Userans $Answer $Input
            fi
        done
    fi

    if [ "$All_Pass" = "true" ] ; then
        echo -e "${YELLOW}hw${HW}-${subtask}: ${GREEN}ACCEPT${RESET}"
        (( score += ${Score[(( $(printf "%d" "'${subtask}") - 49 ))]} ))
    else
        echo -e "${YELLOW}hw${HW}-${subtask}: ${RED}NOT ACCEPT${RESET}"
        printf "%b" "$output"
    fi
    echo "============================="
done


echo -e "\nTotal Score : $score/100"
exit $score
