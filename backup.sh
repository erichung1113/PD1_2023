mkdir /home/cial1/Submission_BackUp/$(date '+%Y.%m.%d')
for i in $(cat /home/cial1/students_id.txt); do
	cp -r /home/$i /home/cial1/Submission_BackUp/$(date '+%Y.%m.%d');
done

chown -R cial1:cial1 /home/cial1/Submission_BackUp/$(date '+%Y.%m.%d')
/home/cial1/score.sh
