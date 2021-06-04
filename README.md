# Redmine Lifecycle Bot

This script implements issue lifecycle management for redmine.
It's inspired by the kubernetes fetja-bot.

The bot is enabled on a per project basis by adding it's api-key owner
as a member.

It is recommended to use a dedicated user and api-key.

The bot can then be run once per day from a cronjob.

It then takes redmine issues in that project through a lifecycle like the following:

- after 90 days of inactivity: mark as stale
- after another 30 days of inactivity:
   - if marked as stale, mark as rotten
   - if marked as rotten, close


## Requirements

### Custom field

Create a custom field in redmine with the following properties:

```
Format: List
Name: Lifecycle (or whatever you like)
Possible values: '', 'stale', 'rotten', 'frozen'
Used as a filter: True
```

### API key with admin privileges

You need the API key of a user that has admin privileges.



## Usage

### Enable

The Bot is enabled for a project by adding the User owning the API key
as a member.


### Run

```
redmine-lifecycle-bot \
  --verbose \
  --dry-run \
  --url https://redmine.example.com \
  --api-key your-api-key \
  --lifecycle-field-id 42
```


