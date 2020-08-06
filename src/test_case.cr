abstract struct Athena::Spec::TestCase
  include Athena::Spec::Methods

  def self.run : Nil
    instance = new

    {% begin %}
      describe {{@type.name.stringify}}, focus: {{!!@type.annotation ASPEC::Focus}}{% if (tags = @type.annotation(ASPEC::Tags)) %}, tags: {{tags.args}}{% end %} do
        before_all do
          instance.before_all
        end

        before_each do
          instance.initialize
        end

        after_each do
          instance.tear_down
        end

        after_all do
          instance.after_all
        end

        {% methods = [] of Nil %}
 
        {% for parent in @type.ancestors.select &.<(ASPEC::TestCase) %}
          {% for method in parent.methods.select { |m| m.name =~ /^(?:f|p)?test_/ || m.annotation ASPEC::Test } %}
            {% methods << method %}
          {% end %}
        {% end %}
 
        {% for test in methods + @type.methods.select { |m| m.name =~ /^(?:f|p)?test_/ || m.annotation ASPEC::Test } %}
          {% focus = test.name.starts_with?("ftest_") || !!test.annotation ASPEC::Focus %}
          {% tags = (tags = test.annotation(ASPEC::Tags)) ? tags.args : nil %}
          {% method = (test.name.starts_with?("ptest_") || !!test.annotation ASPEC::Pending) ? "pending" : "it" %}

          {% unless test.annotations(ASPEC::DataProvider).empty? %}
            {% for data_provider in test.annotations ASPEC::DataProvider %}
              instance.{{data_provider[0].id}}.each do |name, args|
                {{method.id}} name, focus: {{focus}}, tags: {{tags}} do
                  instance.{{test.name.id}} *args
                end
              end
            {% end %}
          {% else %}
            {{method.id}} {{test.name.stringify.gsub(/^(?:f|p)?test_/, "").underscore.gsub(/_/, " ")}}, focus: {{focus}}, tags: {{tags}} do
              instance.{{test.name.id}}
            end
          {% end %}
        {% end %}
      end
    {% end %}
  end

  protected def before_all : Nil
  end

  protected def after_all : Nil
  end

  protected def tear_down : Nil
  end

  private macro test(name, focus = false, *tags)
    {% if focus %}@[ASPEC::Focus]{% end %}
    {% unless tags.empty? %}@[ASPEC::Tags({{tags.splat}})]{% end %}
    def test_{{name.gsub(/\ /, "_").underscore.downcase.id}} : Nil
    end
  end
end
