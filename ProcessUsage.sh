 #!/bin/bash
#brief the user which top 5 processes are currently running   
echo "Below are top 5 processes currently running on the system (By CPU%)"
#list out the top 5 processes with the PID, Username, PPID, CMD, started tiem, % of memory and CPU, 
#then sort by % of CPU,store the details as variable "list" 
#and display the first 6 rows which including header
list=$(ps -eo pid,user,ppid,cmd,start_time,%mem,%cpu --sort=-%cpu | head -n 6)
#display the "list" and a separate line
echo "${list}"
echo "=========================================="

#initialize 2 variables for the main loop for counting purpose.
deletedprocess=0
rootprocess=0

#asking user whether to kill the process 
echo "Do you want to kill all the process except root? (Yes/No) "
#read the ans 
read ans

# using case loop for the input
case $ans in

# in case the ans is "Yes", start to kill the process except belonging to root
    Yes)
        # initialize variable for counting purpose
        deletedprocess=0
        rootprocess=0
        row=0
        # by using the stored "list", cut the header and store PID, username and Start time 
        echo "${list}" | head -n 6 | grep -v "PID" | awk -F' ' '{print $1,$2,$5}' | while read -r PID USER START_TIME
        # start the while loop
        do
                #if the user is root, display the process cannot be killed.
                if [ "${USER}" == "root" ]; then
                        echo "Cannot kill process ${PID} since it is belonging to root."
                        rootprocess=$((rootprocess+1))
                        # counting the number of row currently running
                        row=$((row+1))
                # else, which mean the user is not root
                else    
                        # then kill the process by using PID
                        kill -SIGKILL ${PID}
                        # display the PID and the cooresponding the username of who started the process.
                        echo "${PID} is killed"
                        echo "The username of started the process: ${USER}"
                        # store and output the start time 
                        start=$(ps -p ${PID} -o lstart | tail -1)
                        echo "Start time: ${start} "
                        # display the end time (current time)
                        endtime=$(date +"%T")
                        echo "Killed Time: $endtime"
                        # display the usergroup
                        usergp=$(id ${USER} | awk -F'groups=' '{print $2}')
                        echo "usergroup: ${usergp}"
                        # display a separete line for easy reading
                        echo "-----------------------------"
                        # counting the deleted processes
                        deletedprocess=$((deletedprocess+1))
                        # counting the number of row currently running
                        row=$((row+1))
                # end the if loop
                fi
        # if currently running the last row (the 5th row)
        # then output the conclusion of the deleted file
        if [ $row == 5 ]
        then
        echo "Total deleted $deletedprocess of processes"
        echo "No. of root: $rootprocess have not been killed"
        fi

        # end the while loop and output the log file with current date.
        done > "ProcessUsageReport - $(date +"%Y%m%d")"
        # display the conclusion before exit program
        tail -2 "ProcessUsageReport - $(date +"%Y%m%d")"
	;;
    # in case the ans is "No", display a reminder and exit script
    No)
        echo "exit script"
        exit 1
        ;;
    # in case the ans except "Yes" or "No", show that an invalid entry is input.
    *)
        echo "invalid entry."
        ;;
# end the while loop
esac

