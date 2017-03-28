# VVV API-API Setup

Sets up the API-API development environment on VVV.

Requires VVV 2.0

## Instructions

Add something like this to your `vvv-custom.yml` (if you don't have this file, duplicate and rename `vvv-config.yml` accordingly):

```
api-api-develop:
  repo: git@github.com:api-api/vvv-api-api-setup.git
  hosts:
    - api-api.dev
```

After setting this up, start your VVV instance and call `vagrant provision --provision-with site-api-api-develop`.
