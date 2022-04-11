#!/bin/bash

#initiate a variable "number" to count the number of folders are created in this script
number=0


# create a brand new folder structure under "/EmplpoyeeData"
sudo mkdir /EmployeeData

# for each of specific departments:
for department in HR IT Finance Executive Administrative CallCentre;

	do
	#echo $department
	# make a directory under the /EmployeeData with department name
	sudo mkdir /EmployeeData/$department

	# display a message that a directory is created
	echo newdirectory: $department is created

	# counting the number of directories 
	number=$((number+1))	

	# set the premission of each folder as: 
	# user have full permissions (rwx)
	# group have read and write permissions
	# other have read permissions
	sudo chmod -R 764 /EmployeeData/$department
	
	# assign the group as the owner
	sudo chgrp $department /EmployeeData/$department
	
	# complete the for-loop
	done
	
# for sensitive directories (HR and Administrative department), other have not any permissions to their directories.
for department in HR Administrative;
	do
	
	#sudo chgrp $department /EmployeeData/$depmartment
	#assign other have 0 permission (cannot read, write or executive)
	sudo chmod -R 760  /EmployeeData/$department
	#complete this for-loop
	done

#final message that show the numbers of folders are created.	
echo $number new folders is created
