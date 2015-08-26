#!/usr/bin/env ruby

class Ezre
  def self.esc(char)
    sprintf('%s%s', '\\', char)
  end

  # * make sure that patterns modifying escaped strings are
  #   ran first.
  # * putting them after a pattern that will escape the atom/modifier
  #   will double escape it, which isn't the result you want
  TEMPLATES = {
    sed: {
      esc(?\\) => '&litbackslash;',
      esc(??)  => '&litqm;',
      esc(?+)  => '&litplus;',
      esc(?{)  => '&litopenedcurly;', # lit. { is escaped in ezre format
      esc(?})  => '&litclosedcurly;',
      esc(?()  => '&litopenedparen;',
      esc(?))  => '&litclosedparen;',
      esc(?[)  => '&litopenedsquare;',
      esc(?])  => '&litclosedsquare;',
      ?| => '\|',
      ?{ => '\{',
      ?} => '\}',
      ?( => '\(',
      ?) => '\)',
      ?? => '\{0,1\}',
      ?+ => '\{1,\}',
      esc(?s) => '[[:space:]]',
      esc(?S) => '[^[:space:]]',
      esc(?d) => '[[:digit:]]',
      esc(?D) => '[^[:digit:]]',
      esc(?w) => '[[:alnum:]_]',
      esc(?W) => '[^[:alnum:]_]',
      '&litclosedsquare;' => esc(?]),
      '&litclosedparen;'  => ?),      # lit. ) is not escaped in sed
      '&litclosedcurly;'  => ?},      # lit. } is not escaped in sed
      '&litopenedsquare;' => esc(?[),
      '&litopenedparen;'  => ?(,      # lit. ( is not escaped in sed
      '&litopenedcurly;'  => ?{,      # lit. { is not escaped in sed
      '&litplus;' => ?+,              # lit. + is not escaped in sed
      '&litqm;' => ??,                # lit. ? is not escaped in sed
      '&litbackslash;' => esc(esc('')),
    },

    esed: {
    },

    grep: {
    },

    egrep: {
    },

    pcre: {
    },
  }

  def self.run(args)
    subcommand, regex, leftover = args

    if regex && template = TEMPLATES[subcommand.to_sym]
      converted_re = template.inject(regex) do |re,(pat,rep)|
        re.gsub(pat,rep)
      end

      printf '%s', converted_re
    else
      help subcommand
    end
  end

  def self.help(subcommand)
    subcommand ||= 'help'

    case subcommand
    when 'help', '--help', '-?'
      simple_help
    when 'format'
      full_format
    when 'quantifiers'
      quantifiers
    when 'character_classes'
      character_classes
    end
  end

  def self.full_format
    puts <<-HELP
      Expected Regular Expression Format:

    HELP

    quantifiers
    character_classes
    # ...
  end

  def self.quantifiers
    puts <<-HELP
        Quantifiers:
          ?
            0 or 1, optional.

            Example: /ya?ml/
            Matches: 'yml', 'yaml'

          *
            0 or many

            Example: /ya*ml/
            Matches: 'yml', 'yaml', 'yaaml', 'yaaaml', ...

          +
            1 or many

            Example: /ya+ml/
            Matches: 'yaml', 'yaaml', 'yaaaml', ...

          {n,}
            (n) or more

            Exmple: /ya{2,}ml/
            Matches: 'yaaml', 'yaaaml', ...

          {n,m}
            from (n) to (m)

            Exmple: /ya{2,3}ml/
            Matches: 'yaaml', 'yaaaml'
    HELP
  end

  def self.character_classes
    puts <<-"HELP"
      Shorthand Character Classes:

        Note: Shorthand versions may not match the same unicode strings as the spelled-out character classes.

        \s       [[:space:]]
        \S       [^[:space:]]
        \d       [[:digit:]]
        \D       [^[:digit:]]

    HELP
  end

  def self.valid_subcommands
    puts <<-HELP
      Valid Subcommmands:
        sed, esed, grep, egrep, pcre

    HELP
  end
end


Ezre.run(ARGV)

