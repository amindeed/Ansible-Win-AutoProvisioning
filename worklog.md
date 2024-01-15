# Work Log

## 2024-01-15

- Update `worklog.md` with older entries.
- Minor changes/fixes in playbook files (core and basic)
- A few testing rounds (filtering with tags, profiling on/off...).
- Preparing for MS Office 2016 setup test.


## 2024-01-09 [(code)](https://github.com/amindeed/Ansible-Win-AutoProvisioning/tree/2b5555b73307eea55f2cf5d486d91f9a6b09d6a2)

- Refined Core playbook (`playbooks/core_bundle_win.yml`): removed a couple of Notepad++ plugins.
- Some restructuring, testing (with upgraded collections: `ansible.windows:==2.2.0` and `community.windows:==2.1.0`).

...

---------------------------

...

## 2023-11-07

- Enhanced Node.js installation to properly set `NODEJS_HOME` environment variable ([`affae3c`](https://github.com/amindeed/Ansible-Win-AutoProvisioning/commit/affae3c95cc61d786ff167985a83c39cab6fbe3b)).
- Removed `EXEC__set_NODEJS_HOME.vbs` (replaced with PowerShell-based solution).
- Added `finalize-system` role with:
    - PATH environment variable setup.
    - `starter.ps1` for post-installation tasks.
- Added `set_JAVA_HOME.ps1` PowerShell script ([`ccbb2cb`](https://github.com/amindeed/Ansible-Win-AutoProvisioning/commit/ccbb2cb648a671780f0114a4360acf34fd081226)).


## 2023-11-05

- Added support for checking installed software.
- Enhanced `core_bundle.yml` with additional software configurations.


## 2023-11-02 [(code)](https://github.com/amindeed/Ansible-Win-AutoProvisioning/commit/8ae89672bcbdfe9dee8f9d665294ed6b9df72ef2)

- Resolved Ansible version compatibility issues.
- Major cleanup: Removed 185 generated role files (consolidating to dynamic template generation).
- Kept only essential role templates.


## 2023-11-01 [(code)](https://github.com/amindeed/Ansible-Win-AutoProvisioning/commit/a5918b418200b569927e0f13af3ebad95b2e246a)

- Restored `ansible.cfg` configuration.
- Generated all software installation roles from templates:
    - 7-Zip, Adobe Reader, Beyond Compare, Dependency Walker, Draw.io, Firefox, Greenshot, KDiff3, KeePass, Keystore Explorer, MarkText, MS Office, Notepad++, OpenSSL, Pandoc, Regshot, Sysinternals, TreeSize, VS Code.
- Added `init-system` role for initial system setup.


## 2023-10-23 [(code)](https://github.com/amindeed/Ansible-Win-AutoProvisioning/commit/323f1f654ed9523e61fefa0a74474dcc56ef4c39)

- Removed authentication requirement check for file downloads (simplified approach).
- Created `AWAP.Modules` PowerShell module:
    - Provides helper functions for Ansible tasks.
- Added utility scripts:
    - `EXEC_PS1_SCRIPTS.vbs`: VBScript wrapper for PowerShell execution.
    - `win_reg_str2hex.ps1`: Convert registry strings to hex format.
    - `IsAscii.ps1`, `IsBinary.ps1`: File type detection utilities.


## 2023-10-17 [(code)](https://github.com/amindeed/Ansible-Win-AutoProvisioning/commit/252b48c746be4cd60457f3c8fcd50f3e68c3d4e9)

- Added option to ignore SSL certificate checks for downloads (for internal/self-signed certificates).
- Added Windows Server 2012 development inventory (`dev_2012.yml`).
- Bundled Ansible collections locally:
    - `ansible-windows-2.1.0.tar.gz`
    - `community-windows-2.0.0.tar.gz`


## 2023-10-06 [(code)](https://github.com/amindeed/Ansible-Win-AutoProvisioning/commit/51da034400d14d589567382761e56615c4be476d)

- Created `core_bundle.yml` for "core" software installations (development tools, runtimes).
- Added many new roles:
    - Cygwin, DBeaver, Git Extensions, Maven
    - Node.js (multiple versions: 14, 16, 18)
    - OpenJDK (multiple versions: 8, 11, 17)
    - Python (versions 2 and 3)
    - UML Designer
- Enhanced `operations.yml.j2` template with additional installation methods.


## 2023-10-01 [(code)](https://github.com/amindeed/Ansible-Win-AutoProvisioning/commit/6f9bae462572ba5d7a26923fa00bd26342d0c0ba)

Template consolidation:
- Created unified `operations.yml.j2` template file that combines:
    - Checks (`checks.yml.j2`)
    - Configurations (`configurations.yml.j2`)
    - Executions (`executions.yml.j2`)
    - Installations (`installations.yml.j2`)
- This simplifies the template structure and makes it easier to add new operation types.
- Removed Node.js version-specific roles (14, 16, 18); will be handled dynamically.


## 2023-09-27 [(code)](https://github.com/amindeed/Ansible-Win-AutoProvisioning/commit/37e1f99e5e4c788d7c330114e846156720af531a)

- Added example MS Office `Config.xml` content in `main.yml`.
- Created roles for 20+ software packages using the template system:
    - 7-Zip, Adobe Reader, Beyond Compare, Dependency Walker, Draw.io, Firefox, Greenshot, KDiff3, KeePass, Keystore Explorer, MarkText, MS Office, Notepad++, OpenSSL, Pandoc, Regshot, Sysinternals, TreeSize, VS Code...
- Each role includes:
    - `01_pre-setup.yml`, `02_setup.yml`, `03_post-setup.yml` tasks.
    - Template files for checks, configurations, executions, and installations.


## 2023-09-26 [(code)](https://github.com/amindeed/Ansible-Win-AutoProvisioning/commit/51a9e3b8daca05c3380fe55c1f32e039405f3a84)

- Created MS Office KMS activation script (`ms-office-kms-activate.ps1`).
- Significantly enhanced Jinja2 templates:
    - `checks.yml.j2`: Pre-installation checks.
    - `configurations.yml.j2`: Post-installation configuration.
    - `executions.yml.j2`: Script execution handling.
    - `installations.yml.j2`: Software installation logic (MSI, EXE, ZIP).
- Added test playbook (`test.yml`) for template validation.
- Added sample Notepad++ plugins as test uploads.


## 2023-09-15 [(code)](https://github.com/amindeed/Ansible-Win-AutoProvisioning/commit/5b48ca84cbae83470719eb81874dccddbeb36721)

Major project restructuring:
- Moved from `playbooks/bundles/core/` structure to `playbooks/roles/` (flatter, simpler).
- Created unified role template structure:
    - `_role-template_/` as the base template for all roles.
    - Tasks split into phases: `01_pre-setup.yml`, `02_setup.yml`, `03_post-setup.yml`.
- Added helper scripts:
    - `gen_roles.sh` - Generate new roles from template.
    - `del_roles.sh` - Delete generated roles.
- Added utility tools:
    - `activate_office.ps1` - MS Office activation helper.
    - `check_software_installed.ps1` - Verify software installation status.
- Created MS Office installation tasks with pre-setup checks and post-setup configuration.


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