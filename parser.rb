require "optparse"

class Parser
  def self.parse options=ARGV
    default_options = {
      bits: 16,
      divisors: [1.0, 2.0, 4.0, 8.0, 16.0, 32.0, 64.0, 128.0, 256.0],
      max_error: 5.0
    }

    option_parser = OptionParser.new do |opts|
      opts.banner = "Usage: timer-calculator <options>"

      opts.on "-sFS", "--source-frequency=FS", "Timer source clock frenquency" do |s|
        default_options[:source_frequency] = parse_frequency s
      end

      opts.on "-tFT", "--target-frequency=FT", "Target timer frequency" do |t|
        default_options[:target_frequency] = parse_frequency t
      end

      opts.on "-bBITS", "--bits=BITS", "Timer width, in bits (default=16)" do |b|
        default_options[:bits] = b.to_i
      end

      default_divisors = default_options[:divisors].join(',')
      opts.on "-dDIV1,DIV2,...,DIVN", "--divisors=DIV1,DIV2,...,DIVN",
        "Available divisors to source clock (default=#{default_divisors})" do |d|

        default_options[:divisors] = d.split(",").map(&:to_f)
      end

      opts.on "-mMAX_ERROR", "--max-error=MAX_ERROR",
        "The percentual max error of the output frequency (default=5%)" do |m|
        default_options[:max_error] = m.to_f
      end
    end

    option_parser.parse! options
    default_options
  end

  private

  def self.parse_frequency string
    pat = /(?<num>\d+(\.\d+)?)(?<suffix>[km]?)/i
    if match = pat.match(string)
      num = match[:num].to_f

      case match[:suffix].downcase
      when "k" then num *= 1_000
      when "m" then num *= 1_000_000
      end

      num.to_f
    end
  end
end
