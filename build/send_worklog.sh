#!/bin/bash
ISSUE=$1
STARTED_AT=$2
TIME_SPENT=$3
BODY="{\"started\":\"$STARTED_AT\",\"timeSpentSeconds\":$TIME_SPENT}"

curl  \
	--request POST \
	--url "http://localhost:5000/rest/api/3/issue/$ISSUE/worklog?notifyUsers=false" \
	--user "$JIRA_USER:$JIRA_API_KEY" \
	--header 'Content-Type: application/json' \
	--silent \
    --data $BODY \
	--output /dev/null \
	--write-out '%{http_code}' 
	

