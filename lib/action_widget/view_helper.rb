module ActionWidget
  module ViewHelper

    def method_missing(name, *args, &block)
      super unless name =~ /_widget$/

      klass = begin
        "#{name.to_s.camelcase}".constantize
      rescue NameError, LoadError
        super
      end

      ActionWidget::ViewHelper.module_eval <<-RUBY
        def #{name}(*args, &block)                  # def example_widget(*args, &block)
          #{klass}.new(self, *args).render(&block)  #   ExampleWidget.new(self, *args).render(&block)
        end                                         # end
      RUBY

      send(name, *args, &block)
    end

  end
end
