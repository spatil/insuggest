module Insuggest
  module Gcv
    module Depreciation
      module ClassMethods
        def get_index_name
          "gcv_depreciations"
        end

        def repository
          index_name = get_index_name
          Elasticsearch::Persistence::Repository.new do
            index index_name 
            type :depreciation
            settings number_of_shards: 2
          end
        end
      end

      def self.included(base)
        base.send :include, Insuggest::Gcv::Discount
        base.extend(ClassMethods)
      end
    end
  end
end
