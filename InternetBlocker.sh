#!/bin/bash

#initiate a variable to count the number of staff have granted internet access.
ITstaff=0

# name 2 variables in "list" as username and group
while read username group
do
       # if the user group is 1021, which is under "IT", then
       	if [ "${group}" == '1021' ];
        then
                # increment the number of IT staff
		ITstaff=$((ITstaff+1))
                # allow this IT staff to accept incoming HTTPS packets 
                sudo iptables -A OUTPUT -p tcp --dport 443 -m owner --uid-owner $username -j ACCEPT
		
		# and also accept the local web server 
		sudo iptables -A OUTPUT -p tcp --dport 443 -d 192.168.2.3 -j ACCEPT
        # finish the if loop
	fi

# finish the while loop 
# the "list" is cat-ed out from /etc/passwd and extract the first and fourth column  
done <<< $(cat /etc/passwd | awk -F':' '{print $1, $4}')

# add new rules to drop all HTTP and HTTPS traffic  
sudo iptables -t filter -A OUTPUT -p tcp --dport 80 -j DROP
sudo iptables -t filter -A OUTPUT -p tcp --dport 443 -j DROP

# print out the finish message 
echo "Internet access is blocked from all user except IT staff."
echo "Total $ITstaff IT staff have granted internet access"
echo "This program is finished."
