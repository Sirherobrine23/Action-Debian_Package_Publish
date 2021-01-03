#!/bin/bash
DIR_PATH=`pwd`
rm -rf .git
# sudo apt reinstall git
# URL
if echo $INPUT_REPOSITORY|grep -q 'https://';then
    url="$(echo $INPUT_REPOSITORY|sed 's|https://||g')"
    # repo="https://${GITHUB_ACTOR}:${INPUT_TOKEN}@$url"
    repo="https://${INPUT_TOKEN}@$url"
    echo "Username: ${GITHUB_ACTOR}"
    echo "Token: ${INPUT_TOKEN}"
    echo "Url: $url"
else
    echo "Não foi encontrado um repositorio git compativel"
    exit 1
fi

# USE
git config user.name github-actions
git config user.email github-actions@github.com
echo $repo
git clone $repo $DIR_PATH/repo
cd $DIR_PATH/repo/
git checkout ${INPUT_BRANCH}
if [ $INPUT_SQUASH == 'true' ];then
    echo "This will erase the file history"
    git rebase --root --autosquash
    git commit -m 'squash Files' -m "Package Path Uploaded: ${DEB_NAME}" -m 'Git Squash'
fi
if [ -d ${INPUT_REPO_PATH} ];then
    cd ${INPUT_REPO_PATH}
    cp -rfv ${INPUT_PATH} ./
    cd $DIR_PATH/repo/
    git add -A
    git commit -m "Upload Package: ${DEB_NAME}"

    git status
    echo "-------------------------"
    git push || git push --force
    echo "Git exit code: $?"
    echo "-------------------------"
    # git push --force --verbose || {
    #     echo "Erro in push"
    #     exit 3
    # }
else
    exit 2
fi

exit 255