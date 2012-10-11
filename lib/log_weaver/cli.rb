require 'methadone'

include Methadone::Main

module LogWeaver
  module CLI

    # given an array of file names, generate file name prefixes given the following rules:
    # 1. prefixes have to differ
    # 2. prefixes have to be at least as long as min_length, unless file name is shorter
    # 3. if file names match, and are shorter than min_length, grab whole directories from directory path until they don't match
    # results are returned as a hash keyed on passed-in file names
    def get_file_prefixes(files, min_length = 4)
      file_names = files.each{}
      files = files.sort_by(&:length)
      prefix = get_longest_common_prefix files


      files = {}
      [file1, file2].each{ |f| files[File.expand_path(f)] = File.basename(f) }

      # pseudocode:
      #
      case file1.length <=> file2.length
        when -1

        when 1
        when 0
      end
    end

    def get_longest_common_prefix(words)
      words = words.dup
      return nil if words.include? nil
      prefix =  words.shift.dup
      until prefix == ""
        break if words.all?{ |w| w =~ /^#{prefix}/ }
        prefix.chop!
      end
      prefix
    end

  end
end
