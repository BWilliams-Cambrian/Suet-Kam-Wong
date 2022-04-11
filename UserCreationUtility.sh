#!/bin/bash

#INPUT=EmployeeNames.csv
#[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }

#INPUT=EmployeeNames.csv

# Remove the heading and start the list from the Second row.
tail -n +2 EmployeeNames.csv > NewEmployeeNames.csv

# initial 2 variable to count the number of new user and new department is created.
newuser=0
newgroup=0

# looping each row in the file
for n in $(cat NewEmployeeNames.csv);
#echo $"{INPUT}" | tail -n +2 | awk -F',' '{print tolower(substr($1,1,1) tolower(substr($2,1,7))), $3}' | while read -r username department
#list=$(cat EmployeeNames.csv)
#echo "${list}" | tail -n +2 | awk -F',' '{print tolower(substr($1,1,1) tolower(substr($2,1,7))), $3}' | while read -r username department


do

#define the username is the 1st character of the first name and first 7 character of the last name.
username=$(echo $n | awk -F',' '{print tolower(substr($1,1,1)) tolower(substr($2,1,7))}')
#extract the department 
department=$(echo $n | awk -F',' '{print substr($3,1)}')
department=${department//[^[:alpha:]]}



#check if the username: exist 
if getent passwd $username > /dev/null; then

# if the username exist, then display:
	echo "The user: $username exists"
	echo "-----------------------------------------"
# otherwise, create the user as username and the number of new user plus 1.
else
	echo "The user $username does not exist and..."
	sudo useradd $username
	newuser=$((newuser+1))
	echo "Username: $username is created."

#afterthat, check the department if exists
	if [ $(getent group $department) ]; then

# if the dept exists, then display below sentence and add the new user into the dept.
		echo "Group: $department exists"
		sudo usermod -g $department $username
		echo "$username is added into group $department"
		echo "-----------------------------------------"
# otherwise, create a group and then add the new user into the new group.
# and the number of new group plus 1.
	else
		echo "Group $department does not exist, and..."
		sudo groupadd $department
		newgroup=$((newgroup+1))
		sudo usermod -g $department $username
		echo "A new dept: $department is created"
		echo "$username  is added into group $department"
		echo "----------------------------------------"
	fi
fi
done

# display the number of new user and new group is created.
echo "Created newuser: $newuser"
echo "Created new department :$newgroup"
echo "This program is finished."
