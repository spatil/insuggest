module Insuggest
  module TpDecline
    attr_reader :attributes

    def initialize(attributes={})
      @attributes = attributes
    end

    def to_hash
      @attributes
    end

    module ClassMethods
      
      def get_index_name
        "tp_declines"
      end

      def repository
        index_name = get_index_name
        Elasticsearch::Persistence::Repository.new do
          index index_name
          type :tp_decline
        end
      end

      def search(query={}, size= 100)
        self.repository.search({
          size: size,
          query: {
            bool: {
              must: [
                { match: { make: query[:car_make] } },
                { match: { model: query[:car_model] } },
              ]
            }
          }
        })[0]
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end
  end
end
