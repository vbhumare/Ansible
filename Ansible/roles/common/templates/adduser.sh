#!/bin/bash

if [ $(id -u) -eq 0 ]; then

        egrep "^{{ username }}" /etc/passwd >/dev/null
        if [ $? -eq 0 ]; then
                printf "=========================\n"
                echo "{{ username }} is already exists!"
                exit 1
        else
                pass=$(perl -e 'print crypt($ARGV[0], "password")' {{password}})
                useradd -m -p $pass -s /bin/bash {{ username }}
                sed -i "/AllowUsers/ s/$/ {{ username }}/" /etc/ssh/sshd_config
                /etc/init.d/sshd reload
                [ $? -eq 0 ] && echo "User has been added to system!" || echo "Failed to add a user!"
        fi
else
        echo "Only root can add a user to the system"
        exit 2
fi

