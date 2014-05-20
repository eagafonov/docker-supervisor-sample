build: id_rsa.pub
	docker build -t eagafonov/supervisord .

runfg:
	docker run -t -i --publish-all=true \
		--name=supervisord-test2 \
		--hostname="supervisord-test2" \
		--rm \
		eagafonov/supervisord

id_rsa.pub:
	echo id_rsa | ssh-keygen