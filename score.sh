#! /bin/bash

# To Do
# -lm

# change here
HW=2
ToDo="A B C D"
Score=(30 10 30 30)
# -----------

if test -d ~/Homework/testcase ; then rm -r ~/Homework/testcase; fi 
mkdir ~/Homework/testcase
cp -r /share/HW$HW/* ~/Homework/testcase

score_file="HW${HW}_score.txt"
WA_file="HW${HW}_wa.txt"

echo "id,score" > $score_file
echo "id,score" > $WA_file

for student_id in $(cat ~/students_id.txt); do 
    score=0
    if test -d $student_id/HW$HW ; then
        if ! test -d $student_id/HW$HW/your_answer ; then mkdir $student_id/HW$HW/your_answer; fi 
        
        echo "testing $student_id"
        
        for p in $ToDo; do
            if ! test -f $student_id/HW$HW/p$p.c ; then continue; fi
            if ! test -d $student_id/HW$HW/your_answer/p$p ; then mkdir $student_id/HW$HW/your_answer/p$p; fi
            
            if test -f $student_id/HW$HW/$p ; then rm $student_id/HW$HW/$p; fi 
            gcc -w $student_id/HW$HW/p$p.c -o $student_id/HW$HW/$p -lm 2> /dev/null 
            if (( $? != 0 )); then continue; fi
            
            tcNum=0
            AC=0
            for tc_name in $(ls testcase/p$p | grep 'in$' | sed 's/.in//'); do
                (( tcNum += 1 ))
                input=testcase/p$p/$tc_name.in
                answer=testcase/p$p/$tc_name.out
                result=$student_id/HW$HW/your_answer/p$p/$tc_name.out

                timeout 1 $student_id/HW$HW/$p < $input > $result
                if (( $? != 0 )); then continue; fi
            
                ./tester $p $result $answer
                if (( $? == 1 )); then (( AC += 1 )) ; fi

                # diff $result $answer >> /dev/null
                # if (( $? == 0 )); then (( AC += 1 )) ; fi
            done
            if (( $AC == $tcNum )); then
                (( score += ${Score[(( $(printf "%d" "'$p") - 65 ))]} ))
            else
                echo "$student_id,$p" >> $WA_file
            fi
        done
    fi
    echo "$student_id,$score" >> $score_file
done
