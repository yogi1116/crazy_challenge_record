module PostModerationConcern
  extend ActiveSupport::Concern

  def post_invalid
    if @post.invalid?
      flash.now[:error] = t('.fail')
      render :new, status: :unprocessable_entity
    end
  end

  def content_moderated(post)
    full_text = generate_full_text(post)
    if content_moderated?(full_text)
      flash.now[:error] = moderation_message
      render :new, status: :unprocessable_entity
      return true
    end
    false
  end

  def generate_full_text(post)
    [
      post.title,
      post.content,
      post.record,
      post.impression_event,
      post.lesson
    ].join("\n")
  end

  def challenge_post_invalid
    if @challenge_post.invalid?
      flash.now[:error] = t('.fail')
      render :new, status: :unprocessable_entity
    end
  end

  def challenge_content_moderated(challenge_post)
    full_text = challenge_generate_full_text(challenge_post)
    if content_moderated?(full_text)
      flash.now[:error] = moderation_message
      render :new, status: :unprocessable_entity
      return true
    end
    false
  end

  def challenge_generate_full_text(challenge_post)
    [
      challenge_post.title,
      challenge_post.content
    ].join("\n")
  end

  def content_moderated?(full_text)
    moderation_service = ContentModerationService.new(full_text)
    result = moderation_service.analyze
    categories = result['moderationCategories'].to_a
    @high_confidence_categories = categories.select { |category| category['confidence'] > 0.8 }
    @high_confidence_categories.any?
  end

  def moderation_message
    inappropriate_content = @high_confidence_categories.map { |category| t("moderation_categories.#{category['name']}") }.join('・ ')
    "不適切なコンテンツが含まれています：#{inappropriate_content}"
  end

  def handle_content_analysis_error(e)
    logger.error(e.message)
    flash.now[:error] = 'Content analysis failed.'
    render :new, status: :unprocessable_entity
  end
end