# How to use

For common use it is extremely simple.

exemple:
```yml
name: Publish
on: [push]
jobs:
  Teste:
    runs-on: ubuntu-latest
    steps:
    - name: Checkout
      uses: actions/checkout@main

    ...

    - name: Publish
      uses: Sirherobrine23/Action-Debian_Package_Publish@main
      with:
        REPO_PATH: 'package/main'
        PATH: "${{ env.DEB_PATH }}"
        TOKEN: ${{ secrets.TOKEN }}
```

Example with a debian builder:
```yml
name: Build and Publish
on: [push]
jobs:
  Teste:
    runs-on: ubuntu-latest
    steps:
    - name: Checkout
      uses: actions/checkout@main

    - name: Package
      uses: Sirherobrine23/Action-Debian_Package@main

    - name: Publish
      uses: Sirherobrine23/Action-Debian_Package_Publish@main
      with:
        REPO_PATH: 'package/main'
        PATH: "${{ env.DEB_PATH }}"
        TOKEN: ${{ secrets.TOKEN }}
```
# Options

We have several methods for publishing a repository, and several methods for authentication

## PATH

Where is the file to be uploaded to the git repository
default: '/tmp/*.deb'

## REPO_PATH

O onde será depositado os arquivos .deb
por padrão será no package/main

## TOKEN

Your password or an access token.
To publish in a repository $ {{secrets.GITUB_TOKEN}} is unable to publish in other repositories, so you will have to create one and place it in a secret

## GITHUB_TOKEN_V

Do not change

## REPOSITORY

Git repository url, default will be the runners own repository

## BRANCH

Branch of the repository, by default it will be package

## SQUASH

The entire repository will overwrite for just one commit
This is useful for the repository not getting too big, over 1GB in total
