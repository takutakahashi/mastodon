# frozen_string_literal: true

class FollowRecommendationFilter
  KEYS = %i(
    language
    status
  ).freeze

  attr_reader :params, :language

  def initialize(params)
    @language = params.delete('language') || I18n.locale
    @params   = params
  end

  def results
    if params['status'] == 'suppressed'
      Account.where(id: FollowRecommendationSuppression.all)
    else
      Account.where(id: Redis.current.zrevrange("follow_recommendations:#{@language}", 0, -1))
    end
  end
end
