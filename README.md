Automate the provisioning, configuration, and management of Windows environments using Ansible.

This repository provides a minimalist solution to streamline software installation, system configuration, and feature enablement for Windows systems. It deliberately avoids Chocolatey dependencies in favor of native toolings.

The repository features an opinionated Ansible Windows playbook structure, centralizing all configurable parameters at the playbook/inventory level, exposing settings for complete visibility and control.
   
**Check [`worklog.md`](worklog.md) for more details.**

## 1. Playbook Execution Flow

![playbook_execution_flow.png](assets/playbook_execution_flow.png)

## 2. Role Template (`operations.yml.j2`) Decision Tree

![role_template_decision_tree.png](assets/role_template_decision_tree.png)

## 3. Bundled Content Structure

![bundled_content_structure.png](assets/bundled_content_structure.png)

## 4. Bundled Content Naming Conventions

![bundled_content_naming_conventions.png](assets/bundled_content_naming_conventions.png)
