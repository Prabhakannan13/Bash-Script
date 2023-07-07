#!/usr/bin/env bash
printf "\n"
echo $(date +"%D")
printf "\n\t\t     =========================\n"
printf "\t\t\tSYSTEM INFORMATION"
printf "\n\t\t     =========================\n"

totalMemory=$(free -m | awk '/Mem/ {print $2}')
memUsage=$(free -m | awk '/Mem/ {print $3}')
percentageMemory=$(awk "BEGIN {printf \"%.2f\", ${memUsage}/${totalMemory} * 100}")

cpuUsage=$(top -bn1 | awk '/Cpu/ { print $4}')

totalDisk=$(df -h | awk '/\/$/ { print $2}')
diskUsage=$(df -h | awk '/\/$/ { print $3}')
percentageDisk=$(df -h | awk '/\/$/ {print $5}')
printf "\n"

osType=$(uname -s)
cpuCapacity=$(lscpu | awk '/^CPU\(s\)/ {print $2}')
memoryCapacity=$(free -h | awk '/^Mem:/ {print $2}')
diskCapacity=$(df -h / | awk 'NR==2 {print $2}')

loadAverage=$(uptime | awk -F 'load average:' '{print $2}' | awk -F ',' '{print $1}')


printf "\tMEMORY USAGE (Absolute Value):\t%s MB\n" "$memUsage"
printf "\tMEMORY USAGE IN PERCENTAGE     :\t%s%%\n" "$percentageMemory"
 
printf "\tCPU USAGE (Percentage):\t%s%%\n" "$cpuUsage"
printf "\tCPU LOAD Average:\t%s\n" "$loadAverage"

printf "\tDISK USAGE:\t%s\n" "$diskUsage"
printf "\tDISK USAGE IN PERCENTAGE     :  %s\n" "$percentageDisk"
printf "\n"

#Network Traffic
interfaces=$(ls /sys/class/net)


for interface in $interfaces; do

  incoming=$(cat /sys/class/net/$interface/statistics/rx_bytes)

  outgoing=$(cat /sys/class/net/$interface/statistics/tx_bytes)

  echo "Interface: $interface"

  echo "Incoming: $incoming"

  echo "Outgoing: $outgoing"
  printf "\n"

done

calculate_average() {
  sum=0
  count=0
  for value in "$@"; do
    sum=$(bc <<< "$sum + $value")
    count=$((count + 1))
  done
  average=$(bc <<< "scale=2; $sum / $count")
  echo "$average"
}

averageCpuUsage=$(calculate_average "${cpuUsage[@]}")
averageMemoryUsage=$(calculate_average "${memUsage[@]}")
averageDiskUsage=$(calculate_average "${diskUsage[@]}")
printf "\n"

echo "      ========================="
echo "          Summary Report"
echo "      ========================="
printf "\n"
echo "Operating System: $osType"
echo "CPU Capacity: $cpuCapacity"
echo "Memory Capacity: $memoryCapacity"
echo "Disk Capacity: $diskCapacity"
echo "Average CPU Usage: $averageCpuUsage"
echo "Average Memory Usage: $averageMemoryUsage"
echo "Average Disk Usage: $averageDiskUsage"