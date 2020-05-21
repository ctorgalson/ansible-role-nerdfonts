import os

import testinfra.utils.ansible_runner

import pytest


testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


"""
ansible-role-nerdfonts (ctorgalson.nerdfonts) Default scenario tests.

Notes:

  - We are only testing Linux-based systems here (and in Molecule generally).
  - We should be testing the group of the created directory and downloaded
    files. But trying to keep a local molecule instance and github action
    environment in sync makes this a bit tedious.
"""


def test_local_share_fonts_directory(host):
    u = 'molecule'
    f = host.file('/home/{}/.local/share/fonts/NerdFonts'.format(u))

    assert f.exists
    assert f.is_directory
    assert f.user == u
    """ assert f.group == u """


@pytest.mark.parametrize('font', [
    'UbuntuMono/Ubuntu Mono Nerd Font Complete.ttf',
    'AurulentSansMono/AurulentSansMono-Regular Nerd Font Complete.otf',
])
def test_local_share_font_files(host, font):
    u = 'molecule'
    f = host.file('/home/{}/.local/share/fonts/NerdFonts/{}'.format(u, font))

    assert f.exists
    assert f.is_file
    assert f.user == u
    """ assert f.group == u """
