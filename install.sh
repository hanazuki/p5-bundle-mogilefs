#!/bin/sh

set -e

DIR=$(dirname $(readlink -f $0))
cd $DIR

# 既に patch 済みの場合の hunk を避けるバッドハックなのだけど、ベターな回避方法ないかな
rm -rf extlib/lib/perl5/MogileFS
./cpanm -L extlib --mirror=$(pwd)/cpan-mirror/ --mirror-only --installdeps . "$@"

# http://bogomips.org/MogileFS-Server.git/patch/?id=8b76d98f80b5ab231634f6e0253a2d71c41e02f8
patch -d extlib/lib/perl5/ -p2 < patch/00-replicate-avoid-buffered-IO-on-reads.patch
