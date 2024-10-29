#! /bin/bash
# HW=$(ls /usr/local/bin | grep -oP '^hw\K[0-9]+' | sort -n | tail -1)
HW=3

students_id=$(cat /home/cial1/all_students_id.txt)

# -------------backup-------------
if [[ $(whoami) == "root" ]]; then

    if test -d /home/cial1/Submission_BackUp; then rm -r /home/cial1/Submission_BackUp; fi
    mkdir /home/cial1/Submission_BackUp

    for student_id in $students_id; do
        if test -d /home/$student_id/HW$HW; then
            echo "copying $student_id"

            BackUpFolder=/home/cial1/Submission_BackUp/$student_id

            mkdir $BackUpFolder
            cp -r /home/$student_id/HW$HW $BackUpFolder;
        fi
    done

    chown -R cial1:cial1 /home/cial1/Submission_BackUp
    echo -e "\n-finished backup-\n"
fi

# -------------calculate score-------------

if test -d /home/cial1/Judge; then rm -rf /home/cial1/Judge; fi
mkdir /home/cial1/Judge

score_file=/home/cial1/HW${HW}_Score.csv
echo "student_id, score" > $score_file

if (( $# != 0 )); then students_id=$@; fi
for student_id in $students_id; do
    score=0

    StudentFolder="/home/cial1/Submission_BackUp/$student_id/HW${HW}"

    if [[ -d ${StudentFolder} && $(find "$StudentFolder" -type f | wc -l) -gt 0 ]]; then
        JudgeFolder="/home/cial1/Judge/$student_id"
        mkdir $JudgeFolder
        cd $JudgeFolder

        cp -r $StudentFolder/* $JudgeFolder
        hw$HW -p $JudgeFolder > /dev/null 2>&1
        score=$?
        echo "$student_id, $score"
    fi
    echo "$student_id, $score" >> $score_file
done

chown -R cial1:cial1 /home/cial1/Judge
chown cial1:cial1 /home/cial1/$score_file
echo -e "\nfinished judge\n"

# if (( $# == 0 )); then /home/cial1/Moss/moss.sh; fi
