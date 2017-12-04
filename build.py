"""Build content for craiga.id.au from a series of Markdown files."""

from pathlib import Path

import click
import jinja2
import lxml.html
import sass
import shutil
import os
from xstatic.pkg import bootstrap_scss, font_awesome
from htmlmin import minify
from markdown import markdown


def create_template(template_file):
    """Create the Jinja2 template."""
    # Load the template.
    template_content = ''
    for line in template_file:
        template_content = template_content + line

    return jinja2.Template(template_content)


def markdown_files(directory_name, *args, **kwargs):
    """Yield markdown files."""
    path = Path(directory_name)
    with click.progressbar(path.glob('*.markdown'), *args, **kwargs) as fnames:
        yield from fnames


def markdown_file_to_html(file_path):
    """Convert the markdown file to HTML."""
    with file_path.open() as file:
        return markdown(file.read(),
                        extensions=('markdown.extensions.footnotes',))


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


def asset_files(base_path, subdirs_to_ignore=()):
    """Iterate over asset files."""
    for path in base_path.iterdir():
        if path.is_dir():
            if path.name not in subdirs_to_ignore:
                yield from asset_files(path)
        else:
            yield path


@click.command()
@click.option('--content_dir',
              default='content',
              type=click.Path(exists=True, file_okay=False),
              help='A directory containing Markdown files.')
@click.option('--style_dir',
              default='style',
              type=click.Path(exists=True, file_okay=False),
              help='A directory containing Sass files.')
@click.option('--template_file',
              default='template.html',
              type=click.File(),
              help='Template used to build the site.')
@click.option('--output_dir',
              default='docs',
              type=click.Path(writable=True, file_okay=False),
              help='Output directory. Where the HTML files will be written.')
def build(content_dir, style_dir, template_file, output_dir):
    """Build content for craiga.id.au from a series of Markdown files."""
    template = create_template(template_file)
    for content_file in markdown_files(content_dir, label='Building content'):
        content = markdown_file_to_html(content_file)
        title = title_from_html(content)
        html = template.render(title=title, content=content)
        html = minify(html, remove_optional_attribute_quotes=False)
        html_path = Path(output_dir,
                         content_file.name.replace('.markdown', '.html'))
        write_html(html, html_path)

    base_dirs = (bootstrap_scss.BASE_DIR, font_awesome.BASE_DIR)

    # Compile Sass stylesheets.
    sass.compile(dirname=(style_dir, Path(output_dir, 'css')),
                 include_paths=base_dirs,
                 output_style='compressed')

    # Copy required static assets.
    asset_subdirs_to_ignore = ('scss', 'less')
    for base_dir in (Path(d) for d in base_dirs):
        for source_file in asset_files(base_dir,
                                       subdirs_to_ignore=('scss', 'less')):
            destination_file = Path(output_dir,
                                    source_file.relative_to(base_dir))
            destination_file.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy(source_file, destination_file)


if __name__ == '__main__':
    build()  # pylint: disable=no-value-for-parameter
