#!/bin/bash

#check linux Gentoo os 
var=`lsb_release -a | grep Gentoo`
if [ -z "${var}" ]; then 
    var=`cat /etc/issue | grep Gentoo`
fi

if [ -d "/etc/runlevels/default" -a -n "${var}" ]; then
    LINUX_RELEASE="GENTOO"
else
    LINUX_RELEASE="OTHER"
fi

stop_aegis(){
    killall -9 aegis_cli >/dev/null 2>&1
    killall -9 aegis_update >/dev/null 2>&1
    killall -9 aegis_cli >/dev/null 2>&1
    killall -9 AliYunDun >/dev/null 2>&1
    killall -9 AliHids >/dev/null 2>&1
    killall -9 AliYunDunUpdate >/dev/null 2>&1
    printf "%-40s %40s\n" "Stopping aegis" "[  OK  ]"
}

stop_quartz(){
    killall -9 aegis_quartz >/dev/null 2>&1
    printf "%-40s %40s\n" "Stopping quartz" "[  OK  ]"
}

remove_aegis_quartz(){
if [ -d /usr/local/aegis ];then
    rm -rf /usr/local/aegis/aegis_client
    rm -rf /usr/local/aegis/aegis_update
    rm -rf /usr/local/aegis/alihids
    rm -rf /usr/local/aegis/aegis_quartz
fi
}

uninstall_service() {
    if [ -f "/etc/init.d/aegis" ]; then
        /etc/init.d/aegis stop  >/dev/null 2>&1
	rm -f /etc/init.d/aegis 
    fi
    if [ $LINUX_RELEASE = "GENTOO" ]; then
        rc-update del aegis default 2>/dev/null
	if [ -f "/etc/runlevels/default/aegis" ]; then
            rm -f "/etc/runlevels/default/aegis" >/dev/null 2>&1;
	fi
    elif [ -f /etc/init.d/aegis ]; then
        /etc/init.d/aegis  uninstall
	for ((var=2; var<=5; var++)) do
	    if [ -d "/etc/rc${var}.d/" ];then
	        rm -f "/etc/rc${var}.d/S80aegis"
            elif [ -d "/etc/rc.d/rc${var}.d" ];then
		rm -f "/etc/rc.d/rc${var}.d/S80aegis"
	    fi
	done
    fi
}

agentwatch=`ps aux | grep 'agentwatch'`
remove_agentwatch() {
    if [[ -n $agentwatch ]]; then
       systemctl stop agentwatch.service
	systemctl disable agentwatch.service
	find . -name 'agentwatch*' -type d -exec rm -rf {} \; && find . -name 'agentwatch*' -type f -exec rm -rf {} \;
    fi
}

aliyunsrv=`ps aux | grep 'aliyun'`
remove_all_aliyunfiles() {
    if [[ -n $aliyunsrv ]]; then
        systemctl stop accounts-daemon.service
        systemctl disable accounts-daemon.service
        systemctl stop aliyun-util.service
        systemctl disable aliyun-util.service
        systemctl stop cloud-config.service
        systemctl disable cloud-config.service
        systemctl stop cloud-final.service
        systemctl disable cloud-final.service
        systemctl stop cloud-init-local.service
        systemctl disable cloud-init-local.service
        systemctl stop cloud-init-upgrade.service
        systemctl disable cloud-init-upgrade.service
        systemctl stop cloud-init.service
        systemctl disable cloud-init.service
        rm -fr /usr/sbin/aliyun-service /usr/sbin/aliyun_installer
        rm /etc/systemd/system/aliyun-util.service
        rm -rf /etc/aliyun-util
        rm /lib/systemd/system/accounts-daemon.service
        rm /lib/systemd/system/cloud-final.service
        rm /lib/systemd/system/cloud-config.target
        rm /lib/systemd/system/cloud-init.service
        rm /lib/systemd/system/cloud-config.service
        rm /lib/systemd/system/cloud-init-upgrade.service
        rm /lib/systemd/system/cloud-init-local.service
        find . -name 'aliyun*' -type d -exec rm -rf {} \;
        find . -name 'aliyun*' -type f -exec rm -rf {} \;
        find . -name 'aegis*' -type f -exec rm -rf {} \;
        find . -name 'aegis*' -type d -exec rm -rf {} \;
        find /etc/systemd/system/ -name 'cloud-*' | xargs rm -rf       
    fi
}

query_ban=`iptables -L | grep -E '140.205|106.11|140.205'`
ban_server_guard() {
    if [[ ! -n $query_ban ]]; then
        iptables -I INPUT -s 182.92.157.118 -j DROP		
        iptables -I INPUT -s 182.92.69.212 -j DROP
        iptables -I INPUT -s 182.92.148.207 -j DROP
        iptables -I INPUT -s 182.92.1.233 -j DROP
        iptables -I INPUT -s 139.129.192.134 -j DROP
        iptables -I INPUT -s 139.129.192.106 -j DROP
        iptables -I INPUT -s 139.129.192.102 -j DROP
        iptables -I INPUT -s 139.129.99.92 -j DROP
        iptables -I INPUT -s 140.205.201.0/24 -j DROP
        iptables -I INPUT -s 140.205.201.0/28 -j DROP
        iptables -I INPUT -s 140.205.201.16/29 -j DROP
        iptables -I INPUT -s 140.205.201.32/28 -j DROP
        iptables -I INPUT -s 140.205.225.0/24 -j DROP
        iptables -I INPUT -s 140.205.225.192/29 -j DROP
        iptables -I INPUT -s 140.205.225.200/30 -j DROP
        iptables -I INPUT -s 140.205.225.184/29 -j DROP
        iptables -I INPUT -s 140.205.225.183/32 -j DROP
        iptables -I INPUT -s 140.205.225.206/32 -j DROP
        iptables -I INPUT -s 140.205.225.205/32 -j DROP
        iptables -I INPUT -s 140.205.225.195/32 -j DROP
        iptables -I INPUT -s 140.205.225.204/32 -j DROP
        iptables -I INPUT -s 123.57.10.133 -j DROP
        iptables -I INPUT -s 123.56.138.37 -j DROP
        iptables -I INPUT -s 121.43.107.176 -j DROP
        iptables -I INPUT -s 121.43.107.174 -j DROP
        iptables -I INPUT -s 121.42.196.232 -j DROP	
        iptables -I INPUT -s 121.42.0.0/24 -j DROP
        iptables -I INPUT -s 121.41.117.242 -j DROP
        iptables -I INPUT -s 121.41.112.148 -j DROP
        iptables -I INPUT -s 121.40.130.38 -j DROP
        iptables -I INPUT -s 121.0.30.0/24 -j DROP
        iptables -I INPUT -s 121.0.19.0/24 -j DROP
        iptables -I INPUT -s 120.27.163.18 -j DROP
        iptables -I INPUT -s 120.27.162.219 -j DROP
        iptables -I INPUT -s 120.27.162.171 -j DROP
        iptables -I INPUT -s 120.27.162.151 -j DROP
        iptables -I INPUT -s 120.27.47.144 -j DROP
        iptables -I INPUT -s 120.27.47.33 -j DROP
        iptables -I INPUT -s 120.27.40.113 -j DROP
        iptables -I INPUT -s 120.26.216.168 -j DROP
        iptables -I INPUT -s 120.26.64.126 -j DROP
        iptables -I INPUT -s 115.29.113.101 -j DROP
        iptables -I INPUT -s 115.29.112.222 -j DROP
        iptables -I INPUT -s 115.28.203.70 -j DROP
        iptables -I INPUT -s 115.28.189.208 -j DROP
        iptables -I INPUT -s 115.28.171.22 -j DROP
        iptables -I INPUT -s 115.28.26.13 -j DROP
        iptables -I INPUT -s 112.126.75.221 -j DROP	
        iptables -I INPUT -s 112.126.75.174 -j DROP
        iptables -I INPUT -s 112.126.74.55 -j DROP		
        iptables -I INPUT -s 112.126.73.56 -j DROP
        iptables -I INPUT -s 112.125.32.0/24 -j DROP
        iptables -I INPUT -s 112.124.127.224 -j DROP
        iptables -I INPUT -s 112.124.127.64 -j DROP
        iptables -I INPUT -s 112.124.127.53 -j DROP
        iptables -I INPUT -s 112.124.127.53 -j DROP
        iptables -I INPUT -s 112.124.127.44 -j DROP
        iptables -I INPUT -s 112.124.36.187/32 -j DROP
        iptables -I INPUT -s 110.75.0.0/16 -j DROP
        iptables -I INPUT -s 110.75.105.0/24 -j DROP
        iptables -I INPUT -s 110.75.105.0/24 -j DROP
        iptables -I INPUT -s 110.75.186.0/24 -j DROP
        iptables -I INPUT -s 110.75.185.0/24 -j DROP
        iptables -I INPUT -s 110.75.106.0/24 -j DROP
        iptables -I INPUT -s 106.11.224.0/26 -j DROP
        iptables -I INPUT -s 106.11.224.64/26 -j DROP
        iptables -I INPUT -s 106.11.224.128/26 -j DROP
        iptables -I INPUT -s 106.11.224.192/26 -j DROP
        iptables -I INPUT -s 106.11.222.64/26 -j DROP
        iptables -I INPUT -s 106.11.222.128/26 -j DROP
        iptables -I INPUT -s 106.11.222.192/26 -j DROP
        iptables -I INPUT -s 106.11.223.0/26 -j DROP
        iptables -I INPUT -s 101.201.220.123 -j DROP
        iptables -I INPUT -s 101.201.220.13 -j DROP
        iptables -I INPUT -s 101.201.220.98 -j DROP
        iptables -I INPUT -s 101.201.220.74 -j DROP
        iptables -I INPUT -s 42.156.250.0/24 -j DROP
        iptables -I INPUT -s 42.120.145.0/24 -j DROP
        iptables -I INPUT -s 42.120.142.0/24 -j DROP
        iptables -I INPUT -s 42.120.0.0/16 -j DROP
        iptables -I INPUT -s 42.96.189.63 -j DROP
        iptables -I INPUT -s 10.153.174.11 -j DROP
        iptables -I INPUT -s 10.153.175.147 -j DROP
        iptables -I INPUT -s 10.153.175.146 -j DROP
    fi
}

stop_aegis
umount /usr/local/aegis/aegis_debug
stop_quartz
uninstall_service
remove_aegis_quartz
remove_agentwatch
remove_all_aliyunfiles
ban_server_guard

printf "%-40s %40s\n" "Fuck AliYun's monitor done! "
