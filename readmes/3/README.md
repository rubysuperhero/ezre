
# Ezre (Easy Regular Expression [Dialect Translator])

  There are many different regular expression dialects and regular
expression engines.  For example, grep and sed both offer regular and
extended formats, there is also PCRE and vim has a few including
normal, magic, and very-magic.  Ezre expects a single format as input,
and converts it to the regexp dialect specified.

# Goals

* Accept a regular expression as input, in a standardized format, and convert
  the regular expression into another supported format. (bash, sed, awk, grep,
  egrep, perl, etc.)  The converted regular expression can then either be:
  * sent to stdout and used at the user's discretion
  * automatically used in a command template and ran using the command that
    accepts the target format

## Examples

There is a lot of typing going on in these examples.  The commands are very
long, but I'm sure someone can find an elegant way of simplifying them.

_Converting_
```
  # full versions:

  $> ezre convert sed 's/hello?/bye/'
  s/hello\{0,1\}/bye/

  $> ezre convert esed 's/hello?/bye/'
  s/hello{0,1}/bye/


  # shorthand:

  $> ezre c esed 's/hello?/bye/'
  s/hello{0,1}/bye/
```

_Executing_

These examples are especially bad.  This is a result of requiring the following
information, so the integrity of the final command isn't compromised:

  1. that ezre should execute a shell command
  2. the target format of the regular expression
  3. the command template, including any options/arguments
  4. the regular expression being converted

Numbers 3 and 4 could possibly be combined, by putting the regular expression
inside the command template and running the entire template through the
converter.  However, this presents the possible risk of converting something
in the template besides the regular expression.

Another possibility, is using bash/zsh's shell expansion and only implementing
the converting functionality.  One benefit to only implementing the convert
feature is the convert/run subcommand is no longer needed.  Here are examples of
using well-known shell conventions:

```
  $> grep "$(ezre convert grep 'he(l)\1')" -m 4 /usr/share/dict/words

  # omitting the convert subcommand:
  $> grep "$(ezre grep 'he(l)\1')" -m 4 /usr/share/dict/words
```

Here are the examples for using ezre to run the final command:

```
  $> ezre run grep 'grep "%1" -m 4 /usr/share/dict/words' 'he(l)\1'
  beshell
  bombshell
  Branchellion
  Brighella

  # runs:
  #  grep "he\(l\)\1" -m 4 /usr/share/dict/words


  $> grep 'hell' -m 4 /usr/share/dict/words | ezre run sed 'sed "s/%1/bye/"' 'hello?'
  besbye
  bombsbye
  Brancbyeion
  Brigbyea

  # runs:
  #   grep 'hell' -m 4 /usr/share/dict/words | sed 's/hello\{0,1\}/bye/'


  $> grep 'hell' -m 4 /usr/share/dict/words | ezre run esed 'sed -E "s/%1/b%2e/"' 'hello?' 'Y'
  besbYe
  bombsbYe
  BrancbYeion
  BrigbYea

  # runs:
  #   grep 'hell' -m 4 /usr/share/dict/words | sed -E 's/hello{0,1}/bYe/'
```

# Old, More Verbose Goals

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
* It would be even nicer if ezre ran the command in the destination dialect,
  that way dealing with the ugly syntax for command substitution can be avoided
  and running a clean cmd like:
  ```
  $> ezre -x sed -n '/regexp/p'`

  # ...or...

  $> ezre run sed -n '/regexp/p'
  ```
  or something similar, would be all that's needed to use the specified command.

# Possible Design Decisions/Changes

* Unknown subcommands might look for an executable named:
  `ezre-<subcommand>` to allow ezre to be extendable in the same way
  that git allows custom subcommands in the form of 3rd party
  commands.
* I'm not sure what the performance impact of passing a block to gsub
  is.  If it is minimal, or comparable to running gsub 3x, then I
  might replace the literal placeholder -> other regex -> literal
  placeholder flow to a single gsub with a ternary to determine what
  the replacement should look like based on the previous character.

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

