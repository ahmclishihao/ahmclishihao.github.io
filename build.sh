#!/bin/sh
# 重新构建
curDate="date +'%Y-%m-%d %T' "
git add *
git commit -m "文章更新 $curDate"
git push