#! /bin/sh

while getopts n:p:t:i: option
do
    case "$option" in
        n) echo "Name=$OPTARG";;
        p) echo "Port=$OPTARG";;
        t) echo "Protocol=$OPTARG";;
        i) echo "IP=$OPTARG";;
    esac
done
echo "----------------------------"
echo "Env:"
env