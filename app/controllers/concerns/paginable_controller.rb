module PaginableController
  extend ActiveSupport::Concern

  included do
    # Handle Pagy overflow errors by redirecting to the last page
    rescue_from Pagy::OverflowError, with: :redirect_to_last_page
  end

  private

  # Redirect to the last valid page when a Pagy::OverflowError occurs
  # :nocov:
  def redirect_to_last_page(exception)
    redirect_to url_for(page: exception.pagy.last), notice: "Page ##{params[:page]} is overflowing. Showing page #{exception.pagy.last} instead."
  end
  # :nocov:
end
