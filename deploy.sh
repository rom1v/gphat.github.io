#!/bin/bash

jekyll build
scp -rp _site/* root@104.236.86.85:/usr/share/nginx/html

curl  -X POST -H "Content-type: application/json" \
-d '{
      "title": "deploy:content",
      "text": "content",
      "priority": "normal",
      "tags": ["site:omg","action:deploy","app:jekyll"],
      "alert_type": "success"
  }' \
'https://app.datadoghq.com/api/v1/events?api_key=a0f53482a914a2b00f447ebfd542303c'
