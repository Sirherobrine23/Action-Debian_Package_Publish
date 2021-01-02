#!/bin/bash
# URL
if echo $INPUT_REPOSITORY|grep -q 'https://';then
    repo="https://${GITHUB_ACTOR}:${INPUT_TOKEN}@$(echo $INPUT_REPOSITORY|sed 's|https://||g').git"
elif echo $INPUT_REPOSITORY|grep -q 'http://';then
    repo="http://${GITHUB_ACTOR}:${INPUT_TOKEN}@$(echo $INPUT_REPOSITORY|sed 's|http://||g').git"
elif echo $INPUT_REPOSITORY|grep -q 'git://';then
    repo="git://${GITHUB_ACTOR}:${INPUT_TOKEN}@$(echo $INPUT_REPOSITORY|sed 's|git://||g').git"
else
    echo "Não foi encontrado um repositorio git compativel"
    exit 1
fi

# USE
git config http.sslVerify false 
git config --global user.name "github-actions[bot]"
git config --global user.email "github-actions[bot]@users.noreply.github.com"

git clone $repo -b ${BRANCH} /tmp/repo
#
cd /tmp/repo
cd ${INPUT_REPO_PATH}
cp -rfv ${INPUT_PATH} ./
cd /tmp/repo
git add .
git commit -m 'Upload Package, Github Actions' -m "Package Path Uploaded: ${INPUT_PATH}"
if [ $INPUT_SQUASH == 'true' ];then
    echo "This will erase the file history"
    git rebase --root --autosquash
    git commit -m 'squash Files' -m "Package Path Uploaded: ${INPUT_PATH}" -m 'Git Squash'
fi
git push -f
exit 0