#!/bin/sh

n=0.00
new=$[ $n + 1 ]
echo -e n
sed '2 a n=$n requirements.sh

echo "{ "downloads":{  "name":"Nano Kernel", "ver":"BETA-$n", "url":"" }, "name":"", "description":"", "features":[ ], "CPU Governors":[ ], "I/O Schedulers":[ ], "changelog":[ ] }" > downloads.json

curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/deployments/git_push.sh | bash -s

