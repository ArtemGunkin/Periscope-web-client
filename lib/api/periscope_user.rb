module Api
  class PeriscopeUser < OpenStruct
    def method_missing(method, *arguments, &block)
      api_method = "is_#{method.to_s.chomp('?')}"
      if respond_to?(api_method)
        send(api_method)
      else
        super
      end
    end

    def image_path
      profile_image_urls[0]['url']
    end

    def created
      Time.new(:created_at.to_s) if :created_at
    end

    def updated
      Time.new(:updated_at.to_s) if :updated_at
    end

    def hearts
      helper.number_with_delimiter(n_hearts, delimiter: ' ')
    end

    def following
      number_to_human(n_following)
    end

    def followers
      number_to_human(n_followers)
    end

    def helper
      @helper ||= Class.new do
        include ActionView::Helpers::NumberHelper
      end.new
    end

    def number_to_human(number)
      helper.number_to_human(number, precision: 2, format: '%n%u', units: { thousand: 'K', million: 'M' })
    end

  end
end