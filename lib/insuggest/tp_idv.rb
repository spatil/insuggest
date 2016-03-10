module Insuggest
  module TpIdv 
    attr_reader :attributes

    def initialize(attributes={})
      @attributes = attributes
    end

    def to_hash
      @attributes
    end

    module ClassMethods
      
      def get_index_name
        "idvs"
      end

      def repository
        index_name = get_index_name
        Elasticsearch::Persistence::Repository.new do
          index index_name
          type :idv
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
              indexes :suggest_submodel, type: 'completion',
                payloads: true,
                index_analyzer: "simple",
                search_analyzer: "simple"
            end
          end
        end
      end

      def search(query=[], size= 100, age=1, percent)
        conditions = [
          {
            match: {
              vehicle_type: query[4]
            }
          },
          {
            match: {
              make: {
                query: query[0],
                minimum_should_match: percent[0]
              }
            }
          },
          {
            match: {
              model: {
                query: query[1],
                minimum_should_match: percent[1]
              }
            }
          },
          {
            match: {
              submodel: {
                query: query[2],
                minimum_should_match: percent[2] 
              }
            }
          },
          {
            match: {
              fuel_type: {
                query: query[3],
                minimum_should_match: '100%' 
              }
            }
          }
        ]
        conditions << { match: { vehicle_subtype: { query: query[5], minimum_should_match: '90%' } } } unless query[5].blank?
        self.repository.search({
          size: size,
          query: { bool: { must: conditions } }
        })
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end
  end
end
