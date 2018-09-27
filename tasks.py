# coding=utf-8
"""
This is a tasks file used with "invoke" (similar to a Makefile).
See http://www.pyinvoke.org/ for info.

To list tasks:

    invoke -l

"""
import datetime
from contextlib import contextmanager
from pathlib import Path

from invoke import task

__author__ = 'Sam Hartsfield'

DEFAULT_BUILD_TYPE = 'vmware-iso'

# Tells packer not to wipe the VM if the build fails, so you have a chance to
# inspect it and figure out what went wrong.
DEFAULT_ON_ERROR = 'abort'


@contextmanager
def timer():
    start = datetime.datetime.now()
    print("Start time:", start.isoformat(' '))
    try:
        yield
    finally:
        end = datetime.datetime.now()
        print("End time:", end.isoformat(' '))
        print("Elapsed time:", end - start)


@task(help={'filename': "YAML input"})
def generate_template(c, filename):
    """
    Generate Packer JSON file(s) from more-human-readable YAML file(s).
    """
    import json
    from ruamel.yaml import YAML
    yaml = YAML(typ='rt')

    with open(filename) as f:
        config_dict = yaml.load(f)

    json_filename = Path(filename).stem + '.json'

    with open(json_filename, 'w') as json_file:
        print(f"Generating '{json_filename}' (from {filename})")
        json.dump(config_dict, json_file, indent=2)


BUILD_HELP = {
    'filename': "JSON template filename to build (e.g. 'centos7.json')",
    'generate': "Regenerate the JSON file from YAML",
    'build-type': "vmware-iso or virtualbox-iso (Packer '-only' option)",
    'on-error': "Same as Packer option of the same name [cleanup|abort|ask]",
}


@task(help=BUILD_HELP)
def build(c, filename, generate=True, build_type=DEFAULT_BUILD_TYPE, on_error=DEFAULT_ON_ERROR):
    """
    Build a given template (JSON file) with Packer.
    """
    if generate:
        generate_template(c, Path(filename).stem + '.yaml')
    with timer():
        c.run(f"packer build --only={build_type} --on-error={on_error} {filename}",
              env={
                  'PACKER_LOG': '1',
                  'PACKER_LOG_PATH': 'packer.log'
              })


@task(help=BUILD_HELP)
def centos7(c, generate=True, build_type=DEFAULT_BUILD_TYPE, on_error=DEFAULT_ON_ERROR):
    """
    Build CentOS7.
    """
    build(c, 'centos7.json', generate=generate, build_type=build_type, on_error=on_error)
