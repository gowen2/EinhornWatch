#!/bin/sh
curl -X GET -H "Content-Type: application/json" -d '{"name": "Family"}' https://api.groupme.com/v3/groups?token=5u7VXqv9CBploHRLSoasGFAUyAsUWfhHBWH2zZBd | json_pp
