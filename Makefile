default: build

build:
	jekyll b

deploy: build
	scp -rp _site/* root@onemogin.com:/usr/share/nginx/html/
