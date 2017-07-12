# frozen_string_literal: true

class Views::Widgets::BasicTableFor < Views::Base
  needs :enumerable, :classes, :definition

  def content
    definition.call(self)

    table class: classes do
      thead do
        tr do
          titles.each do |title|
            th title
          end
        end
      end
      tbody do
        enumerable.each do |object|
          tr do
            columns.each do |column|
              td capture { column[:block]&.call(object) }, class: CssClasses.new(column[:classes])
            end
          end
        end
      end
    end
  end

  def column(title, classes: nil, &block)
    titles << title
    columns << { block: block, classes: classes }
  end

  def actions(classes: nil, &block)
    titles << ''
    columns << { block: block, classes: classes }
  end

  def titles
    @titles ||= []
  end

  def columns
    @columns ||= []
  end
end
