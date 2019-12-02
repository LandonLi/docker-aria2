#!/bin/sh
export trackers=$(curl -s https://raw.githubusercontent.com/ngosang/trackersllist/master/trackers_best.txt | tr '\n' '@' | sed -e 's/@@/,/g')
sed -i "s#bt-tracker=.*#bt-tracker=$trackers#g" ./aria2.conf
