PORTS=$(ss -tulpn |grep ssh|grep 127.0.0.1|awk '{print $5}'|cut -d : -f 2)

if [ ! "$PORTS" ];then
    ssh -fN
else
    if (whiptail --title "Close all connections" --yesno "Do you want to close all the ssh connections at once?" 8 78); then
        echo "██████  ███████ ███████ ████████  █████  ██████  ████████     ███████ ███████ ██   ██" 
        echo "██   ██ ██      ██         ██    ██   ██ ██   ██    ██        ██      ██      ██   ██" 
        echo "██████  █████   ███████    ██    ███████ ██████     ██        ███████ ███████ ███████" 
        echo "██   ██ ██           ██    ██    ██   ██ ██   ██    ██             ██      ██ ██   ██" 
        echo "██   ██ ███████ ███████    ██    ██   ██ ██   ██    ██        ███████ ███████ ██   ██" 
        sudo pkill ssh
    else
        for PORT in $PORTS
        do
            if (whiptail --title "Connection" --yesno "Do you wanna close ssh connection on port $PORT" 8 78); then
                echo "User selected Yes, exit status was $?."
            fi
        done
    fi
fi


