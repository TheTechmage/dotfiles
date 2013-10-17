#! /bin/bash
firstxserver=$1
secondxserver=$2
#set the variables to the default
echo . | xsel --display $firstxserver -b -i 
echo . | xsel --display $secondxserver -b -i
clipboard=.

while [ 1 ]
do
#get the values of the clipboard
firstdislpayclipboard=$(xsel --display $firstxserver -b -o)
seconddislpayclipboard=$(xsel --display $secondxserver -b -o)

#if the first x servers clipboad chages
if [ "$firstdislpayclipboard" != "$clipboard" ]
then

#if it doesnt change to be blank
if [ $(echo $firstdislpayclipboard | grep ^$ -c) -ne 1 ]
then
#set the appropriate variables to be the contents of the first comand
seconddislpayclipboard=$firstdislpayclipboard
clipboard=$firstdislpayclipboard
xsel --display $firstxserver -b -o | xsel --display $secondxserver -b -i
else
#if it is blank set it to be .in case if its because the x server went down
echo . | xsel --display $firstxserver -b -i 
fi

fi

#if the second x servers clipboad chages
if [ "$seconddislpayclipboard" != "$clipboard" ]
then

#if it doesnt change to be blank
if [ $(echo $seconddislpayclipboard | grep ^$ -c) -ne 1 ]
then
#set the appropriate variables to be the contents of the first comand
firstdislpayclipboard=$seconddislpayclipboard
clipboard=$seconddislpayclipboard
xsel --display $secondxserver -b -o | xsel --display $firstxserver -b -i
else
#if it is blank set it to be .in case if its because the x server went down
echo . | xsel --display $secondxserver -b -i 
fi

fi

sleep 1
done
