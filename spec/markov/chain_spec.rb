# frozen_string_literal: true

require_relative "../../lib/markov/chain"

module Markov
  describe "Markov Chain" do
    context "Undefined transitions" do
      it "is nil when no transitions are defined at all" do
        mk = Chain.new
        child = mk.next_node(:x)
        expect(child).to be_nil
      end

      it "is nil when no transitions are defined for a node (any)" do
        mk = Chain.new
        mk.any(:x, %i[a b c])
        child = mk.next_node(:not_x)
        expect(child).to be_nil
      end

      it "is nil when no transitions are defined for a node" do
        mk = Chain.new
        mk.assign(:x, a: 0.5, b: 0.5)
        child = mk.next_node(:not_x)
        expect(child).to be_nil
      end
    end

    context "Uniform transitions" do
      it "is the one and only option (any)" do
        mk = Chain.new
        mk.any(:x, %i[a])
        child = mk.next_node(:x)
        expect(child).to eq :a
      end

      it "is the one and only option" do
        mk = Chain.new
        mk.assign(:x, a: 1)
        child = mk.next_node(:x)
        expect(child).to eq :a
      end
    end

    context "Mixed transitions" do
      it "approximates a distribution" do
        # cyclic chain, so would expect 1/3rd each
        mk = Chain.new 1234
        mk.assign(:a, b: 0.5, c: 0.5)
        mk.assign(:b, c: 0.5, a: 0.5)
        mk.assign(:c, a: 0.5, b: 0.5)

        counts = { a: 0, b: 0, c: 0 }
        (1..10000).reduce(:a) do |state, _n|
          counts[state] = counts[state] + 1
          mk.next_node(state)
        end

        expect(counts.keys).to eq %i[a b c]
        expect(counts.values.reduce(:+)).to eq 10000
        expect(counts[:a]).to be_within(50).of(3333) # arbitrary bounds
        expect(counts[:b]).to be_within(50).of(3333)
        expect(counts[:c]).to be_within(50).of(3333)
      end
    end
  end
end
