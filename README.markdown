[![Build Status](https://travis-ci.org/craiga/craiga.id.au.svg?branch=master)](https://travis-ci.org/craiga/craiga.id.au) [![Requirements Status](https://requires.io/github/craiga/craiga.id.au/requirements.svg?branch=master)](https://requires.io/github/craiga/craiga.id.au/requirements/?branch=master)

    $ pipenv run ./build.py --help
    Usage: build.py [OPTIONS]

      Build content for craiga.id.au from a series of Markdown files.

    Options:
      --content_dir DIRECTORY   A directory containing Markdown files.
      --style_dir DIRECTORY     A directory containing Sass files.
      --script_dir DIRECTORY    A directory containing JavaScript files.
      --template_file FILENAME  Template used to build the site.
      --output_dir DIRECTORY    Output directory.
      --no-pdf                  Do not render PDFs.
      --help                    Show this message and exit.
