#!/usr/bin/env ruby
require_relative "parser"

def get_options!
  options = Parser.parse

  if options[:source_frequency].nil? || options[:target_frequency].nil?
    Parser.parse ["--help"]
    exit 1
  end

  options
end

def calculate options
  results = []
  counter_max = 2**options[:bits] - 1

  options[:divisors].each do |divisor|
    div_frequency = options[:source_frequency] / divisor
    next if div_frequency < options[:target_frequency]

    div_period = 1.0 / div_frequency
    counter = (1 / options[:target_frequency] / div_period).to_i
    next if counter > counter_max

    effective_period = counter.to_f * div_period
    effective_frequency = 1.0 / effective_period
    error = 100.0 * (effective_frequency - options[:target_frequency]) / options[:target_frequency];
    next if error.abs > options[:max_error]

    results << {
      divisor: divisor,
      counter: counter,
      period: effective_period,
      frequency: effective_frequency,
      error: error
    }
  end

  results
end

def format_results results
  formatted = []
  results.each do |result|
    formatted << "divisor: %d, counter: %d" % [ result[:divisor], result[:counter] ]
    formatted << "  effective period: %0.9f s" % result[:period]
    formatted << "  effective frequency: %f Hz" % result[:frequency]
    formatted << "  error: %0.4f%%" % result[:error]
    formatted << "\n"
  end
  formatted.join("\n")
end

options = get_options!

puts "Calculating configurations for requirements:\n#{options}\n\n"

results = calculate options

puts results.length > 0 ? format_results(results) : "No configuration found."
