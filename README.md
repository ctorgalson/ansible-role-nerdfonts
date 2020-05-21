# Ansible Role NerdFonts

![](https://github.com/ctorgalson/ansible-role-nerdfonts/workflows/Molecule%20Test/badge.svg)

An Ansible role for installing [Nerd Fonts](https://www.nerdfonts.com/) on Linux and macOS.

In the current iteration, downloads individual font files directly from Github,
but does not clone the repository (because it's enormous!)

## Requirements

No special requirements.

## Role Variables

| Variable name                 | Default value | Description |
|-------------------------------|---------------|-------------|
| `nf_user`                     | `''`            | The name of the user to install the fonts for. Required. |
| `nf_group`                    | `not set`            | The group of the user to install the fonts for. Required. |
| `nf_linux_fonts_dir`          | `/home/{{ nf_user }}/.local/share/fonts/NerdFonts` | The default location to install fonts on Linux systems. |
| `nf_macos_fonts_dir`          | `/Users/{{ nf_user }}/Library/Fonts` | The default location to install fonts on macOS systems. |
| `nf_github_raw_patched_fonts` | `https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts` | The remote directory from which to download raw font files. |
| `nf_single_fonts`             | `[]` | A list of paths to individual fonts to download, relative to `nf_github_raw_patched_fonts` (see Example Playbook below). Required. |

## Dependencies

No special dependencies.

## Example Playbook

    ---
    - name: Ansible Role NerdFonts sample playbook.
      hosts: all
      vars:
        nf_user: "molecule"
        nf_group: "{{ nf_user }}"
        nf_single_fonts:
         - "UbuntuMono/Regular/complete/Ubuntu Mono Nerd Font Complete.ttf"
         - "AurulentSansMono/complete/AurulentSansMono-Regular Nerd Font Complete.otf"
      tasks:
        - name: "Include ansible-role-nerdfonts"
          include_role:
            name: "ansible-role-nerdfonts"

## License

GPLv3
