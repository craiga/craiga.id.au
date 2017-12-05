"""Build content for craiga.id.au from a series of Markdown files."""

from pathlib import Path
from shutil import copy

import click
import jinja2
import lxml.html
import sass
from htmlmin import minify
from markdown import markdown
from jsmin import jsmin
from xstatic.pkg import bootstrap_scss, font_awesome, jquery


ASSET_MODULES = (bootstrap_scss, font_awesome, jquery)


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


def build_content(content_dir, template_file, output_dir):
    """Build site content."""
    template = create_template(template_file)
    for content_file in markdown_files(content_dir, label='Building content'):
        content = markdown_file_to_html(content_file)
        title = title_from_html(content)
        html = template.render(title=title, content=content)
        html = minify(html, remove_optional_attribute_quotes=False)
        html_path = Path(output_dir,
                         content_file.name.replace('.markdown', '.html'))
        write_html(html, html_path)


def build_style(style_dir, output_dir):
    """Build style."""
    sass.compile(dirname=(style_dir, Path(output_dir, 'css')),
                 include_paths=(m.BASE_DIR for m in ASSET_MODULES),
                 output_style='compressed')


def script_files(directory_name, *args, **kwargs):
    """Yield script files."""
    path = Path(directory_name)
    with click.progressbar(path.glob('*.js'), *args, **kwargs) as fnames:
        yield from fnames


def build_script(script_dir, output_dir):
    """Build site script."""
    for script_file in script_files(script_dir, label='Building scripts'):
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
              help='Output directory. Where the HTML files will be written.')
def build(content_dir, style_dir, script_dir, template_file, output_dir):
    """Build content for craiga.id.au from a series of Markdown files."""
    build_content(content_dir, template_file, output_dir)
    build_style(style_dir, output_dir)
    build_script(script_dir, output_dir)
    copy_assets(output_dir)


if __name__ == '__main__':
    build()  # pylint: disable=no-value-for-parameter
