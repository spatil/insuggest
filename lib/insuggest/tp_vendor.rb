module Insuggest
  module TpVendor 
    attr_reader :attributes

    def initialize(attributes={})
      @attributes = attributes
    end

    def to_hash
      @attributes
    end

    module ClassMethods
      
      def get_index_name
        "tp_vendors"
      end

      def repository
        index_name = get_index_name
        Elasticsearch::Persistence::Repository.new do
          index index_name
          type :tp_vendor
        end
      end

      def search(query=[], size= 100)
        self.repository.search({
          size: size,
          query: {
            bool: {
              must: [
                { match: { category: query[0] } },
                { match: { sub_category: query[1] } },
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
