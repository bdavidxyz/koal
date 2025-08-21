class ChroniclesController < ApplicationController
  include Pagy::Backend

  skip_authorization


  # @route GET /chronicles (chronicles)
  def index
    sort = {}
    if params[:sort] && params[:direction]
      sort[params[:sort]] = params[:direction]
    else
      sort[:published_at] = "desc"
    end
    scope = Chronicle.where("published_at IS NOT NULL AND published_at <= ?", Time.current).order(sort)
    chronicles = params[:q].present? ? Fuzzy::Search.new(scope, Chronicle, params[:q]).run : scope
    @pagy, @chronicles = pagy(chronicles, limit: 10)
  end

  # @route GET /chronicles/:slug
  def show
    @chronicle = retrieve_chronicle
  end

  private

  def retrieve_chronicle
    chronicle = Chronicle.find_by(slug: params[:slug])
    if chronicle.nil? || chronicle.published_at.nil? || chronicle.published_at > Time.current
      not_found
    else
      chronicle
    end
  end

end
