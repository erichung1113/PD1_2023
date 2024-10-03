HW=$(ls /usr/local/bin | grep -oP '^hw\K[0-9]+' | sort -n | tail -1)

function upload_to_Moss {
	if test -d /home/cial1/Moss/Submissions; then rm -r /home/cial1/Moss/Submissions; fi
	mkdir /home/cial1/Moss/Submissions

	for id in $(cat /home/cial1/all_students_id.txt); do
		for FILE in $@; do
			if test -f /home/cial1/Submission_BackUp/${id}/HW${HW}/${FILE}; then
				cp /home/cial1/Submission_BackUp/${id}/HW${HW}/${FILE} /home/cial1/Moss/Submissions/${id}_${FILE}
			fi
		done
	done
	echo "uploading $@ to Moss...."
	result=$(python3 /home/cial1/Moss/moss.py)
	echo $result
	echo $result >> /home/cial1/Moss/plagiarism_result
}

# change here
upload_to_Moss "pA.c"
upload_to_Moss "pB.c"
upload_to_Moss "pC.c"
upload_to_Moss "pD.c"
upload_to_Moss "pE.c"