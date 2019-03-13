echo "Starting Arch Config...."
sleep 3

#### Initial Commands ####
ping -p -c5 www.google.com
if {$OUT -eq 0}
    then continue
    else
        echo "Unable to detect network connection."
        stop
fi

timedatectl set-ntp true
#### End Initial Commands ####
