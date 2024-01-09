# Work Log

...


## 2023-08-28: _Initial Development Sprint_

- Added application roles (browsers, utilities, editors)
- Standardized installs to download-based method
- Implemented and refined configuration templates (including OpenSSL)
- Minor playbook fixes and auto-commit verification


## 2023-08-28 [(code)](https://github.com/amindeed/Ansible-Win-AutoProvisioning/commit/99371dd1c13e999d2a0a1e4dc23b8a469606ccfd)

- Initial project structure with Ansible best practices for Windows provisioning.
- Created core directory structure:
    - `inventories/environments/` - Environment-specific inventory files.
    - `playbooks/bundles/core/` - Main playbook and roles.
    - `vaults/` - Ansible Vault encrypted variables.
- Initial roles created:
    - `_role-template_` - Base template for generating new roles.
    - `setup-7zip` - 7-Zip installation role.
    - `setup-keepass` - KeePass installation role.
    - `setup-openssl` - OpenSSL installation role with post-install configuration.
    - `setup-firefox__DRAFT` - Firefox installation (draft).
- Created Jinja2 templates for:
    - `installation.yml.j2` - Generic software installation tasks.
    - `configuration.yml.j2` - Post-installation configuration tasks.
- Development inventory (`dev.yml`) with WinRM connection settings.