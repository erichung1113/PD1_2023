HW=11
BackUpDir=/home/cial1/Submission_BackUp

if test -d $BackUpDir; then rm -r $BackUpDir; fi
mkdir $BackUpDir

for id in $(cat /home/cial1/all_students_id.txt); do
	if test -d /home/$id/HW$HW; then 
		echo "copying $id" 
		mkdir $BackUpDir/$id
		cp -r /home/$id/HW$HW $BackUpDir/$id;
	fi
done

chown -R cial1:cial1 $BackUpDir
