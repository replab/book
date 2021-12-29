# -*- coding: utf-8 -*-

##
## Sphinx configuration file
##

import os
from pathlib import Path

##
## Project data
##

project = 'replab-book'
copyright = '2018-2021, Denis Rosset, Jean-Daniel Bancal and collaborators'
author = 'Denis Rosset, Jean-Daniel Bancal and collaborators'
version = Path('../version.txt').read_text().strip()
release = version
html_title = 'The RepLAB Handbook'
html_base_url = 'https://replab.github.io/book/'

##
## Extensions
##

extensions = [
    'sphinx.ext.githubpages', # creates a .nojekyll file to publish on GitHub
    'myst_nb',                # support for Myst files
    'sphinxcontrib.bibtex',   # academic references
    'sphinx_togglebutton',    # toggle
    'sphinxcontrib.matlab',   # support for Matlab
    'sphinx.ext.mathjax',     # LaTeX support
    'texext.math_dollar',     # lightweight LaTeX filter
    'sphinx.ext.intersphinx', # cross references
]

##
## Misc settings
##

templates_path = ["_templates"]
primary_domain = 'mat'
default_role = 'obj'
source_suffix = '.rst'
master_doc = 'index'
language = None
exclude_patterns = ['_build', 'Thumbs.db', '.DS_Store', '**.ipynb_checkpoints', '**_source.ipynb', '_src']
pygments_style = 'sphinx'

##
## sphinxcontrib.bibtex
##

bibtex_bibfiles = ['refs.bib']

##
## sphinx.ext.intersphinx
##

intersphinx_mapping = {'api': ('https://replab.github.io/api', None)}
intersphinx_cache_limit = -1 # always fetch the latest version
intersphinx_timeout = 10 # timeout so we don't wait indefinitely if the website is unavailable

##
## Myst / notebook execution
##

nb_merge_streams = True
jupyter_execute_notebooks = "cache"
execution_timeout = 120

##
## HTML template
##

import guzzle_sphinx_theme

html_show_sourcelink = True

html_theme_path = guzzle_sphinx_theme.html_theme_path()
html_theme = 'guzzle_sphinx_theme'

# Register the theme as an extension to generate a sitemap.xml
extensions.append("guzzle_sphinx_theme")

html_static_path = ['_static']

# Guzzle theme options (see theme.conf for more information)
html_theme_options = {
    # Set the name of the project to appear in the sidebar
    "project_nav_name": html_title,
    "base_url": html_base_url
}

html_css_files = [
    'css/custom.css',
    'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.11.2/css/all.min.css'
]

html_js_files = [
    'js/collapse_helper.js',
]

html_sidebars = {
    '**': ['logo-text.html', 'globaltoc.html']
}
