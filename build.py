"""Build content for craiga.id.au from a series of Markdown files."""

from pathlib import Path

import click
import jinja2
import lxml.html
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


@click.command()
@click.option('--content_dir',
              default='content',
              type=click.Path(exists=True, file_okay=False),
              help='A directory containing Markdown files.')
@click.option('--template_file',
              default='template.html',
              type=click.File(),
              help='Template used to build the site.')
@click.option('--output_dir',
              default='docs',
              type=click.Path(writable=True, file_okay=False),
              help='Output directory. Where the HTML files will be written.')
def build(content_dir, template_file, output_dir):
    """Build content for craiga.id.au from a series of Markdown files."""
    template = create_template(template_file)
    for content_file in markdown_files(content_dir, label='Building site'):
        content = markdown_file_to_html(content_file)
        title = title_from_html(content)
        html = template.render(title=title, content=content)
        html = minify(html, remove_optional_attribute_quotes=False)
        html_path = Path(output_dir,
                         content_file.name.replace('.markdown', '.html'))
        write_html(html, html_path)


if __name__ == '__main__':
    build()  # pylint: disable=no-value-for-parameter
