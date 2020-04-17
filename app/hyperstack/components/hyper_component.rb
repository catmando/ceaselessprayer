# app/hyperstack/hyper_component.rb
class HyperComponent
  # All component classes must include Hyperstack::Component
  include Hyperstack::Component
  # The Observable module adds state handling
  include Hyperstack::State::Observable
  # The following turns on the new style param accessor
  # i.e. param :foo is accessed by the foo method
  param_accessor_style :accessors

  class << self
    def set_top
      jQ[`window`].scrollTop(@saved_top || 0)
    end

    def save_top
      @saved_top = jQ[`window`].scrollTop
    end
  end

  after_mount do
    self.class.set_top
  end

  before_unmount do
    self.class.save_top
  end
end

module Hyperstack
  module Internal
    module Component
      class ReactWrapper
        def self.eval_native_react_component(name)
          component = `eval(name)`
          raise "#{name} is not defined" if `#{component} === undefined`
          component = `component.default` if `component.__esModule && component.default`
          is_component_class = `#{component}.prototype !== undefined` &&
                                (`!!#{component}.prototype.isReactComponent` ||
                                 `!!#{component}.prototype.render`)
          is_memo = `#{component}.type != undefined` && `typeof #{component}.type.render === "function"`
          has_render_method = `typeof #{component}.render === "function"`
          unless is_component_class || stateless?(component) || has_render_method || is_memo
            raise 'does not appear to be a native react component'
          end
          component
        end
      end
    end
  end
end
