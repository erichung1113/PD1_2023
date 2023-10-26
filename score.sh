#! /bin/bash

# Configuration
HW=5
# -------------

mkdir /home/cial1/Homework
score_file="/home/cial1/Homework/HW${HW}_Score.txt"
students_id=$(cat /home/cial1/students_id.txt)
if (( $# != 0 )); then students_id=$@; fi
echo "id,score" > $score_file

Pass=0
All=0
for student_id in $students_id; do
    mkdir /home/cial1/Homework/$student_id
    cp -r /home/cial1/Submission_BackUp/$(date '+%Y.%m.%d')/$student_id/HW${HW} /home/cial1/Homework/$student_id
    hw$HW -p /home/cial1/Homework/$student_id/HW$HW > /dev/null 2>&1
    score=$?
    if (( $score == 100 )); then
        (( Pass++ ))
    fi
    echo "$student_id, $score" >> $score_file
    echo "$student_id, $score"
    (( All++ ))
done
echo "Pass rate : $(echo -e "scale=2; $Pass/$All*100" | bc)%"
