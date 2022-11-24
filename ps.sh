#!/bin/bash
if [ -e .tmp ]
then
    cat /dev/null > tmp
else
    mkdir .tmp
    touch .tmp/tmp
fi
cd /proc
echo "Pid|Name|User|Ppid|State|RSS|VSZ|TTY|%CPU|%MEM|Files" >> ~/projects/scripts/.tmp/tmp
#echo "------------------------------------------------------------------------------------------------" >> ~/projects/scripts/.tmp/tmp
for FILE in $(ls | grep '[0-9]')
do

if [ -e $FILE ]
then

    cd  $FILE
    ua=()
    arr=()
    time=()
    ram=()
    hertz=$(getconf CLK_TCK)
    if [ -e /proc/$FILE/status ]
    then
        read -a ua <<< $(cat /proc/$FILE/status | grep Uid)
    fi
    read -a arr <<<$(cat stat)
    read -a time <<< $(cat /proc/uptime)
    read -a ram <<< $(cat /proc/meminfo | grep MemTotal)
    mem=$(echo "scale=1; (4.096*100*${arr[23]})/${ram[1]}" | bc)
    uptime=${time[0]::-3}
    sec=$(echo "$uptime - (${arr[21]}/$hertz)" | bc)
    procTotTime=$(echo "${arr[13]}+${arr[14]}+${arr[15]}+${arr[16]}" | bc)
    uid=$(echo "${ua[1]}")
    rss=$(echo "scale=0; ${arr[23]} * 4.096" | bc)
    vsz=$(echo "scale=0; (${arr[22]})/1024" | bc)
    cpu=$(echo "scale=1; (((100* $procTotTime)/$hertz)/$sec)" | bc)
    files=$(for a in $(ls -l /proc/$FILE/fd 2>/dev/null | grep -v total);
    do
        echo "${a##*-> }";
    done)
    i=0
    for f in $files
    do
    let i++
    done

    #saveIFS=$IFS
    #IFS=$'\n'
    user=$(id -nu $uid)
    echo "${arr[0]}" "|"   "${arr[1]}" "|" "$user" "|" "${arr[3]}" "|" "${arr[2]}" "|" "$rss" "|" "$vsz" "|" "${arr[6]}" "|" "$cpu" "|" "$mem" "|" "$i" >> ~/projects/scripts/.tmp/tmp
    
    #echo "${ua[*]}"
    #unset arr
    #echo $FILE
    cd ..

fi
done
column -t -s "|" ~/projects/scripts/.tmp/tmp
rm -r ~/projects/scripts/.tmp