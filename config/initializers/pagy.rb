# Pagy initializer file

# Require the overflow extra for handling pagination overflow
require "pagy/extras/overflow"

# Set the default overflow behavior to :last_page
# This will automatically redirect to the last page when requesting a page beyond the available pages
Pagy::DEFAULT[:overflow] = :last_page
