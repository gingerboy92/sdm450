#!/bin/sh

n=0.00
n=$[ $n + 1 ]
echo -e n
sed '2 a n=$n requirements.sh

sudo apt-get install pandoc
gem install asciidoctor
make 


setup_git() {
  git config --global user.email "$MYEMAIL"
  git config --global user.name "$MYNAME"
}

commit_website_files() {
  git checkout -b gh-pages
  git add requirements.sh *.html
  git commit --message "C build: $CI_BUILD_NUMBER"
  git 
}

upload_files() {
  git remote add origin-pages https://${GH_TOKEN}@github.com/MVSE-outreach/resources.git > /dev/null 2>&1
  git push --quiet --set-upstream origin-pages gh-pages 
}

create_json() {
 echo "{ "downloads":{  "name":"Nano Kernel", "ver":"BETA-3.1", "url":"" }, "name":"", "description":"", "features":[ ], "CPU Governors":[ ], "I/O Schedulers":[ ], "changelog":[ ] }" > downloads.json

setup_git
commit_website_files
upload_files
