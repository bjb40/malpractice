#!/usr/bin/python

import sys
import os

#os.system('wdiff -s3 "%s" "%s"' % (sys.argv[2], sys.argv[5]))

#two arbitrary commits
#git diff [--options] <commit> <commit> [--] [<path>​]

os.system("git diff --word-diff=porcelain origin/master | grep -e '^+[^+]' | wc -w")


#other options are git log... git log --stat git log --pretty=format git log --shortstat
#git log --since=2.weeks
