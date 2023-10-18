#! /bin/bash

# Configuration
HW=3
ProblemID="A B C D"
Score=(20 20 20 40)
# -------------

if test -d testcase ; then rm -r testcase; fi 
mkdir testcase
cp -r /share/HW${HW}_TestCase/* testcase

score_file="HW${HW}_SCORE.txt"
WA_file="HW${HW}_wa.txt"

students_id=$(cat ~/students_id.txt)
if (( $# != 0 )); then students_id=$@; fi

echo "id,score" > $score_file
echo "id,score" > $WA_file

for student_id in $students_id; do
    echo -n $student_id
    score=0
    if test -d $student_id/HW$HW ; then
        for p in $ProblemID; do
            hw$HW -p $(pwd)/$student_id/HW$HW $p > /dev/null 2>&1
            if (( $? == 1 )); then
                (( score += ${Score[(( $(printf "%d" "'$p") - 65 ))]} ))
            	echo -n ", p$p:${Score[(( $(printf "%d" "'$p") - 65 ))]}" 
            else
                echo "$student_id,$p" >> $WA_file
            	echo -n ", p$p: 0"
            fi
        done
    fi
    echo ", total:$score"
    echo "$student_id,$score" >> $score_file
done
