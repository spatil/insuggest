module Insuggest
  module Gcv
    module Discount
      def initialize(attributes={})
        @attributes = attributes
      end

      def to_hash
        @attributes
      end
      
      module ClassMethods 

        def get_index_name
          "gcv_discounts"
        end
        
        def repository
          index_name = get_index_name
          Elasticsearch::Persistence::Repository.new do
            index index_name
            type :discount
            settings number_of_shards: 2 
          end
        end

        def search(age=1, capacity=0, size: 100)
          self.repository.search({
            size: size,
            query: {
              bool: {
                must: [
                  { range: {capacity_from: {lte: capacity}}},
                  { range: {capacity_to: {gte: capacity}}},
                  { range: {from: {lte: age}}},
                  { range: {to: {gte: age}}}
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
end
