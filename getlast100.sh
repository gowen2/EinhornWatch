#!/bin/sh
#stamp=`date +%s`
br="\r\n" #Useful shorthand when you need to have a line break in a bot message
stamp="out"
namebase="last100"
namefull="${namebase}-${stamp}.json"
BASEDIR="/Users/george.owen/src/GitHub/EinhornWatch/Last100"
#sender_id="73205709" #Einhorn
#sender_id="47126376"
#after_id="161376602848318931"
after_id=`cat $BASEDIR/latestID.txt`
old_latest_text=`cat $BASEDIR/latestText.txt`
urlbase='https://api.groupme.com/v3/groups/32841593/messages?token=5u7VXqv9CBploHRLSoasGFAUyAsUWfhHBWH2zZBd&limit=100&after_id='
urlmessid="${after_id}"
url="${urlbase}${urlmessid}"

#Test if var is null
#if [ -z "after_id" ]; then
#else;
#fi;

#curl --location --request GET "https://api.groupme.com/v3/groups/32841593/messages?token=5u7VXqv9CBploHRLSoasGFAUyAsUWfhHBWH2zZBd&limit=100&after_id=161376602848318931" >> $BASEDIR/$namefull;
curl --location --request GET "${url}" > $BASEDIR/$namefull; 
	

#formats output for jq parsing
sed -ig 's/"response":{//g' $BASEDIR/$namefull
sed -ig 's/"count":[0-9][0-9][0-9][0-9][0-9][0-9],//g' $BASEDIR/$namefull
sed -ig 's/},"meta":{"code":200}//g' $BASEDIR/$namefull
rm $BASEDIR/*.jsong

#output einhorn message text in last n messages
cat $BASEDIR/$namefull | jq --unbuffered '.messages[] | select(.sender_id == "73205709") | .text' | tee $BASEDIR/jqout.text.txt
cat $BASEDIR/$namefull | jq --unbuffered '.messages[] | select(.sender_id == "73205709") | .id' | tee $BASEDIR/jqout.messageid.txt

#remove "" from message id out file
sed -ig 's/"//g' $BASEDIR/jqout.messageid.txt
rm $BASEDIR/*.txtg

#gets message id of latest Einhorn messahe
#WRONG: Gets last line (oldest message ID) #latest_id=`awk '/./{line=$0} END{print line}' /Users/george.owen/src/GitHub/EinhornWatch//Last20/jqout.messageid.txt`
#RIGHT: Gets FIRST line of file (below)
latest_id=`awk 'NR==1' $BASEDIR/jqout.messageid.txt`
latest_text=`awk 'NR==1' $BASEDIR/jqout.text.txt`
unread_texts=`cat $BASEDIR/jqout.text.txt`

if [ -z $latest_id ]
then
  printf "$unread_texts" > $BASEDIR/UnreadTexts.txt
  echo $old_latest_text > $BASEDIR/latestText.txt
  echo $after_id > $BASEDIR/latestID.txt
  echo "\nNo new messages since:\nID: $after_id\nText: $old_latest_text"
  echo "Writing previous message ID (above) to LatestID.txt"
  latest_id=$after_id
  latest_text=$old_latest_text
else
  echo $unread_texts > $BASEDIR/UnreadTexts.txt
  echo $latest_id > $BASEDIR/latestID.txt
  echo $latest_text > $BASEDIR/latestText.txt
fi

#echo $latest_id > $BASEDIR/latestID.txt
#echo $latest_text > $BASEDIR/latestText.txt

#CLI Outputs for Validation
#echo "\n------------------\nafter_id (in URL): $after_id"
#echo "latest_id: $latest_id"
#echo "old latest text: $old_latest_text"
#echo "latest text: $latest_text"
#echo "pulled URL: $urlbase$after_id"
#echo "next URL:   $urlbase$latest_id"

#Send output of unread messages to $TONK$ GMu
#TEMPLATE: curl -d '{"text" : "EinhornWatch Bot:\r\nTesting Message\r\nWith line-breaks", "bot_id" : "480feaaf761f73e5712e49ac4d"}' https://api.groupme.com/v3/bots/post
send_base1='{"text" : "'
send_unread=`awk -v ORS='\\r\\n' '1' $BASEDIR/UnreadTexts.txt`
send_unread="${send_unread}"
send_base2='", "bot_id" : "480feaaf761f73e5712e49ac4d"}'
send_combo="'${send_base1}${send_unread}${send_base2}'"

echo
echo $send_combo

#curl -d "$send_combo" https://api.groupme.com/v3/bots/post
