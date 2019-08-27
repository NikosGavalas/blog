#!/bin/bash -e

cleanup() {
    CODE=$?
    rm -rf $HOME/nikosgavalas.github.io
    exit $CODE
}

trap cleanup EXIT

SHA=$( git rev-parse HEAD )

REPO=$HOME/nikosgavalas.github.io
git clone https://$GH_USERNAME:$GH_TOKEN@github.com/nikosgavalas/nikosgavalas.github.io.git $REPO
rm -r $REPO/*
ls -al $REPO

if [ -d public ]; then
    rm -r public
fi

hugo version
hugo
rsync -av public/* $REPO/
cd $REPO
git add .
git commit -m "built from $SHA"

git push https://$GH_USERNAME:$GH_TOKEN@github.com/nikosgavalas/nikosgavalas.github.io.git
