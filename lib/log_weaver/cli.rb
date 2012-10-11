require 'methadone'

include Methadone::Main

module LogWeaver
  module CLI
    PREFIX_LENGTH_LIMIT = 4

    # given 2 file names, generate file name prefixes given the following rules:
    # 1. prefixes have to differ
    # 2. prefixes have to be longer than PREFIX_LENGTH_LIMIT, unless file name is shorter
    # 3. if both file names are shorter than PREFIX_LENGTH_LIMIT, grab whole directories from directory path
    def get_file_prefixes(file1, file2)
      files = [file1, file2].sort_by(&:length)

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
      return nil if words.include? nil
    end

  end
end
