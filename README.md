**Remember to change the configuration at the top of the code.**

# validator.sh
You can place `validator.sh` script in `/usr/local/bin` and named it `hw2`, so that other user can easily use.\
User's code must be placed at `~/HW2/pA.c`, `~/HW3/pB.c`, etc.
## usage:
Test all problems
```
hw2
```
Test specific problem
```
hw2 A
```

# score.sh
Calculate the score of students' code

## usage:
Test all users in ~/students_id.txt
```
./score.sh
```
Test specific user
```
./score.sh F12345678
```
this script will create files : `HW2_score.txt` and `HW2_wa.txt`.\
You can upload `HW2_score.txt` to Moodle directly.
