#!/bin/sh
#stamp=`date +%s`
stamp="out"
namebase="last20"
namefull="${namebase}-${stamp}.json"
#sender_id="73205709" #Einhorn
#sender_id="47126376"
#last_einhorn_mes_id="161376602848318931"
last_einhorn_mes_id=`cat /Users/george.owen/src/GroupMe/Last20/latestID.txt`
urlbase='https://api.groupme.com/v3/groups/32841593/messages?token=5u7VXqv9CBploHRLSoasGFAUyAsUWfhHBWH2zZBd&limit=100&after_id='
urlmessid="${last_einhorn_mes_id}"
url="${urlbase}${urlmessid}"

#Test if var is null
#if [ -z "last_einhorn_mes_id" ]; then
#else;
#fi;

#curl --location --request GET "https://api.groupme.com/v3/groups/32841593/messages?token=5u7VXqv9CBploHRLSoasGFAUyAsUWfhHBWH2zZBd&limit=100&after_id=161376602848318931" >> /Users/george.owen/src/GroupMe/Last20/$namefull;
curl --location --request GET "${url}" > /Users/george.owen/src/GroupMe/Last20/$namefull; 
	

#formats output for jq parsing
sed -ig 's/"response":{//g' /Users/george.owen/src/GroupMe/Last20/$namefull
sed -ig 's/"count":[0-9][0-9][0-9][0-9][0-9][0-9],//g' /Users/george.owen/src/GroupMe/Last20/$namefull
sed -ig 's/},"meta":{"code":200}//g' /Users/george.owen/src/GroupMe/Last20/$namefull
rm /Users/george.owen/src/GroupMe/Last20/*.jsong

#output einhorn message text in last n messages
cat /Users/george.owen/src/GroupMe/Last20/$namefull | jq --unbuffered '.messages[] | select(.sender_id == "73205709") | .text' | tee /Users/george.owen/src/GroupMe/Last20/jqout.text.txt
cat /Users/george.owen/src/GroupMe/Last20/$namefull | jq --unbuffered '.messages[] | select(.sender_id == "73205709") | .id' | tee /Users/george.owen/src/GroupMe/Last20/jqout.messageid.txt

#remove "" from message id out file
sed -ig 's/"//g' /Users/george.owen/src/GroupMe/Last20/jqout.messageid.txt
rm /Users/george.owen/src/GroupMe/Last20/*.txtg

#gets message id of latest Einhorn messahe
latest_id=`awk '/./{line=$0} END{print line}' /Users/george.owen/src/GroupMe//Last20/jqout.messageid.txt`
echo $latest_id > /Users/george.owen/src/GroupMe/Last20/latestID.txt
echo $latest_id
cat /Users/george.owen/src/GroupMe/Last20/latestID.txt
echo $last_einhorn_mes_id" YOOO"
echo $urlmessid
echo $url
