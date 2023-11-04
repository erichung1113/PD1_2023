#! /bin/bash

# Configuration
HW=6
# -------------

if test -d ~/Homework; then rm -r ~/Homework; fi 
mkdir ~/Homework

score_file=~/Homework/HW${HW}_Score
echo "id,score" > $score_file

students_id=$(cat ~/students_id.txt)
if (( $# != 0 )); then students_id=$@; fi

for student_id in $students_id; do
    mkdir ~/Homework/$student_id
    cp ~/Submission_BackUp/$student_id/HW${HW}/hw${HW}.c ~/Homework/$student_id
    # echo "hw$HW -p ~/Homework/$student_id"
    hw$HW -p ~/Homework/$student_id > /dev/null 2>&1
	score=$?
    echo "$student_id, $score" >> $score_file
    echo "$student_id, $score"
done

if (( $# == 0 )); then ~/Moss/moss.sh; fi
