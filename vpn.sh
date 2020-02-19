

if [ "$1" == "start" ]
then
    echo "Starting openvpn, output sent tu /tmp/openvpn.log ..."
    sudo -b -E openvpn --config /u/ta/etc/aviatrix-nonprod.ovpn >/tmp/openvpn.log 2>&1
elif [ "$1" == "stop" ]
then
    sudo killall openvpn
elif [ "$1" == "status" ]
then
    if [ $(ps -C openvpn | wc -w) -gt 5 ]
    then
       echo "Open-VPN is running"
    else
       echo "Open-VPN is down"
    fi
else
    echo "Please specify command start/stop/status"
fi
