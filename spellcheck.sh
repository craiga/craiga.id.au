#!/usr/bin/env bash

set -e

# 1.   Find all Markdown files, excluding those in the vendor directory which is
#      created in Travis.
# 2.   Output content of those files.
# 3.   Remove metadata lines which start with image:, image-credit-name:, etc.
# 4.   Remove code blocks indented with four spaces.
# 5-8. Remove <script> tags and their contents (adapted from
#      https://stackoverflow.com/a/52562545/1852024)
# 9.   Remove HTML tags.
# 10.  Remove HTML entities.
# 11.  Remove Jekyll commands ({% … %}).
# 12.  Remove Kramdown directives ({: … })
# 13.  Remove Markdown links.
# 14.  Remove code blocks surrounded by ```.
# 15.  Remove inline code marked up with ticks.
# 16.  Finally, check spelling of everything that remains.

# shellcheck disable=SC2016
misspelled_words=$(find . \( -iname "*.markdown" -or -iname "*.md" -or -iname "*.mdown" \) -not \( -path "./.vendor/*" -or -path "./_drafts/*" \) -print0 \
  | xargs -0 cat \
  | grep -v -E "^(\\s|\\-)*(image|image-credit-name|image-credit-url|image-position|original_url|redirect_from|url):" \
  | grep -v -E "^\\s{4}" \
  | sed "s/<script>.*<\/script>//" \
  | sed "/<script/,/<\/script>/d" \
  | sed "s/<script>.*//g;" \
  | sed "s/.*<\/script>//g" \
  | sed "s/<.*>//" \
  | sed "s/&.*;//" \
  | sed "s/{%.*%}//" \
  | sed "s/{:.*}//" \
  | sed "s/](.*)/]/" \
  | sed "s/\\[\\^.*\\]/]/" \
  | sed -n '/^```/,/^```/ !p' \
  | sed 's/`.*`//' \
  | aspell --lang=en_GB-w_accents --encoding=utf-8 --personal=./.aspell.en.pws list)

if [[ "$misspelled_words" ]];
then
  echo "Misspelled words:"
  echo "$misspelled_words"
  exit 1
fi
