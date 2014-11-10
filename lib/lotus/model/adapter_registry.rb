require 'lotus/model/config/adapter'

module Lotus
  module Model
    # A collection of adapters
    #
    # @since x.x.x
    class AdapterRegistry

      # A hash of adapter config instances
      #
      # @return [Hash<Lotus::Model::Config::Adapter>]
      #
      # @since x.x.x
      attr_reader :adapter_configs

      # A hash of adapter instances
      #
      # @since x.x.x
      attr_reader :adapters

      def initialize
        reset!
      end

      # Register new adapter configuration
      #
      # @param options [Hash] A set of options to register an adapter
      # @option options [Symbol] :name The name that you can use to lookup the
      #   registered adapter
      # @option options [Symbol] :type The type of the adapter.
      # @option options [String] :uri URI reference to the persistence end point
      # @option options [Boolean] :default Set if the current adapter is the
      #   default one for the application scope.
      #
      # @return void
      #
      # @since x.x.x
      #
      # @see Lotus::Model::Config::Adapter
      def register(options)
        adapter_config = Lotus::Model::Config::Adapter.new(options[:type], options[:uri])
        adapter_configs[options[:name]] = adapter_config
        adapter_configs.default = adapter_config if !adapter_configs.default || options[:default]
      end

      # Instantiate all registered adapters
      #
      # @return void
      #
      # @since x.x.x
      def build(mapper)
        adapter_configs.each do |name, config|
          @adapters[name] = config.__send__(:build, mapper)
          @adapters.default = @adapters[name] if default?(config)
        end
      end

      # Reset all the values to the defaults
      #
      # @return void
      #
      # @since x.x.x
      def reset!
        @adapter_configs = {}
        @adapters = {}
      end

      private

      # Check if the adapter config is default
      #
      # @return [Boolean]
      #
      # @since x.x.x
      # @api private
      def default?(adapter_config)
        adapter_config == adapter_configs.default
      end

    end
  end
end