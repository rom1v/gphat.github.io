#!/bin/bash

jekyll build
scp -rp _site/* root@104.236.86.85:/usr/share/nginx/html
