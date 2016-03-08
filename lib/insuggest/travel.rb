module Insuggest
  module Travel 
    attr_reader :attributes

    def initialize(attributes={})
      @attributes = attributes
    end

    def to_hash
      @attributes
    end

    module ClassMethods
      
      def get_index_name
        "travels"
      end

      def repository
        index_name = get_index_name
        Elasticsearch::Persistence::Repository.new do
          index index_name
          type :travel
        end
      end

      def search(days, age, size=100)
        self.repository.search({
          size: size,
          query: {
            bool: {
              must: [
                { match: { days: days } },
                { range: { from: { lte: age } } },
                { range: { to: { gte: age } } }
              ]
            }
          }
        })
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end
  end
end
