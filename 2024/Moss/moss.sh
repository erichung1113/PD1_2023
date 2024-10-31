HW=$(ls /usr/local/bin | grep -oP '^hw\K[0-9]+' | sort -n | tail -1)

function upload_to_Moss {
    FILE=$1

	File_Dir=$Submission_Dir/$FILE
	if test -d $File_Dir; then rm -r $File_Dir; fi
	mkdir $File_Dir

	for id in $(cat /home/cial1/all_students_id.txt); do
		if test -f /home/cial1/Submission_BackUp/${id}/HW${HW}/$FILE.c; then
			cp /home/cial1/Submission_BackUp/${id}/HW${HW}/$FILE.c $File_Dir/${id}.c
		fi
	done
}

Submission_Dir=/home/cial1/Moss/Submissions
if test -d $Submission_Dir; then rm -r $Submission_Dir; fi
mkdir $Submission_Dir

problem=$(ls /share/HW${HW}_TC)
for p in $problem; do
	upload_to_Moss $p
done

cd /home/cial1/Moss
result=$(python3 /home/cial1/Moss/moss.py $problem)
echo $result
echo $result >> /home/cial1/Moss/plagiarism_result
