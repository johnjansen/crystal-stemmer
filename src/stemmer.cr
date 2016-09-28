# Porter stemmer in Crystal.
#
# This is the Porter stemming algorithm, ported to Crystal from the
# version coded up in Perl.  It's easy to follow against the rules
# in the original paper in:
#
#   Porter, 1980, An algorithm for suffix stripping, Program, Vol. 14,
#   no. 3, pp 130-137,
#
# See also http://www.tartarus.org/~martin/PorterStemmer

require "./stemmer/*"

module Stemmer

  STEP_2_LIST = {
    "ational"=>"ate", "tional"=>"tion", "enci"=>"ence", "anci"=>"ance",
    "izer"=>"ize", "bli"=>"ble",
    "alli"=>"al", "entli"=>"ent", "eli"=>"e", "ousli"=>"ous",
    "ization"=>"ize", "ation"=>"ate",
    "ator"=>"ate", "alism"=>"al", "iveness"=>"ive", "fulness"=>"ful",
    "ousness"=>"ous", "aliti"=>"al",
    "iviti"=>"ive", "biliti"=>"ble", "logi"=>"log"
  }
  
  STEP_3_LIST = {
    "icate"=>"ic", "ative"=>"", "alize"=>"al", "iciti"=>"ic",
    "ical"=>"ic", "ful"=>"", "ness"=>""
  }


  SUFFIX_1_REGEXP = /(
                    ational  |
                    tional   |
                    enci     |
                    anci     |
                    izer     |
                    bli      |
                    alli     |
                    entli    |
                    eli      |
                    ousli    |
                    ization  |
                    ation    |
                    ator     |
                    alism    |
                    iveness  |
                    fulness  |
                    ousness  |
                    aliti    |
                    iviti    |
                    biliti   |
                    logi)$/x


  SUFFIX_2_REGEXP = /(
                      al       |
                      ance     |
                      ence     |
                      er       |
                      ic       | 
                      able     |
                      ible     |
                      ant      |
                      ement    |
                      ment     |
                      ent      |
                      ou       |
                      ism      |
                      ate      |
                      iti      |
                      ous      |
                      ive      |
                      ize)$/x


  C = "[^aeiou]"         # consonant
  V = "[aeiouy]"         # vowel
  CC = "#{C}(?>[^aeiouy]*)"  # consonant sequence
  VV = "#{V}(?>[aeiou]*)"    # vowel sequence

  MGR0 = /^(#{CC})?#{VV}#{CC}/                # [cc]vvcc... is m>0
  MEQ1 = /^(#{CC})?#{VV}#{CC}(#{VV})?$/       # [cc]vvcc[vv] is m=1
  MGR1 = /^(#{CC})?#{VV}#{CC}#{VV}#{CC}/      # [cc]vvccvvcc... is m>1
  VOWEL_IN_STEM   = /^(#{CC})?#{V}/                      # vowel in stem
  
  def stem

    # make a copy of the given object and convert it to a string.
    w = self.dup.to_s
    
    return w if w.size < 3
    
    # now map initial y to Y so that the patterns never treat it as vowel
    w = w.sub( /^y/, "Y" )
    
    # Step 1a
    if p = w =~ /(ss|i)es$/
      w = w[0..p-1] + $1
    elsif p = w =~ /([^s])s$/ 
      w = w[0..p-1] + $1
    end

    # Step 1b
    p = w =~ /eed$/
    if !p.nil?
      w = w.chop if w[0..p-1] =~ MGR0 
    elsif p = (w =~ /(ed|ing)$/)
      stem = p == 0 ? "" : w[0..p-1]
      if stem =~ VOWEL_IN_STEM 
        w = stem
      case w
        when /(at|bl|iz)$/             then w = "#{w}e"
        when /([^aeiouylsz])\1$/       then w = w.chop
        when /^#{CC}#{V}[^aeiouwxy]$/ then w = "#{w}e"
        end
      end
    end

    p = w =~ /y$/ 
    if !p.nil?
      stem = w[0..p-1]
      w = stem + "i" if stem =~ VOWEL_IN_STEM 
    end

    # Step 2
    p = w =~ SUFFIX_1_REGEXP
    if !p.nil?
      stem = p == 0 ? "" : w[0..p-1]
      suffix = $1
      if stem =~ MGR0
        w = stem + STEP_2_LIST[suffix]
      end
    end

    # Step 3
    p = w =~ /(icate|ative|alize|iciti|ical|ful|ness)$/
    if !p.nil?
      stem = w[0..p-1]
      suffix = $1
      if stem =~ MGR0
        w = stem + STEP_3_LIST[suffix]
      end
    end

    # Step 4
    p = w =~ SUFFIX_2_REGEXP
    if !p.nil?
      stem = w[0..p-1]
      if stem =~ MGR1
        w = stem
      end
    elsif w =~ /(.*)(s|t)(ion)$/
      stem = $1 + $2
      if stem =~ MGR1
        w = stem
      end
    end

    #  Step 5
    p = w =~ /e$/ 
    if !p.nil?
      stem = w[0..p-1]
      if (stem =~ MGR1) ||
          (stem =~ MEQ1 && stem !~ /^#{CC}#{V}[^aeiouwxy]$/)
        w = stem
      end
    end

    if w =~ /ll$/ && w =~ MGR1
      w = w.chop
    end

    # and turn initial Y back to y
    w = w.sub(/^Y/, "y")

    w
  end

end

class String
  include Stemmer
end