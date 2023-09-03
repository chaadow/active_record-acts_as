module ActiveRecord
  module ActsAs
    module QueryMethods
      def where!(opts, *rest)
        if acting_as? && opts.is_a?(Hash)
          if table_name_opts = opts.delete(table_name)
            opts = opts.merge(table_name_opts)
          end

          # Filter out the conditions that should be applied to the `acting_as_model`, which are
          # those that neither target specific tables explicitly (where the condition value
          # is a hash or the condition key contains a dot) nor are attributes of the submodel.
          opts, acts_as_opts = opts.stringify_keys.partition do |k, v|
            v.is_a?(Hash) ||
            k =~ /\./     ||
            column_names.include?(k.to_s) ||
            attribute_method?(k.to_s)
          end.map(&:to_h)

          if acts_as_opts.any?
            opts[acting_as_model.table_name] = acts_as_opts
          end
        end

        super opts, *rest
      end
    end

    module ExistsConcern
      extend ActiveSupport::Concern

      included do
        alias :_original_exists? :exists?

        # We redefine the method only when this module is included
        # to have acces to the original exists? method
        def exists?(...)
          return super unless acting_as?

          joins(acting_as_name.to_sym)._original_exists?(...)
        end
      end

    end

    module ScopeForCreate
      def scope_for_create(attributes = nil)
        return super() unless acting_as?

        scope = respond_to?(:values_for_create) ? values_for_create(attributes) : where_values_hash
        scope.merge!(where_values_hash(acting_as_model.table_name))
        scope.merge!(attributes) if attributes
        scope.merge(create_with_value)
      end
    end
  end

  Relation.send(:prepend, ActsAs::QueryMethods)
  Relation.send(:prepend, ActsAs::ScopeForCreate)
end

ActiveSupport.on_load(:active_record) do
  ActiveRecord::Relation.include(ActiveRecord::ActsAs::ExistsConcern)
end
