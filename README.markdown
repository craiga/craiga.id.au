[![CircleCI branch](https://img.shields.io/circleci/project/github/craiga/craiga.id.au/master.svg)](https://circleci.com/gh/craiga/craiga.id.au/tree/master)

Built using [Jekyll](https://jekyllrb.com) and [Bootstrap](https://getbootstrap.com). Hosted right here on [GitHub Pages](https://pages.github.com).

To run locally:

    bundle install
    bundle exec jekyll serve --incremental --livereload

The site will be available at http://localhost:4000.

Requires [Bundler](https://bundler.io).


# Generating PDFs

Generate PDFs by running `make pdf`. Requires [Bundler](https://bundler.io) and [Pipenv](https://pipenv.readthedocs.io/en/latest/).


# Syntax Highlighting CSS

To generate syntax highlighting CSS, run the following command:

    bundle exec rougify style base16.solarized > _sass/rouge.scss


# Preparing Images

Images compressed with [Mozilla's JPEG Encoder](https://github.com/mozilla/mozjpeg):

    cjpeg -outfile assets/craig-xs.optimised.jpg assets/craig-xs.jpg
    cjpeg -outfile assets/craig-sm.optimised.jpg assets/craig-sm.jpg
    cjpeg -outfile assets/craig-md.optimised.jpg assets/craig-md.jpg
    cjpeg -outfile assets/craig-lg.optimised.jpg assets/craig-lg.jpg
    cjpeg -outfile assets/craig-xl.optimised.jpg assets/craig-xl.jpg
