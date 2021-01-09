#!/bin/bash
if [ $INPUT_GITHUB_TOKEN_V == $INPUT_TOKEN ];then
    echo 'Do not use ${{secrets.GITHUB_TONKEN}}, it does not have access to other repositories'
    exit 255
fi
DIR_PATH=`pwd`
GIT_EXEC_PATH=''
rm -rf .git
# USE
git config user.name 'github-actions'
git config user.email 'github-actions@github.com'
git config --global http.postBuffer 157286400 sslVerify=false
# sudo apt reinstall git
# URL
if echo $INPUT_REPOSITORY|grep -q 'https://';then
    url="$(echo $INPUT_REPOSITORY|sed 's|https://||g')"
    repo="https://${GITHUB_ACTOR}:${INPUT_TOKEN}@$url"
elif echo $INPUT_REPOSITORY|grep -q 'http://';then
    url="$(echo $INPUT_REPOSITORY|sed 's|http://||g')"
    repo="https://${GITHUB_ACTOR}:${INPUT_TOKEN}@$url"
elif echo $INPUT_REPOSITORY|grep -q 'git://';then
    url="$(echo $INPUT_REPOSITORY|sed 's|git://||g')"
    repo="https://${GITHUB_ACTOR}:${INPUT_TOKEN}@$url"
else
    echo "A compatible git repository was not found"
    exit 1
fi
echo "Username: ${GITHUB_ACTOR}"
echo "Url: $url"

git clone $repo -b ${INPUT_BRANCH} $DIR_PATH/repo || \
if git clone $repo $DIR_PATH/repo
then
    cd $DIR_PATH/repo
    git branch ${INPUT_BRANCH}
    git checkout ${INPUT_BRANCH}
else
    echo "erro in clone"
    exit $?
fi
cd $DIR_PATH/repo/
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
    cp -rfv ${INPUT_PATH} ${PWD}/
    cd $DIR_PATH/repo/
    git add -A
    git commit -m "Upload Package: ${DEB_NAME}"
    echo "-------------------------"
    git push $repo --force HEAD:${INPUT_BRANCH}||{
        git_erro=$?
        echo "Git erro: $git_erro"
        echo "Erro in push"
        exit $git_erro
    }
    else
        echo "We have successfully published the package: ${DEB_NAME}"
    fi
    echo "-------------------------"
else
    echo "The ${INPUT_REPO_PATH} directory is not there"
    exit 2
fi
#
echo "Checking if published"
#
git clone $repo -b ${INPUT_BRANCH} $DIR_PATH/repo_check || \
if git clone $repo $DIR_PATH/repo_check
then
    cd $DIR_PATH/repo_check
    git branch ${INPUT_BRANCH}
    git checkout ${INPUT_BRANCH}
else
    echo "Erro in clone"
    exit $?
fi
if [ -d ${INPUT_REPO_PATH} ]
then
    cd ${INPUT_REPO_PATH}
    if ! [ -e ${INPUT_PATH} ]
    then
        echo "Package not published"
        exit 223
    else
        echo "Packages published successfully"
    fi
else
    echo "The ${INPUT_REPO_PATH} directory is not there"
    exit 222
fi


exit 0