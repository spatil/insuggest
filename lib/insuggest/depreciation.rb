module Insuggest
  module Depreciation
    attr_reader :attributes

    def initialize(attributes={})
      @attributes = attributes
    end

    def to_hash
      @attributes
    end

    module ClassMethods 
      
      def get_index_name
        "depreciations"
      end

      def repository
        index_name = get_index_name
        Elasticsearch::Persistence::Repository.new do
          index index_name
          type :depreciation
          settings number_of_shards: 4 do
            mapping do
              indexes :suggest_make,  type: 'completion',
                              payloads: true,
                              index_analyzer: "simple",
                              search_analyzer: "simple"
              indexes :suggest_model, type: 'completion',
                              payloads: true,
                              index_analyzer: "simple",
                              search_analyzer: "simple"
            end
          end
        end
      end

      def search(query=[], size= 100, age=1, percent)
        self.repository.search({
          size: size,
          query: {
            bool: {
              must: [
                {
                  match: { "make.raw" => query[0] }
                },
                {
                  match: { "model.raw" => query[1] }
                },
                {
                  match: { "submodel.raw" => query[2] }
                }
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
