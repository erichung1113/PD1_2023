HW=5

mkdir ~/Moss/Submissions
for i in $(cat ~/students_id.txt); do
    cp ~/Homework/$i/hw$HW.c ~/Moss/Submissions/$i.c
done
python3 ~/Moss/moss.py >> ~/Moss/plagiarism_result
rm -r ~/Moss/Submissions
