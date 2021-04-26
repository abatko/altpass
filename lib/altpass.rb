require 'altpass/version'

module Altpass

	DEFAULT_LENGTH = 8
	DEFAULT_OPTIONS = {:length => DEFAULT_LENGTH, :memorizable => true}

	# character sets divided by touch typing hands
	LN = '12345'.split('')                    # Left-hand Numbers
	RN = '67890' .split('')                   # Right       ''
	LL = ('qwert'+'asdfg'+'zxcvb').split('')  # Left-hand Lowercase letters
	RL = ('yuiop'+'hjkl'+'nm').split('')      # Right       ''        ''
	LU = LL.collect {|c| c.capitalize}        # Left-hand Uppercase letters
	RU = RL.collect {|c| c.capitalize}        # Right       ''        ''

	AMBIGUOUS =
		'1lI0O' + # visually ambiguous
		'6b'      # left/right ambiguous

	# patterns for even and odd length passwords;
	# alternating hands, with the last always being on the left;
	# only the first in each subset takes part in the "memorizable" pattern: LUUNLLNL
	@pattern_even = [[RL], [LU, LN, LL], [RU, RN, RL], [LN, LL, LU], [RL, RU, RN], [LL, LU, LN], [RN, RL, RU], [LL]]

	@pattern_odd  = [[LL], [RU, RN, RL], [LU, LN, LL], [RN, RL, RU], [LL, LU, LN], [RL, RU, RN], [LN, LL, LU], [RL]]

	# return a password
	def self.generate(options={})
		options = self._verify_options(options)
		password = ''
		iterations = options[:length]/DEFAULT_LENGTH + 1
		iterations.times { password += self._generate(options) }
		password.slice(0...options[:length])
	end

	# return the number of permutations,
	# and additionally print out details when options[:permutations] contains v's
	def self.permutations(options={})
		options = self._verify_options(options)
		p = 1
		pattern = options[:length].even? ? @pattern_even : @pattern_odd
		plen = pattern.length
		samples = []
		(0...options[:length]).each { |i|
			samples[i] = (options[:memorizable] ? pattern[i%plen][0] : pattern[i%plen].flatten).reject{|c| AMBIGUOUS.include?(c)}
			p *= samples[i].length # take the product of all sample sizes to get the total number of permutations
		}
		if options[:permutations] =~ /^v{3,}\Z/
			puts 'sample sets:'
			samples.each {|s|
				puts s.inspect
			}
		end
		puts "#{samples.collect {|s| s.length}.join(' * ')} permutations" if options[:permutations] =~ /^v{2,}\Z/
		p
	end

private

	# verify and return an options hash, after merging the default options with the incoming ones
	def self._verify_options(options=nil)
		raise ArgumentError, "expected a Hash, but got: #{options.inspect}" unless options.kind_of?(Hash)
		options = DEFAULT_OPTIONS.merge(options)
		raise ArgumentError, "expected :memorizable to be boolean, but got: #{options[:memorizable].inspect}" unless options[:memorizable].kind_of?(TrueClass) || options[:memorizable].kind_of?(FalseClass)
		raise ArgumentError, "expected :length to be an Integer, but got: #{options[:length].inspect}" unless options[:length].kind_of?(Integer)
		raise ArgumentError, "expected :length > 0, but got: #{options[:length]}" unless options[:length] > 0
		options
	end

	# generate and return a string, having a parity-appropriate pattern, where each character is sampled from the appropriate character set (depending on whether :memorizable is true or false)
	def self._generate(options={})
		options = self._verify_options(options)
		pattern = options[:length].even? ? @pattern_even : @pattern_odd
		return pattern.collect { |i|
			s =''
			loop do
				s = _sample(i[options[:memorizable] ? 0 : rand(i.length)])
				break unless AMBIGUOUS.include?(s)
			end
			s
		}.join.slice(0..-1)
	end

	# pick a random element from the given array
	def self._sample(a=[])
		raise ArgumentError, "expected an Array, but got: #{a.class}" unless a.kind_of?(Array)
		raise ArgumentError, 'expected a non-empty Array, but got an empty one' unless a.length > 0
		a[rand(a.length)]
	end

end

