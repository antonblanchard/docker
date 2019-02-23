#! /bin/sh
# This script is executed in the travis-ci environment.

set -e

scriptdir=$(dirname $0)

. "$scriptdir/travis/utils.sh"

for d in build run; do
    currentdir="${scriptdir}/dockerfiles/$d"
    for f in `ls $currentdir`; do
        for tag in `grep -oP "FROM.*AS \K.*" ${currentdir}/$f`; do
            echo "travis_fold:start:${f}-$tag"
            travis_time_start
            printf "$ANSI_BLUE[DOCKER build] ${d} : ${f} - ${tag}$ANSI_NOCOLOR\n"
            docker build -t ghdl/${d}:${f}-${tag} --target $tag - < ${currentdir}/$f
            travis_time_finish
            echo "travis_fold:end:${f}-$tag"
        done
    done
done
