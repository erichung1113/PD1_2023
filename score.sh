#! /bin/bash

# Configuration
HW=5
# -------------

score_file="HW${HW}_Score.txt"

students_id=$(cat ~/students_id.txt)
if (( $# != 0 )); then students_id=$@; fi

echo "id,score" > $score_file

Pass=0
All=0
for student_id in $students_id; do
    hw$HW -p $(pwd)/$student_id/HW$HW > /dev/null 2>&1
    score=$?
    if (( $score == 100 )); then
        (( Pass++ ))
    fi
    echo "$student_id,$score" >> $score_file
    echo "$student_id,$score"
    (( All++ ))
done
echo -n "Pass Rate : $(echo -e "scale=2; $Pass/$All*100" | bc)%"
