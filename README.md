Altpass
=======

A Ruby gem and command-line utility for *generating passwords* derived from *hand-alternating*, *visually unambiguous*, *alphanumeric characters*.

Example
-------

`nXH3ix9w`

General Characteristics
-----------------------

 * alternates hands (currently only supports `QWERTY` [keyboard layout](http://en.wikipedia.org/wiki/Keyboard_layout))
 * always starts with a lower-case character (left-hand first for odd-length passwords; right if even)
 * always ends with a left-hand character (so that the right-hand can finalize the hand alternation by hitting `Enter`/`Return`)
 * all characters are alphanumeric; there are no symbols (so the passwords highlight when double-clicked)
 * all characters are visually unambigous (some fonts make it difficult/impossible to distinguish *zero* and *capital 'o'*, or *one* and *lowercase 'L'*, and *uppercase i*, etc. so such characters are purposely not used)

The "memorizable" pattern
-------------------------

 * the "memorizable" pattern is: lower, UPPER, UPPER, *number*, lower, lower, *number*, lower
 * this pattern repeats for longer passwords

At a glance, a password such as `nXH3ix9w` looks incredibly difficult to memorize, but practicing it 5-10 times usually does the trick, particularly after first taking note of the pattern.

Options
-------

 * make passwords of any *length* (`:length => [0-9]+`)
 * use the *memorizable* pattern or not (`:memorizable => true|false`)
 * show the sample sets and number of *permutations* (`:permutations => [vvv]`) (more `v`'s increase verbosity)

Defaults
--------

 * `:length => 8`
 * `:memorizable => true`

Examples of Gem Usage 
---------------------

Return a *default* password:

    Altpass.generate
     => "uGL4ox7f"

Return an *odd-length* password, not using the memorizable pattern:

    Altpass.generate(:length => 15, :memorizable => false)
     => "cH5L3jwyw9XPw8V"

Return an *even-length* password, not using the memorizable pattern:

    Altpass.generate(:length => 16, :memorizable => false)
     => "uV7AhspqySkBUwhs"

Return the *number of permutations*:

    Altpass.permutations(:length => 16, :memorizable => false)
     => 2869959681148181529600

Print the *sample sets* and *permutation calculation* of a default password, and return the *number of permutations*:

    Altpass.permutations(:length => 8, :memorizable => true, :permutations => 'vvv')
    sample sets:
    ["y", "u", "i", "o", "p", "h", "j", "k", "n", "m"]
    ["Q", "W", "E", "R", "T", "A", "S", "D", "F", "G", "Z", "X", "C", "V", "B"]
    ["Y", "U", "P", "H", "J", "K", "L", "N", "M"]
    ["2", "3", "4", "5"]
    ["y", "u", "i", "o", "p", "h", "j", "k", "n", "m"]
    ["q", "w", "e", "r", "t", "a", "s", "d", "f", "g", "z", "x", "c", "v"]
    ["7", "8", "9"]
    ["q", "w", "e", "r", "t", "a", "s", "d", "f", "g", "z", "x", "c", "v"]
    10 * 15 * 9 * 4 * 10 * 14 * 3 * 14 permutations
     => 31752000

Installation
------------

Add this line to your application's Gemfile:

    gem 'altpass'

And then execute:

    $ bundle

**Or** install it yourself:

    $ gem install altpass

The Command-Line Utility
========================

The command-line utility, `altpass.rb`, is built into the gem.

Example
--------

    $ altpass.rb 
    nF7zHTNrjtYRmxod

Options
-------

    Usage: altpass.rb [options]
        -c                               Create default configuration file /Users/abatko/.altpass.yaml
        -l, --length [INTEGER>0]         Password length
        -m, --memorizable [true|false]   Use the memorizable pattern or not
        -p, --permutations [vvv]         Show permutation size; verbosity increases with v's
        -s, --switches                   Show password switches
        -h, --help                       Show this message

Configuration
-------------

### Program defaults

The program itself comes with the following defaults:

    options[:length] = 8
    options[:memorizable] = true
    options[:permutations] = false
    options[:switches] = false

### File override

Overrides program defaults.

    cat ~/.altpass.yaml 
    :length: 16
    :memorizable: false

### Command-line override

Command-line options override everything mentioned above. See *Command-line Options* above.

Examples of Command-Line Usage
------------------------------

These examples assume the above mentioned *Configuration* section is in effect.

    $ altpass.rb 
    nF7zHTNrjtYRmxod

    $ altpass.rb -p
    oDKfhfYznFN3j4Nv
    2,869,959,681,148,181,529,600 permutations

    $ altpass.rb --length 8 --memorizable true
    kSU5yx9e

    $ altpass.rb -l8 -mt -pvvv -s
    jXJ3oc7z
    sample sets:
    ["y", "u", "i", "o", "p", "h", "j", "k", "n", "m"]
    ["Q", "W", "E", "R", "T", "A", "S", "D", "F", "G", "Z", "X", "C", "V", "B"]
    ["Y", "U", "P", "H", "J", "K", "L", "N", "M"]
    ["2", "3", "4", "5"]
    ["y", "u", "i", "o", "p", "h", "j", "k", "n", "m"]
    ["q", "w", "e", "r", "t", "a", "s", "d", "f", "g", "z", "x", "c", "v"]
    ["7", "8", "9"]
    ["q", "w", "e", "r", "t", "a", "s", "d", "f", "g", "z", "x", "c", "v"]
    10 * 15 * 9 * 4 * 10 * 14 * 3 * 14 permutations
    31,752,000 permutations
    --length 8 --memorizable true

### Create a configuration file

Use the convenience of the `-c` switch to create a default configuration file:

    $ altpass.rb -c
    Created configuration file /Users/abatko/.altpass.yaml

    $ altpass.rb 
    yZH3jw9r

Note that once a configuration file exists, the `-c` option changes to *show* its content:

    $ altpass.rb -h
    Usage: altpass.rb [options]
        -c                               Show default configuration file /Users/abatko/.altpass.yaml
        ...                              ...
        ...                              ...
        ...                              ...

    $ altpass.rb -c
    Your altpass configuration file is /Users/abatko/.altpass.yaml
    :length: 8
    :memorizable: true
    :permutations: false
    :switches: false

Let's remove the configuration file, and create another one with custom settings:

    $ rm ~/.altpass.yaml
    remove /Users/abatko/.altpass.yaml? y

    $ altpass.rb -c -l20 -mf
    Created configuration file /Users/abatko/.altpass.yaml

    $ altpass.rb -c 
    Your altpass configuration file is /Users/abatko/.altpass.yaml
    :length: 20
    :memorizable: false
    :permutations: false
    :switches: false

    $ altpass.rb 
    mgYzNWjdy2JEMZ9emDy5

### Recommended configuration and usage

If you create accounts frequently, and like to have unique passwords that are
as long as the service you are signing up for allows, then consider this
default: length 20, non-memoriable.

Create your confiration file as follows:

    $ altpass.rb -c -l20 -mf

and simply override it at the command-line on a per-need basis (for instance,
when the service has a shorter maximum):

    $ altpass.rb -l16

Note that some services don't specify a maximum, yet they actually have one. In
such cases, you may create your account with a password that will ultimately not
let you log in, and you will have to use their "forgot/reset password" feature
(consider also contacting that service and asking them to post the password
length limit on their sign-up page).

Contributing
============

1. Fork it
2. Create your feature branch (`git checkout -b my_new_feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my_new_feature`)
5. Create new Pull Request

