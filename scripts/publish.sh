#!/bin/bash -e

REPO=nikosgavalas.github.io
URL=https://$GH_USERNAME:$GH_TOKEN@github.com/nikosgavalas

SHA=$( git rev-parse HEAD )

#git clone ${URL}/${REPO}.git $REPO
rm -r $REPO/*
ls -al $REPO

hugo version
hugo
cd $REPO

git checkout master
git config user.email "$GH_EMAIL"
git config user.name "$GH_USERNAME"
git add .
git commit -m "built from $SHA"

git push ${URL}/${REPO}.git
