require 'rails_helper'

describe "widgets/basic_table_for.html.rb" do
  class Car < Struct.new(:kind, :color, :id); end

  it "renders a table" do
    cars = [
      Car.new("Toyota", "black", 1),
      Car.new("Ford", "red", 2),
      Car.new("Jeep", "green", 3)
    ]
    definition = -> (t) do
      t.column("Kind") { |car| car.kind }
      t.column("Color", classes: %w[color]) { |car| car.color }
      t.actions {|car| link_to "Edit", "/cars/#{car.id}/edit" }
    end

    assign(:classes, %i[foo bar])
    assign(:enumerable, cars)
    assign(:definition, definition)

    render

    expect(rendered).to match_html <<-HTML
      <table class="foo bar">
        <thead>
          <tr>
            <th>Kind</th>
            <th>Color</th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td class="">Toyota</td>
            <td class="color">black</td>
            <td class=""><a href="/cars/1/edit">Edit</a></td>
          </tr>
          <tr>
            <td class="">Ford</td>
            <td class="color">red</td>
            <td class=""><a href="/cars/2/edit">Edit</a></td>
          </tr>
          <tr>
            <td class="">Jeep</td>
            <td class="color">green</td>
            <td class=""><a href="/cars/3/edit">Edit</a></td>
          </tr>
        </tbody>
      </table>
    HTML
  end
end
