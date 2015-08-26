require 'rspec'

def esc(char)
  sprintf('%s%s', '\\', char)
end

RSpec.describe 'Ezre command' do
  xit 'should test these regexps in a more obvious way, like with a hash (before/after == key/value)' do
  end

  context 'sed subcommand' do
    it 'converts ?s to {0,1}' do
      expect(`bin/ezre sed 'ya?ml'`).to eq 'ya\{0,1\}ml'
    end

    it 'converts \s to [[:space:]]' do
      expect(%x{bin/ezre sed 'ya?ml#{ esc(?s) }file'}).to eq 'ya\{0,1\}ml[[:space:]]file'
    end

    it 'converts \d to [[:digit:]]' do
      expect(%x{bin/ezre sed 'ya?ml#{ esc(?d) }file'}).to eq 'ya\{0,1\}ml[[:digit:]]file'
    end

    it 'converts \w to [[:alnum:]_]' do
      expect(%x{bin/ezre sed '#{ esc(?s) + esc(?w) }'}).to eq '[[:space:]][[:alnum:]_]'
    end

    it 'converts \S to [^[:space:]]' do
      expect(%x{bin/ezre sed 'ya?ml#{ esc(?S) }file'}).to eq 'ya\{0,1\}ml[^[:space:]]file'
    end

    it 'converts \D to [^[:digit:]]' do
      expect(%x{bin/ezre sed 'ya?ml#{ esc(?D) }file'}).to eq 'ya\{0,1\}ml[^[:digit:]]file'
    end

    it 'converts \W to [^[:alnum:]_]' do
      expect(%x{bin/ezre sed '#{ esc(?S) + esc(?W) }'}).to eq '[^[:space:]][^[:alnum:]_]'
    end

    it 'escapes or operator (aka pipe "|")' do
      expect(%x{bin/ezre sed 'a|b'}).to eq 'a\|b'
    end

    it 'escapes curly quantifiers' do
      expect(%x{bin/ezre sed 'a{2,4}'}).to eq 'a\{2,4\}'
    end

    it 'escapes parens/groups' do
      expect(%x{bin/ezre sed '(as)d(f)'}).to eq '\(as\)d\(f\)'
    end

    context 'do not replace escaped modifiers' do
      it 'question marks' do
        expect(%x{bin/ezre sed 'ya?ml ya?ml ya#{esc(??)}ml'}).to eq "ya\\{0,1\\}ml ya\\{0,1\\}ml ya#{??}ml"
      end

      it 'open and closing curlies' do
        expect(%x{bin/ezre sed '#{esc(?{)}hello#{esc(?})}'}).to eq '{hello}'
      end

      it 'open and closing square bracket' do
        expect(%x{bin/ezre sed '#{esc(?[)}hello#{esc(?])}'}).to eq '\[hello\]'
      end
    end
  end

  context 'quantifiers subcommand' do
    it 'contains the quantifiers output' do
      expect(`bin/ezre quantifiers`).to match_regex %r{Example: /ya[+]ml/}
    end
  end
end
