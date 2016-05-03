#!/bin/bash

pastd=`date -u +%Y/%m/%d -d "1 day ago"`
outputd=`date -u +%Y%m%d -d "1 day ago"`

python readf.py abuse.ch_Zeus_IP.txt > zeus_ips.txt
cat ThreatStream-IP-Attack.csv | awk -F "," '{print $(NF-1)}' | sort | uniq > attack_ips.txt
cat ThreatStream-IP-Bot.csv | awk -F "," '{print $(NF-1)}' | sort | uniq > bot_ips.txt
cat ThreatStream-IP-Suspicious.csv | awk -F "," '{print $(NF-1)}' | sort | uniq | grep -v "^192.168" | grep -v "1.1.1.1" | grep -v "8.8.8.8" > suspicious_ips.txt
#cat ThreatStream-URL-Malware.csv | awk -F "," '{print $(NF-1)}' | sort | uniq > malware_ips.txt

rm *.set

/usr/local/bin/rwsetbuild zeus_ips.txt zeus_ips.set
/usr/local/bin/rwsetbuild attack_ips.txt attack_ips.set
/usr/local/bin/rwsetbuild bot_ips.txt bot_ips.set
/usr/local/bin/rwsetbuild suspicious_ips.txt suspicious_ips.set


/usr/local/bin/rwfilter --start-date=$pastd --type=out,outweb --dipset=zeus_ips.set --pass=stdout | /usr/local/bin/rwcut > $HOME/blacklists/blacklist_logs/${outputd}_zeus_results.txt
/usr/local/bin/rwfilter --start-date=$pastd --type=out,outweb --dipset=bot_ips.set --pass=stdout | /usr/local/bin/rwcut > $HOME/blacklists/blacklist_logs/${outputd}_bot_results.txt
/usr/local/bin/rwfilter --start-date=$pastd --type=in,inweb --sipset=attack_ips.set --pass=stdout | /usr/local/bin/rwcut > $HOME/blacklists/blacklist_logs/${outputd}_attack_results.txt
/usr/local/bin/rwfilter --start-date=$pastd --type=out,outweb --dipset=suspicious_ips.set --pass=stdout | /usr/local/bin/rwcut > $HOME/blacklists/blacklist_logs/${outputd}_suspicious_results.txt
