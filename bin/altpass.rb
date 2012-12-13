#!/usr/bin/env ruby

require 'altpass'  # for actually generating the Altpass passwords
require 'optparse' # for command-line options parsing
require 'yaml'     # for loading the YAML configuration file, if present

# defaults
options = {}
options[:length] = 8
options[:memorizable] = true
options[:permutations] = false
options[:switches] = false

# YAML configuration file overrides the defaults below
CONFIGURATION_FILE = "#{ENV['HOME']}/.altpass.yaml"
yaml_defaults = YAML.load_file(CONFIGURATION_FILE) if File.exist?(CONFIGURATION_FILE) && File.readable?(CONFIGURATION_FILE)
options = options.merge(yaml_defaults) unless yaml_defaults.nil?

# command-line options override yaml_defaults
OptionParser.new do |opts|
	opts.banner = 'Usage: altpass.rb [options]'

	opts.on('-l', '--length [INTEGER>0]', OptionParser::DecimalInteger, 'Password length') do |l|
		unless l > 0
			puts 'argument to -l must be > 0'
			puts opts ; exit
		end
		options[:length] = l
	end

	opts.on('-m [t|f]', '--memorizable [true|false]', 'Use the memorizable pattern or not') do |m|
		case m
		when /^(t|true)\Z/
			options[:memorizable] = true
		when /^(f|false)\Z/
			options[:memorizable] = false
		else
			puts 'argument to -m must be [true|t|false|f]'
			puts opts ; exit
		end
	end

	opts.on('-p', '--permutations [vvv]', 'Show permutation size; verbosity increases with v\'s') do |p|
		if !p.nil? && p !~ /^v+\Z/
			puts 'argument to -p must be v\'s'
			puts opts ; exit
		end
		options[:permutations] = p.nil? ? 'v' : p+'v'
	end

	opts.on('-s', '--switches', 'Show password switches') do |s|
		options[:switches] = s
	end

	opts.on_tail('-h', '--help', 'Show this message') do
		puts opts ; exit
	end
end.parse!

def show_permutations(options)
	permutations = Altpass.permutations(options)
	# print the number of permutations after adding commas to it
	puts permutations.to_s.reverse.scan(/(?:\d*\.)?\d{1,3}-?/).join(',').reverse + ' permutations'
end

puts Altpass.generate(:length => options[:length], :memorizable => options[:memorizable])

show_permutations(options) if options[:permutations]

puts "--length #{options[:length]} --memorizable #{options[:memorizable]}" if options[:switches]

