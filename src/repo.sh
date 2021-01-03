#!/bin/bash
if [ $INPUT_GITHUB_TOKEN_V == $INPUT_TOKEN ];then
    echo 'Do not use ${{secrets.GITHUB_TONKEN}}, it does not have access to other repositories'
    exit 255
fi
DIR_PATH=`pwd`
GIT_EXEC_PATH=''
rm -rf .git
git config --global http.postBuffer 157286400 sslVerify=false
# sudo apt reinstall git
# URL
if echo $INPUT_REPOSITORY|grep -q 'https://';then
    url="$(echo $INPUT_REPOSITORY|sed 's|https://||g')"
    repo="https://${GITHUB_ACTOR}:${INPUT_TOKEN}@$url"
    echo "Username: ${GITHUB_ACTOR}"
    echo "Url: $url"
else
    echo "Não foi encontrado um repositorio git compativel"
    exit 1
fi

# USE
git config user.name github-actions
git config user.email github-actions@github.com
git clone $repo -b ${INPUT_BRANCH} $DIR_PATH/repo
cd $DIR_PATH/repo/
git branch | grep -q ${INPUT_BRANCH} || {
    echo "Branch not found ... Creating a"
    git branch ${INPUT_BRANCH}
    git checkout ${INPUT_BRANCH}
}
# Rebase
if [ $INPUT_SQUASH == 'true' ];then
    echo "This will erase the file history"
    git rebase --root --autosquash
    git commit -m 'squash Files' -m "Package Path Uploaded: ${DEB_NAME}" -m 'Git Squash'
fi
# Rebase
if [ -d ${INPUT_REPO_PATH} ]
then
    cd ${INPUT_REPO_PATH}
    cp -rfv ${INPUT_PATH} ./
    cd $DIR_PATH/repo/
    git add -A
    git commit -m "Upload Package: ${DEB_NAME}"

    git status
    echo "-------------------------"
    if ! git push;then
        echo "Error pushing the commit, 2 attempt"
        git push --force || {
            echo "Erro in push"
            exit 3
        }
    fi
    echo "-------------------------"
else
    echo "The ${INPUT_REPO_PATH} directory is not there"
    exit 2
fi

exit 0