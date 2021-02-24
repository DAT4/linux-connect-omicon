PORT=1111
NAME=dtu
HOST=localhost
whiptail --title "SHH Configuration for Omicon through Thinlinc" --msgbox "This script will help you to set up with Omicon and thinlinc over ssh" 8 78

ID=$(whiptail --inputbox "What is your student number?" 8 39 Blue --title "Example Dialog" 3>&1 1>&2 2>&3)
exitstatus=$?
if [ $exitstatus != 0 ]; then
    TERM=ansi whiptail --title "Error" --infobox "There was an error" 8 78
    exit
fi

#REGEX_ID='^s\d{6}$'
REGEX_ID='martin'
echo "$ID" | grep -P -q $REGEX_ID
exitstatus=$?
if [ $exitstatus != 0 ]; then
    TERM=ansi whiptail --title "Error" --infobox "You didnt write a studen number!" 8 78
    exit
fi

#####
# MAKE THE KEYFILE AND SETUP CONFIG FILE
#####
ssh-keygen -f ~/.ssh/$NAME -t rsa -N '' -b 2048
clear

echo "███████ ███████ ██   ██     ██       ██████   ██████  ██ ███    ██" 
echo "██      ██      ██   ██     ██      ██    ██ ██       ██ ████   ██"
echo "███████ ███████ ███████     ██      ██    ██ ██   ███ ██ ██ ██  ██"
echo "     ██      ██ ██   ██     ██      ██    ██ ██    ██ ██ ██  ██ ██"
echo "███████ ███████ ██   ██     ███████  ██████   ██████  ██ ██   ████"

ssh-copy-id -o "StrictHostKeyChecking no" -i ~/.ssh/$NAME.pub $ID@$HOST

echo "
Host $NAME
    HostName $HOST
    User $ID
    Port 22
    LocalForward $PORT localhost:$PORT
    ControlMaster yes
    ControlPath ~/.ssh/sockets/%r@%h:%p
    IdentityFile ~/.ssh/$NAME

" >> ~/.ssh/config

ssh $NAME "ssh-keygen -f ~/.ssh/nana -t rsa -N '' -b 2048; exit"
ssh $NAME "
echo \"INSTALLING THE OMICON\"
echo \"
Host omicon
    HostName 130.226.195.126
    User passthru
    Port 22
    IdentityFile ~/.ssh/$NAME
    LocalForward $PORT 192.168.149.44:9869
    ControlMaster yes
    ControlPath ~/.ssh/sockets/%r@%h:%p
\" >> ~/.ssh/config
"
scp $NAME:.ssh/$NAME.pub .
KEY=$( cat $NAME.pub )

echo "
######################################################
# COPY THIS KEY AND SEND IT TO BHUPJIT
######################################################

$KEY

######################################################"

#TODO GO and clean duplicates in ~/.ssh/config
