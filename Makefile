
.PHONY: deploy
deploy:
	HUGO_ENV=production docker-compose run web hugo
	aws s3 sync public/ s3://monofuel.dev
