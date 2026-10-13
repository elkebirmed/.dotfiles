# Mohamed Dotfiles

The Ansible playbook configures the system and the current user's Git defaults.
Set `git_user_name` and `git_user_email` in `group_vars/all/` or
`host_vars/<host>/` to configure the global Git author identity. They are
intentionally blank by default, so an existing identity is left unchanged.
`git_default_branch` defaults to `main`.

Run only the Git role with `./install --tags git`.

The roles selected for a playbook run are configured in
`group_vars/all/roles.yml`. Remove a role name from `default_roles` to disable
it by default, add role entries to `additional_roles`, or list role names in
`excluded_roles` to skip defaults for a machine. Additional role entries use
the same format as `default_roles`, for example:

```yaml
additional_roles:
  - role: shell
    tags: [shell]
```

Role variables can be overridden in `host_vars/<host>/roles.yml` to customize
the role set for one machine.
