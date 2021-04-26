lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'altpass/version'

Gem::Specification.new do |gem|
	gem.name          = 'altpass'
	gem.version       = Altpass::VERSION

	gem.authors       = ['Aba Tkosan']
	gem.email         = ['aba.tkosan@gmail.com']

	gem.summary       = %q{Generate passwords derived from hand-alternating, visually unambiguous, alphanumeric characters}
	gem.description   = "#{gem.summary}. This is a Ruby gem and command-line utility."

	gem.homepage      = 'https://github.com/abatko/altpass'

	gem.files         = `git ls-files`.split($/)
	gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
	gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
	gem.require_paths = ['lib']

	gem.license       = 'MIT'
end

