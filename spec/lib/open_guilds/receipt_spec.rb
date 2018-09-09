require 'spec_helper'

RSpec.describe OpenGuilds::Receipt do
  describe '#total_cost' do
    let(:subject) { described_class.new() }

    context 'when there are no line items' do
      it 'should return no cost total' do
        expect(subject.total).to eq "$0.00"
      end

      it 'should return the total cost in cents' do
        expect(subject.total_cents).to eq 0
      end
    end

    context 'when there is at least one line item' do
      before do
        subject.line_items << OpenGuilds::Receipt::LineItem.new(amount_cents: 100)
        subject.line_items << OpenGuilds::Receipt::LineItem.new(amount_cents: 100)
      end

      it 'should return no cost total' do
        expect(subject.total).to eq "$2.00"
      end

      it 'should return the total cost in cents' do
        expect(subject.total_cents).to eq 200
      end
    end
  end
end
