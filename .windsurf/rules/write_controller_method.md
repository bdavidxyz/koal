---
applyTo: "**/*"
globs: ["**/*"]
trigger: always_on
description: "Rules about generating controllers actions"
---

1. If you need to write a controller action, always use the `run_service` method to execute the service.
2. Always use the `grant_access` method to grant access to the controller action.
3. Always use the run_service method to execute the service. If you are in doubt, use the app/controllers/soccer_odds_controller.rb#show_tip method as a reference.
4. Always use the @result.data in the view.
5. The corresponding service uses the servus gem, whose docs are here https://zarpay.github.io/servus and repo is here https://github.com/zarpay/servus. In case of doubt, use app/services/soccer_odds/show_tip.rb as a reference.
6. Inside the controller, use the run_service method as described here https://zarpay.github.io/servus/rails/controllers
7. Servus is able to map errors to HTTP codes, so no error-specific stuff is needed in the controller. Use https://zarpay.github.io/servus/core/responses#error-types
8. Use the inline schema directly in the class as described here : https://zarpay.github.io/servus/features/schema-validation#_1-the-schema-dsl-recommended. Look at app/services/soccer_odds/show_tip.rb as a reference in case of doubt.
9. Use dry-initializer for the service class constructor, as described here : https://dry-rb.org/gems/dry-initializer/3.1/; I don't want initialize method inside service class.Look at app/services/soccer_odds/show_tip.rb as a reference in case of doubt.
10. Write unit test under test/services/{service_name}/service_test.rb, in case of doubt, look at test/services/soccer_odds/show_tip/service_test.rb as an example
11. Use NotFoundError from Servus::Support::Errors for not found errors, if you need another kind of error, use the appropriate error from Servus::Support::Errors, that you can find under the servus gem at servus/lib/servus/support/errors.rb. See how to use it inside app/services/soccer_odds/show_tip.rb for example.
12. Use a super-clear separation of concern. The underlying service should not be aware of routes, flash, session, etc, everything that is controller-related.
13. The text message passed to the flash is the problem of the controller, not the service.
