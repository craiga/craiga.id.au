default:  ## Build and serve the web site.
	bundle install
	bundle exec rougify style base16.solarized > _sass/rouge.scss
	bundle exec jekyll serve --incremental --livereload

drafts:  ## Build and serve the web site with blog post drafts.
	bundle exec jekyll serve --livereload --drafts

cv-pdf:  ## Create CV PDF.
	bundle install
	bundle exec jekyll serve --port 8765 --quiet --detach
	pipenv install
	pipenv run weasyprint http\://localhost\:8765/cv cv.pdf
	pkill -f jekyll

lockdown: ## Create assets for lockdown page from assets exported from Everyday.
	ffmpeg -i video.mov -an -vcodec h264 -b:v 0.5M -filter:v scale=360:-1 -y lockdown.mp4
	cjpeg -outfile lockdown-end.jpg "PNG image.png"
	convert lockdown-start.jpg lockdown-end.jpg +append lockdown.jpg
	sed -i "" -e "s/<span id=\"lastUpdated\">.*<\/span>/<span id=\"lastUpdated\">`date +"%A %d %B"`<\/span>/g" lockdown.markdown
	git add lockdown.*
	git commit --message "Lockdown `date +"%A %d %B"`" --no-verify

images: ## Create resized and compressed images.
	./images.sh

spellcheck: ## Check spelling.
	./spellcheck.sh

help: ## Display this help screen.
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
