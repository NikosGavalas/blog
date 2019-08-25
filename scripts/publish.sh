#!/bin/bash -e

REPO=nikosgavalas.github.io
URL=https://$GITHUB_USERNAME:$GITHUB_PASSWORD@github.com/nikosgavalas

cleanup() {
    CODE=$?
    rm -rf $HOME/ericchiang.github.io
    exit $CODE
}

trap cleanup EXIT

SHA=$( git rev-parse HEAD )

git clone ${URL}/${REPO}.git $REPO
rm -r $REPO/*
ls -al $REPO

hugo version
hugo
cd $REPO
git add .
git commit -m "built from $SHA"

git push ${URL}/${REPO}.git
