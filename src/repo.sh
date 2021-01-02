#!/bin/bash
DIR_PATH=`pwd`
rm -rf .git
sudo apt reinstall git
# URL
if echo $INPUT_REPOSITORY|grep -q 'https://';then
    repo="https://${GITHUB_ACTOR}:${INPUT_TOKEN}@$(echo $INPUT_REPOSITORY|sed 's|https://||g')"
elif echo $INPUT_REPOSITORY|grep -q 'http://';then
    repo="http://${GITHUB_ACTOR}:${INPUT_TOKEN}@$(echo $INPUT_REPOSITORY|sed 's|http://||g')"
elif echo $INPUT_REPOSITORY|grep -q 'git://';then
    repo="git://${GITHUB_ACTOR}:${INPUT_TOKEN}@$(echo $INPUT_REPOSITORY|sed 's|git://||g')"
else
    echo "Não foi encontrado um repositorio git compativel"
    exit 1
fi

# USE
git config http.sslVerify false 
git config --global user.name "github-actions[bot]"
git config --global user.email "github-actions[bot]@users.noreply.github.com"

if git clone $repo -b ${INPUT_BRANCH} $DIR_PATH/repo;then
    if cd $DIR_PATH/repo/;then
        if ! cd ${INPUT_REPO_PATH};then
            exit 4
        fi
    else
        exit 3
    fi
else
    echo "Git clone erro"
    echo $repo
    exit 2
fi
pwd
cp -rfv ${INPUT_PATH} ./
git add .
git commit -m 'Upload Package, Github Actions' -m "Package Path Uploaded: ${INPUT_PATH}"
if [ $INPUT_SQUASH == 'true' ];then
    echo "This will erase the file history"
    git rebase --root --autosquash
    git commit -m 'squash Files' -m "Package Path Uploaded: ${INPUT_PATH}" -m 'Git Squash'
fi
git push -f || exit 5
exit 0