#!/bin/sh
#stamp=`date +%s`
stamp="out"
namebase="last20"
namefull="${namebase}-${stamp}.json"
#sender_id="73205709" #Einhorn
#sender_id="47126376"
#after_id="161376602848318931"
after_id=`cat /Users/george.owen/src/GitHub/EinhornWatch/Last20/latestID.txt`
urlbase='https://api.groupme.com/v3/groups/32841593/messages?token=5u7VXqv9CBploHRLSoasGFAUyAsUWfhHBWH2zZBd&limit=100&after_id='
urlmessid="${after_id}"
url="${urlbase}${urlmessid}"

#Test if var is null
#if [ -z "after_id" ]; then
#else;
#fi;

#curl --location --request GET "https://api.groupme.com/v3/groups/32841593/messages?token=5u7VXqv9CBploHRLSoasGFAUyAsUWfhHBWH2zZBd&limit=100&after_id=161376602848318931" >> /Users/george.owen/src/GitHub/EinhornWatch/Last20/$namefull;
curl --location --request GET "${url}" > /Users/george.owen/src/GitHub/EinhornWatch/Last20/$namefull; 
	

#formats output for jq parsing
sed -ig 's/"response":{//g' /Users/george.owen/src/GitHub/EinhornWatch/Last20/$namefull
sed -ig 's/"count":[0-9][0-9][0-9][0-9][0-9][0-9],//g' /Users/george.owen/src/GitHub/EinhornWatch/Last20/$namefull
sed -ig 's/},"meta":{"code":200}//g' /Users/george.owen/src/GitHub/EinhornWatch/Last20/$namefull
rm /Users/george.owen/src/GitHub/EinhornWatch/Last20/*.jsong

#output einhorn message text in last n messages
cat /Users/george.owen/src/GitHub/EinhornWatch/Last20/$namefull | jq --unbuffered '.messages[] | select(.sender_id == "73205709") | .text' | tee /Users/george.owen/src/GitHub/EinhornWatch/Last20/jqout.text.txt
cat /Users/george.owen/src/GitHub/EinhornWatch/Last20/$namefull | jq --unbuffered '.messages[] | select(.sender_id == "73205709") | .id' | tee /Users/george.owen/src/GitHub/EinhornWatch/Last20/jqout.messageid.txt

#remove "" from message id out file
sed -ig 's/"//g' /Users/george.owen/src/GitHub/EinhornWatch/Last20/jqout.messageid.txt
rm /Users/george.owen/src/GitHub/EinhornWatch/Last20/*.txtg

#gets message id of latest Einhorn messahe
latest_id=`awk '/./{line=$0} END{print line}' /Users/george.owen/src/GitHub/EinhornWatch//Last20/jqout.messageid.txt`

if [ -z $latest_id ]
then
  echo "\nNo new messages since message ID: $after_id"
  echo "Writing previous message ID (above) to LatestID.txt"
  echo $after_id > /Users/george.owen/src/GitHub/EinhornWatch/Last20/latestID.txt
  latest_id=$after_id
else
  echo $latest_id > /Users/george.owen/src/GitHub/EinhornWatch/Last20/latestID.txt
fi

#echo $latest_id > /Users/george.owen/src/GitHub/EinhornWatch/Last20/latestID.txt

#CLI Outputs for Validation
echo "\nafter_id (in URL): $after_id"
echo "latest_id: $latest_id"
echo "pulled URL: $urlbase$after_id"
echo "next URL:   $urlbase$latest_id"
#cat /Users/george.owen/src/GitHub/EinhornWatch/Last20/latestID.txt
#echo $urlmessid
#echo $url
