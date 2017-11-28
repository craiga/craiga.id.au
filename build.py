"""Build content for craiga.id.au from a series of Markdown files."""

from pathlib import Path

import click
import jinja2
from lxml import html
from markdown import markdown


def markdown_files(directory_name, *args, **kwargs):
    """Yield markdown files."""
    path = Path(directory_name)
    with click.progressbar(path.glob('*.markdown'), *args, **kwargs) as fnames:
        yield from fnames


@click.command()
@click.option('--content',
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
def build(content, template_file, output_dir):
    """Build content for craiga.id.au from a series of Markdown files."""
    # Load the template.
    template_html = ''
    for template_line in template_file:
        template_html = template_html + template_line

    template = jinja2.Template(template_html)

    # For each Markdown file…
    for content_file in markdown_files(content, label='Building site'):
        # …convert to HTML…
        content_markdown = ''
        with content_file.open() as content_file_obj:
            content_markdown = content_file_obj.read()

        content_html = markdown(content_markdown)

        # …get title…
        html_tree = html.fromstring(content_html)
        headings = html_tree.xpath('//h1/text()')
        if headings:
            title = headings[0]
        else:
            title = ''

        # …process through the template…
        html_stream = template.stream(title=title, content=content_html)

        # …and write the HTML file.
        html_file_path = Path(output_dir,
                              content_file.name.replace('.markdown', '.html'))
        html_stream.dump(str(html_file_path))


if __name__ == '__main__':
    build()  # pylint: disable=no-value-for-parameter
