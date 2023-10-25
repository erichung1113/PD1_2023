#! /bin/bash

# Configuration
HW=5
# -------------

score_file="HW${HW}_Score.txt"
echo "id,score" > $score_file

students_id=$(cat ~/students_id.txt)
if (( $# != 0 )); then students_id=$@; fi

for student_id in $students_id; do
    hw$HW -p $(pwd)/$student_id/HW$HW > /dev/null 2>&1
    score=$?
    echo "$student_id,$score" >> $score_file
    echo "$student_id,$score"
done
