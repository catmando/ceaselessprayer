# app/hyperstack/hyper_component.rb
class HyperComponent
  include Hyperstack::Component
  include Hyperstack::State::Observable
  param_accessor_style :accessors

  # style helpers
  #
  # the styles macro allows a hash of styles to be dyamically computed
  # they are accessed via the styles method
  #
  # the definition in the styles macro can be inherited by subclasses and
  # overriden
  #
  # styles can be passed to any component via the style param

  param style: {}

  def styles(klass)
    styles = self.class.styler(self, klass)
    return unless styles

    { style: styles }
  end

  def self.styler(component, klass)
    return {} if self == HyperComponent

    super_styles = superclass.styler(component, klass)
    my_styles = component.instance_eval(&@style_block) if @style_block
    my_styles &&= my_styles[klass]
    return super_styles unless my_styles

    super_styles.merge(my_styles)
  end

  def self.styles(&block)
    @style_block = block
  end

  # The following is an experiment to see if we can save the scroll position
  # between pages.  Its not working, so its disabled

  class << self
    def set_top
      # `jQuery(window).scrollTop(#{@saved_top || 0})`
      jQ[`window`].scrollTop(@saved_top || 0)
    end

    def save_top
      # @saved_top = jQ[`window`].scrollTop
    end
  end

  after_mount do
    self.class.set_top
  end

  before_unmount do
    self.class.save_top
  end
end

# hyperstack issue #308 add class to top level error boundry
module Hyperstack
  class Hotloader
    module AddErrorBoundry
      alias original_display_error display_error
      def display_error(*args)
        DIV(class: 'hyperstack-top-level-error-boundry') { original_display_error(*args) }
      end
    end
  end
end

# Hyperstack Component patches not yet released

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

        def self.convert_props(type, *args)
          # merge args together into a single properties hash
          properties = {}
          args.each do |arg|
            if arg.is_a? String
              properties[arg] = true
            elsif arg.is_a? Hash
              arg.each do |key, value|
                if ['class', 'className', 'class_name'].include? key
                  next unless value

                  if value.is_a?(String)
                    value = value.split(' ')
                  elsif !value.is_a?(Array)
                    raise "The class param must be a string or array of strings"
                  end

                  properties['className'] = [*properties['className'], *value]
                elsif key == 'style'
                  next unless value

                  if !value.is_a?(Hash)
                    raise "The style param must be a Hash"
                  end

                  properties['style'] = (properties['style'] || {}).merge(value)
                elsif Hyperstack::Component::ReactAPI::HASH_ATTRIBUTES.include?(key) && value.is_a?(Hash)
                  properties[key] = (properties[key] || {}).merge(value)
                else
                  properties[key] = value
                end
              end
            end
          end
          # process properties according to react rules
          props = {}
          properties.each do |key, value|
            if %w[style dangerously_set_inner_HTML].include? key
              props[lower_camelize(key)] = value.to_n

            elsif key == :className
              props[key] = value.join(' ')

            elsif key == :key
              props[:key] = value.to_key

            elsif key == :init
              if %w[select textarea].include? type
                key = :defaultValue
              elsif type == :input
                key = if %w[radio checkbox].include? properties[:type]
                        :defaultChecked
                      else
                        :defaultValue
                      end
              end
              props[key] = value

            elsif key == 'ref'
              next unless value
              unless value.respond_to?(:call)
                raise "The ref and dom params must be given a Proc.\n"\
                      "#{type}(#{properties})  value = #{value} value.respond_to?(:call): #{value.respond_to?(:call)}\n"\
                      "If you want to capture the ref in an instance variable use the `set` method.\n"\
                      "For example `ref: set(:TheRef)` will capture assign the ref to `@TheRef`\n"
              end
              unless `value.__hyperstack_component_ref_is_already_wrapped`
                fn = value
                value = %x{
                          function(dom_node){
                            if (dom_node !== null && dom_node.__opalInstance !== undefined && dom_node.__opalInstance !== null) {
                              #{ Hyperstack::Internal::State::Mapper.ignore_mutations { fn.call(`dom_node.__opalInstance`) } };
                            } else if(dom_node !== null && ReactDOM.findDOMNode !== undefined && dom_node.nodeType === undefined) {
                              #{ Hyperstack::Internal::State::Mapper.ignore_mutations { fn.call(`ReactDOM.findDOMNode(dom_node)`) } };
                            } else if(dom_node !== null){
                              #{ Hyperstack::Internal::State::Mapper.ignore_mutations { fn.call(`dom_node`) } };
                            }
                          }
                        }
                `value.__hyperstack_component_ref_is_already_wrapped = true`
              end
              props[key] = value
            elsif key == 'jq_ref'
              unless value.respond_to?(:call)
                raise "The ref and dom params must be given a Proc.\n"\
                      "If you want to capture the dom node in an instance variable use the `set` method.\n"\
                      "For example `dom: set(:DomNode)` will assign the dom node to `@DomNode`\n"
              end
              unless Module.const_defined? 'Element'
                raise "You must include 'hyperstack/component/jquery' "\
                      "in your manifest to use the `dom` reference key.\n"\
                      'For example if using rails include '\
                      "`config.import 'hyperstack/component/jquery', client_only: true`"\
                      'in your config/initializer/hyperstack.rb file'
              end
              props[:ref] = %x{
                              function(dom_node){
                                if (dom_node !== null && dom_node.__opalInstance !== undefined && dom_node.__opalInstance !== null) {
                                  #{ Hyperstack::Internal::State::Mapper.ignore_mutations { value.call(::Element[`dom_node.__opalInstance`]) } };
                                } else if(dom_node !== null && ReactDOM.findDOMNode !== undefined && dom_node.nodeType === undefined) {
                                  #{ Hyperstack::Internal::State::Mapper.ignore_mutations { value.call(::Element[`ReactDOM.findDOMNode(dom_node)`]) } };
                                } else if(dom_node !== null) {
                                  #{ Hyperstack::Internal::State::Mapper.ignore_mutations { value.call(::Element[`dom_node`]) } };
                                }
                              }
                            }

            elsif Hyperstack::Component::ReactAPI::HASH_ATTRIBUTES.include?(key) && value.is_a?(Hash)
              value.each { |k, v| props["#{key}-#{k.gsub(/__|_/, '__' => '_', '_' => '-')}"] = v.to_n }
            else
              props[Hyperstack::Component::ReactAPI.html_attr?(lower_camelize(key)) ? lower_camelize(key) : key] = value
            end
          end
          props
        end
      end
    end
  end
end
