#!/usr/bin/env python
"""Build content for craiga.id.au from a series of Markdown files."""

from os import environ
from pathlib import Path
from shutil import copy
from urllib.parse import quote_plus

import click
import jinja2
import lxml.html
import sass
import weasyprint
from htmlmin import minify
from markdown import markdown, inlinepatterns, extensions
from markdown.util import etree
from mdx_smartypants import SmartypantsExt
from jsmin import jsmin
from xstatic.pkg import bootstrap_scss, font_awesome, jquery


ASSET_MODULES = (bootstrap_scss, font_awesome, jquery)


# 3-tuples of URLs, titles, and FontAwesome 4 class names.
# Top 5 featured in sidebar.
LINKS = (('/', 'Home', 'fa-home'),
         ('/cv', 'CV', 'fa-briefcase'),
         (
             'https://www.linkedin.com/in/craigeanderson',
             'LinkedIn',
             'fa-linkedin'
         ),
         ('https://github.com/craiga', 'GitHub', 'fa-github'),
         ('mailto:craiga@craiga.id.au', 'Email', 'fa-envelope'),
         # Popular
         ('https://facebook.com/craiga', 'Facebook', 'fa-facebook'),
         ('https://www.instagram.com/_craiga/', 'Instagram', 'fa-instagram'),
         ('https://twitter.com/_craiga', 'Twitter', 'fa-twitter'),
         # Music
         ('https://www.last.fm/user/craiganderson', 'Last.fm', 'fa-lastfm'),
         (
             'https://itunes.apple.com/profile/craigeanderson',
             'Apple Music',
             'fa-apple'
         ),
         ('https://bandcamp.com/craiga', 'Bandcamp', 'fa-bandcamp'),
         ('https://soundcloud.com/craiga', 'SoundCloud', 'fa-soundcloud'),
         # Booze
         ('https://untappd.com/user/craiganderson', 'Untappd', 'fa-beer'),
         ('https://distiller.com/profile/craiga', 'Distiller', 'fa-glass'),
         # Work
         (
             'https://www.nextfree.co.uk/for/craig-anderson',
             'Nextfree',
             'fa-calendar'
         ),
         ('https://uk.yunojuno.com/p/craiga', 'YunoJuno', 'fa-asterisk'),
         ('https://bitbucket.org/craiganderson/', 'Bitbucket', 'fa-bitbucket'),
         (
             'https://stackoverflow.com/users/1852024/craig-anderson',
             'Stack Overflow',
             'fa-stack-overflow'
         ),
         # Other
         ('http://amzn.eu/5UobAlG', 'Amazon', 'fa-amazon'),
         ('https://www.goodreads.com/craiga', 'Goodreads', 'fa-book'),
         ('https://www.meetup.com/members/24626782/', 'Meetup', 'fa-meetup'),
         ('https://www.pinterest.co.uk/craiga/', 'Pinterest', 'fa-pinterest'),
         ('https://www.reddit.com/user/craiga/', 'Reddit', 'fa-reddit'),
         ('http://steamcommunity.com/id/craiga', 'Steam', 'fa-steam'),
         ('http://blog.craiga.id.au/', 'Tumblr', 'fa-tumblr'))


def files(directory_name, glob_pattern, *args, **kwargs):
    """Yield files."""
    path = Path(directory_name)
    with click.progressbar(path.glob(glob_pattern), *args, **kwargs) as fnames:
        yield from fnames


def create_template(template_file):
    """Create the Jinja2 template."""
    # Load the template.
    template_content = ''
    for line in template_file:
        template_content = template_content + line

    return jinja2.Template(template_content)


class GoogleMapPattern(inlinepatterns.Pattern):
    """Google Map inline pattern handler for Python-Markdown."""

    def __init__(self):
        """Create pattern with fixed regular expression."""
        super().__init__(r'\[google\-map([^\]]*)\]')

    def handleMatch(self, m):
        """Handle [google-map Address] in Markdown."""
        ele = etree.Element('iframe')
        url = ('https://www.google.com/maps/embed/v1/place'
               '?q={place}&zoom={zoom}&key={api_key}')
        ele.set('src', url.format(place=quote_plus(m.group(2)),
                                  zoom=15,
                                  api_key=environ.get('GOOGLE_MAPS_API_KEY')))
        ele.set('class', 'map')
        return ele


class GoogleMapExtension(extensions.Extension):
    """Google Map extension for Python-Markdown."""

    def extendMarkdown(self, md, md_globals):
        """Register GoogleMapPattern."""
        md.inlinePatterns.add('google-map', GoogleMapPattern(), '_end')


class ExternalLinksPattern(inlinepatterns.Pattern):
    """External link inline pattern handler for Python-Markdown."""

    def __init__(self):
        """Create pattern with fixed regular expression."""
        super().__init__(r'\[external\-links\]')

    def handleMatch(self, m):
        """Handle [external-links] in Markdown."""
        div = etree.Element('div')
        div_classes = ' '.join(('list-group', 'links', 'row'))
        div.set('class', div_classes)
        for url, title, fa_class in LINKS[5:]:
            if url.startswith(('http://', 'https://')):
                anchor = etree.SubElement(div, 'a')
                anchor_classes = ' '.join(('list-group-item',
                                           'col-md-3',
                                           'col-sm-4',
                                           'col-xs-4'))
                anchor.set('class', anchor_classes)
                anchor.set('href', url)

                icon = etree.SubElement(anchor, 'i')
                icon_classes = ' '.join(('fa', fa_class, 'fa-fw'))
                icon.set('class', icon_classes)
                icon.set('aria-hidden', 'true')
                icon.tail = '&nbsp; ' + title

        return div


class ExternalLinksExtension(extensions.Extension):
    """Google Map extension for Python-Markdown."""

    def extendMarkdown(self, md, md_globals):
        """Register ExternalLinksPattern."""
        md.inlinePatterns.add('google-map', ExternalLinksPattern(), '_end')


def markdown_file_to_html(file_path):
    """Convert the markdown file to HTML."""
    md_extensions = ('markdown.extensions.footnotes',
                     'markdown.extensions.toc',
                     'markdown.extensions.abbr',
                     SmartypantsExt(configs={}),
                     GoogleMapExtension(),
                     ExternalLinksExtension())
    with file_path.open() as file:
        return markdown(file.read(), extensions=md_extensions)


def title_from_html(html, default=''):
    """Extract a title from the given HTML."""
    tree = lxml.html.fromstring(html)
    headings = tree.xpath('//h1/text()')
    if headings:
        return headings[0]

    return default


def write_html(html, html_path):
    """Write HTML to the given path."""
    with html_path.open('w') as file:
        file.write(html)


def build_content(content_dir, template_file, output_dir):
    """Build site content."""
    template = create_template(template_file)
    for content_file in files(content_dir, '*.markdown',
                              label='Building content'):
        content = markdown_file_to_html(content_file)
        title = title_from_html(content)
        html = template.render(title=title, content=content, links=LINKS)
        html = minify(html, remove_optional_attribute_quotes=False)
        html_path = Path(output_dir,
                         content_file.name.replace('.markdown', '.html'))
        write_html(html, html_path)


def build_style(style_dir, output_dir):
    """Build style."""
    sass.compile(dirname=(style_dir, Path(output_dir, 'css')),
                 include_paths=(m.BASE_DIR for m in ASSET_MODULES),
                 output_style='compressed')


def build_script(script_dir, output_dir):
    """Build site script."""
    for script_file in files(script_dir, '*.js', label='Building scripts'):
        with script_file.open() as file:
            script = jsmin(file.read())
        script_path = Path(output_dir, 'js',
                           script_file.name.replace('.js', '.min.js'))
        with script_path.open('w') as file:
            file.write(script)


def asset_files(base_path, subdirs_to_ignore=()):
    """Iterate over asset files."""
    for path in base_path.iterdir():
        if path.is_dir():
            if path.name not in subdirs_to_ignore:
                yield from asset_files(path)
        else:
            yield path


def copy_assets(output_dir):
    """Copy assets from asset modules."""
    for base_dir in (Path(m.BASE_DIR) for m in ASSET_MODULES):
        for source_file in asset_files(base_dir,
                                       subdirs_to_ignore=('scss', 'less')):
            destination_file = Path(output_dir,
                                    source_file.relative_to(base_dir))
            # pylint: disable=no-member
            destination_file.parent.mkdir(parents=True, exist_ok=True)
            copy(source_file, destination_file)


def script_files(directory_name, *args, **kwargs):
    """Yield HTML files."""
    path = Path(directory_name)
    with click.progressbar(path.glob('*.html'), *args, **kwargs) as fnames:
        yield from fnames


def build_pdf(output_dir):
    """Build PDF versions of each content page."""
    for html_file in files(output_dir, '*.html', label='Building PDFs'):
        html = weasyprint.HTML(filename=html_file)
        pdf_path = Path(output_dir,
                        html_file.name.replace('.html', '.pdf'))
        html.write_pdf(pdf_path)


def update_cvs():
    """
    Update CVs on other sites.

    Advises user to do this manually.
    """
    msgs = (
        ('LinkedIn', 'https://www.linkedin.com/in/craigeanderson/'),
        ('Stack Overflow', 'https://stackoverflow.com/users/story/1852024'),
        ('YunoJuno', 'https://uk.yunojuno.com/profile/manage/'),
        (
            'DjangoGigs',
            'https://djangogigs.com/developers/craig-anderson2/',
        ),
        (
            'JobServe',
            'https://www.jobserve.com/gb/en/Candidate/MyProfile.aspx',
        ),
        ('Dice', ('https://uk.dice.com/dashboard/profiles/'
                  'cbe4c8e43cfb622cf97d86572860760e')),
        ('Honeypot', 'https://app.honeypot.io/profile'),
    )
    for title, url in msgs:
        template = ("I've you've updated your CV, maybe you should update {} "
                    "at {} too?")
        click.echo(template.format(title, url))


@click.command()
@click.option('--content_dir',
              default='content',
              type=click.Path(exists=True, file_okay=False),
              help='A directory containing Markdown files.')
@click.option('--style_dir',
              default='style',
              type=click.Path(exists=True, file_okay=False),
              help='A directory containing Sass files.')
@click.option('--script_dir',
              default='script',
              type=click.Path(exists=True, file_okay=False),
              help='A directory containing JavaScript files.')
@click.option('--template_file',
              default='template.html',
              type=click.File(),
              help='Template used to build the site.')
@click.option('--output_dir',
              default='docs',
              type=click.Path(writable=True, file_okay=False),
              help='Output directory.')
@click.option('--no-pdf', is_flag=True, help='Do not render PDFs.')
def build(**kwargs):
    """Build content for craiga.id.au from a series of Markdown files."""
    build_content(kwargs['content_dir'],
                  kwargs['template_file'],
                  kwargs['output_dir'])
    build_style(kwargs['style_dir'], kwargs['output_dir'])
    build_script(kwargs['script_dir'], kwargs['output_dir'])
    copy_assets(kwargs['output_dir'])
    if not kwargs['no_pdf']:
        build_pdf(kwargs['output_dir'])
    update_cvs()


if __name__ == '__main__':
    build()  # pylint: disable=no-value-for-parameter
