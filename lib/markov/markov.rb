# frozen_string_literal: true

module Markov
  # One-step Markov model
  class Markov
    def initialize(seed = Random.new_seed)
      # a hash of {:x => [[:y,p_y], [:z, p_z], ...]} increasing by p_*
      @weights = {}
      @random = Random.new(seed)
    end

    # Assigns all symbols in 'nodes' to be equally likely after 'x'
    def any(x, nodes)
      eq = nodes.each_with_object({}) { |s, h| h[s] = 1.0 / nodes.length; }
      assign(x, eq)
    end

    # Call as 'assign(:a, :b=>0.2, :c =>0.1, ...)'
    # The given weights must sum to one.
    # If a symbol is not given then in effect its weight is zero.
    def assign(n, w)
      sum = w.inject(0) { |s, (_k, v)| s + v }
      if (sum - 1.0).abs > 1e-6
        raise ArgumentError, "Weights do not sum to 1: #{w.inspect}"
      end

      @weights[n] = w.collect { |k, v| [k, v] }.sort { |a, b| a[1] <=> b[1] }
    end

    # Get the next randomly-selected node after 'n'.
    def next_node(n)
      w = @weights[n]
      index = 0
      wmax = w[-1][1]
      beta = @random.rand(2 * wmax)
      while w[index][1] < beta
        beta -= w[index][1]
        index = (index + 1) % w.length
      end
      w[index][0]
    end
  end
end
