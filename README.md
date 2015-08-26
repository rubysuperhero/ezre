
# Ezre (Easy Regular Expression [Dialect Translator])

  There are many different regular expression dialects and regular
expression engines.  For example, grep and sed both offer regular and
extended formats, there is also PCRE and vim has a few including
normal, magic, and very-magic.  Ezre expects a single format as input,
and converts it to the regexp dialect specified.

# Goals

* When using different command-line tools, it would be nice to only
  have to worry about one format.  The output of ezre can be passed
  using command substitution to sed, grep, egrep, etc.
  ```
  # example of the cmd/output for converting to sed regex format
  # (there are no trailing newline characters)

  ❯ ezre sed '/ENV\[\W\w+\W\]/p'
  /ENV\[[^[:alnum:]_][[:alnum:]_]\{1,\}[^[:alnum:]_]\]/p

  ❯ sed -n `ezre sed '/ENV\[\W\w+\W\]/p'` config/boot.rb
  ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)
  require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])
  ```

# Possible Design Decisions/Changes

* Unknown subcommands might look for an executable named:
  `ezre-<subcommand>` to allow ezre to be extendable in the same way
  that git allows custom subcommands in the form of 3rd party
  commands.
* I'm not sure what the performance impact of passing a block to gsub
  is.  If it is minimal, or comparable to running gsub 3x, then I
  might replace the literal placeholder -> other regex -> literal
  placeholder flow to a single gsub with a ternary to determine what
  the replacement should look like based on the preceeding character.

# Plans for the Future

* Instead of only converting a regexp one way, accept a from-dialect
  and a to-dialect, to convert from one to another.

# Contributing

I am totally open to pull requests of any kind.  Design
improvements, speed optimizations, implementing other dialects, etc.

If you want to contact me via email I can be reached at:
* jearsh+github@gmail.com
* unixsuperhero@gmail.com
* rubysuperhero@gmail.com

I haven't settled on a handle yet =X.

