#!/bin/bash
# you can customize this script but its only output must be the http code
# otherwise IssueWorklogger will fail
# this script apply to JIRA API

# these arguments are sent by IssueWorklogger
# The issue key
ISSUE=$1

# The start date in format yyyy-MM-ddThh:mm:ss.fff+0300
STARTED_AT=$2

# The worklog spent time in seconds
TIME_SPENT=$3

# Below parts are specific to Jira
BODY="{\"started\":\"$STARTED_AT\",\"timeSpentSeconds\":$TIME_SPENT}"

curl  \
	--request POST \
	--url "$JIRA_DOMAIN/rest/api/3/issue/$ISSUE/worklog?notifyUsers=false" \
	--user "$JIRA_USER:$JIRA_API_KEY" \
	--header 'Content-Type: application/json' \
	--silent \
    --data $BODY \
	--output /dev/null \
	--write-out '%{http_code}' 
	

