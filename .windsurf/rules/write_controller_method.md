---
applyTo: "**/*"
globs: ["**/*"]
trigger: always_on
description: "Rules about generating controllers actions"
---

1. Always use the `grant_access` method to grant access to the controller action, see existing actions like app/controllers/sessions_controller.rb#create
2. Each controller action should use a service. The corresponding service uses the servus gem, whose docs are here https://zarpay.github.io/servus and repo is here https://github.com/zarpay/servus. In case of doubt, use app/services/soccer_odds/show_tip.rb as a reference.
3. If you need to write a controller action that is not empty, always go through the service layer. Look at app/services/sessions/create/service.rb as an example, and it's used here : app/controllers/sessions_controller.rb#create
4. Never use the run_service method to execute the service. If you are in doubt, use the app/controllers/sessions_controller.rb#create method as a reference.
5. Always use the @result.data in the view when you need to display data from the service.
6. Servus is able to map errors to HTTP codes, so don't prefix errors with Servus::Support::Errors::AuthenticationError, just use the error name directly like AuthenticationError
7. Use instance variable to initialize vars inside the service, and avoid attr_reader.
8. Write unit test under test/services/{service_name}/service_test.rb
9. Use NotFoundError from Servus::Support::Errors for not found errors, if you need another kind of error, use the appropriate error from Servus::Support::Errors, that you can find under the servus gem at servus/lib/servus/support/errors.rb.
10. Pass everything needed to the service, wether it's Current.user, cookies, session, flash, etc. Only the params should be unwrapped first.
11. The controller is finally responsible of where to redirect, render, content of flash message, etc; depending on result.success? most of the time. See what already exist in the codebase.
