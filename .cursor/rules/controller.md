---
description: Controller authentication rule
globs:
alwaysApply: true
---

- A Rails controller action that is publicly available is written like this (example) :

```ruby
  grant_access action: :new
  # @route GET /sign_in (sign_in)
  def new
  end
```

- A Rails controller that is retricted to a certain group is written like this (example) :

```ruby
  require_auth action: new
  grant_access action: :new, roles: [ :members ]
  # @route GET /sign_in (sign_in)
  def new
  end
```
