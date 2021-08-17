#Catch input
rm -rf /home/calinux/Desktop/dhcp_logs.txt
date
now=$(date)
echo "                           [DHCP Registration Script v0.1]                                  "
echo "[- If using different criteria for available IPs, please replace #OPEN in the source code  ]"
echo "[- Please make sure that criterias for open IPs are matched to errors during operation     ]"
echo "Enter dhcp name ( no spaces ):"
read dhcpname
echo "Enter mac address: ( correct format no spaces ):"
read macaddress
 
#checks for available IP and provides line
linenum=$(grep -n '#OPEN' hosts | gawk '{print $1}' FS=":" | head -1)

#get ip from that available IP 
getip=$(sed -n ${linenum}p hosts | awk -F '   '  '{print $1}')
#get line from ethers that matches the available IP from hosts 
linenumeth=$(grep -n ${getip} ethers | gawk '{print $1}' FS=":" | head -1)

#capture dhcp and mac name into variables
dhcp=$dhcpname
mac=$macaddress

#check if the are available IP in hosts file then modify and display results
if [[ $linenum -ge  1 ]] 
then 
    sed -i "${linenum}s/#OPEN/${dhcp}/" hosts
    sed -i "${linenumeth}s/#OPEN/${mac}/" ethers
    lineresult=$(sed -n ${linenum}p hosts)
    ethresult=$(sed -n ${linenumeth}p ethers)
    echo $lineresult "-" $now "-\n" $ethresult >>  dhcp_logs
   echo "--------------------------------------------------" 
   echo "|Successfully registered IP:                     |"
   echo "--------------------------------------------------"
#display results for host and ethers ( check if matches )    
    echo $lineresult
    echo "-------------------------------------------------"
    echo $ethresult
    echo "-------------------------------------------------"
    echo "Please restart dnsmasq"
else
    echo "--------------------------------------------------"
    echo "|No available IPs found, please check /etc/hosts |"
    echo "--------------------------------------------------"
fi
