#! /bin/bash

if ! test -d ~/HW2/your_answer ; then mkdir ~/HW2/your_answer; fi
if ! test -d ~/HW2/testcase ; then 
    mkdir ~/HW2/testcase; 
    cp -r /share/HW2/* ~/HW2/testcase
fi

ToDo=$@
if (( $# == 0 )); then
    ToDo="A B C D"
fi

for p in $ToDo; do
    echo -e "Testing p$p...\n-----------------------------"

    if ! test -d ~/HW2/your_answer/p$p ; then mkdir ~/HW2/your_answer/p$p; fi
    if test -f ~/HW2/$p ; then rm ~/HW2/$p; fi 
    gcc ~/HW2/p$p.c -o ~/HW2/$p

    for i in {1..3}; do
        input=~/HW2/testcase/p$p/$i.in
        answer=~/HW2/testcase/p$p/$i.out
        result=~/HW2/your_answer/p$p/$i.out
        echo -n "testcase $i : "
        ~/HW2/$p < $input > $result
        diff $result $answer >> /dev/null
        if (( $? != 0 )); then
            echo "WA"
            echo "Input   Data   : $(cat $input)" 
            echo "Your    Answer : $(cat $result)" 
            echo "Correct Answer : $(cat $answer)" 
        else
            echo "AC"
        fi
        echo "-----------------------------"
    done
done
