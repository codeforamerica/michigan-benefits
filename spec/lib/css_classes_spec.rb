# frozen_string_literal: true

require 'rails_helper'

describe CssClasses do
  it 'builds a list of CSS classess out of all kinds of junk' do
    classes = described_class.new('apple banana', 'cherry', nil, :donut, [:eclair, 'fruitcake', ['ganache', :hotdog]])
    classes << 'ice-cream'
    classes << 'juice klondikes'

    expect(classes.to_a).to eq ['apple', 'banana', 'cherry', 'donut', 'eclair', 'fruitcake', 'ganache', 'hotdog', 'ice-cream', 'juice', 'klondikes']
    expect(classes.to_s).to eq 'apple banana cherry donut eclair fruitcake ganache hotdog ice-cream juice klondikes'
  end

  it 'returns an empty array and a nil string if everything is empty' do
    classes = described_class.new('', [[], []])
    expect(classes.to_a).to eq []
    expect(classes.to_s).to eq nil
  end
end
