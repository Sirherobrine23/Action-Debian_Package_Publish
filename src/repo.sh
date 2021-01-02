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
git config --global user.name "github-actions[bot]"
git config --global user.email "github-actions[bot]@users.noreply.github.com"
echo $repo
git clone $repo -b ${INPUT_BRANCH} $DIR_PATH/repo
cd $DIR_PATH/repo/
if [ -d ${INPUT_REPO_PATH} ];then
    cd ${INPUT_REPO_PATH}
    pwd
    cp -rfv ${INPUT_PATH} ./
    cd $DIR_PATH/repo/
    git add . -A
    git commit -m 'Upload Package, Github Actions' -m "Package Uploaded: ${DEB_NAME}"
    if [ $INPUT_SQUASH == 'true' ];then
        echo "This will erase the file history"
        git rebase --root --autosquash
        git commit -m 'squash Files' -m "Package Path Uploaded: ${DEB_NAME}" -m 'Git Squash'
    fi
    git push --force --verbose || {
        echo "Erro in push"
        exit 3
    }
else
    exit 2
fi

exit 0