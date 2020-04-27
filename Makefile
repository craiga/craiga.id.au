default:  ## Build and serve the web site.
	bundle install
	bundle exec jekyll serve --incremental --livereload --drafts --future

cv-pdf:  ## Create CV PDF.
	bundle install
	bundle exec jekyll serve --port 8765 --quiet --detach
	pipenv install
	pipenv run weasyprint http\://localhost\:8765/cv cv.pdf
	pkill -f jekyll

lockdown: ## Create assets for lockdown page from assets exported from Everyday.
	ffmpeg -i video.mov -an -vcodec h264 -b:v 2M -filter:v scale=360:-1 -y lockdown.mp4
	cjpeg -outfile lockdown.jpg "PNG image.png"
	sed -i "" -e "s/<span id=\"lastUpdated\">.*<\/span>/<span id=\"lastUpdated\">`date +"%A %d %B"`<\/span>/g" lockdown.markdown
	git add lockdown.*
	git commit --message "Lockdown `date +"%A %d %B"`" --no-verify

help: ## Display this help screen.
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
