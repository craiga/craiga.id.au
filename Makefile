pdf:
	bundle install
	bundle exec jekyll serve --port 8765 --quiet --detach
	pipenv install
	pipenv run weasyprint http\://localhost\:8765/cv cv.pdf
	pipenv run weasyprint http\://localhost\:8765/emoji emoji.pdf
	pipenv run weasyprint http\://localhost\:8765/weasyprint-border weasyprint-border.pdf
	pkill -f jekyll

lockdown:
	ffmpeg -i video.mov -an -vcodec h264 -b:v 400k lockdown.mp4
	cjpeg -outfile lockdown.jpg "PNG image.png"
