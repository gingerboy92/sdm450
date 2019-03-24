#!/usr/bin/env sh

if [ ! -z "$CI_COMMIT_TAG" ]; then
    COMMIT_RANGE="$(git describe --abbrev=0 --tags $CI_COMMIT_SHA^)..$CI_COMMIT_BEFORE_SHA"
else
    COMMIT_RANGE="$CI_COMMIT_BEFORE_SHA..$CI_COMMIT_SHA"
fi

GIT_COMMIT_LOG="$(git log --format='%s (by %cn)' $COMMIT_RANGE)"

echo " <b>Changelog for new Update!</b>${NEWLINE}"

printf '%s\n' "$GIT_COMMIT_LOG" | while IFS= read -r line
do
  echo "- ${line}"
done
