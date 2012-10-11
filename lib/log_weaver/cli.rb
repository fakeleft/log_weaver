require 'methadone'

include Methadone::Main

class Array
  def uniq?
   self.length == self.uniq.length
  end
end

module LogWeaver
  module CLI

    # given an array of file names, generate file name prefixes given the following rules:
    # 1. prefixes have to differ
    # 2. prefixes have to be at least as long as min_length, unless file name is shorter
    # 3. if file names match, and are shorter than min_length, grab whole directories from directory path until they don't match
    # results are returned as a hash keyed on passed-in file names
    def get_file_prefixes(file_paths, min_length = 4)
      # pseudocode:
      # sort by base_name length
      # get common prefix of base_names
      # append letters to prefix from file name at least until min_length and all unique
      # prepend directories until all unique

      base_names = []
      expanded_paths = []
      processed_file_paths = {}
      max_base_name_length = 0
      max_path_component_length = 0

      file_paths.each do |fp|
        max_base_name_length = fp.length if fp.length > max_base_name_length
        base_name = File.basename fp
        base_names << base_name
        processed_file_paths[fp] = {}
        processed_file_paths[fp][:base_name] = base_name
        processed_file_paths[fp][:expanded_path] = File.expand_path(fp)
        expanded_paths << processed_file_paths[fp][:expanded_path]
        path_dirs = processed_file_paths[fp][:expanded_path].split('/')
        path_dirs.pop
        processed_file_paths[fp][:path_dirs] = path_dirs
        max_path_component_length = processed_file_paths[fp][:path_dirs].length if processed_file_paths[fp][:path_dirs].length > max_path_component_length
      end

      raise ArgumentError, "File list is not unique." unless expanded_paths.uniq?

      # initialize accumulator data structures with the common prefix
      prefix = get_longest_common_prefix base_names
      prefixes = []
      file_paths.each do |fp|
        processed_file_paths[fp][:prefix] = prefix.dup
        prefixes << processed_file_paths[fp][:prefix]
      end

      # append as many remaining characters from file basename as it will take to take us
      # over min_length and make each prefix unique
      (prefix.length .. max_base_name_length - 1).each do |i|
        file_paths.each do |fp|
          # append an additional letter; note, if nil, to_s will convert it to ""
          processed_file_paths[fp][:prefix] << processed_file_paths[fp][:base_name][i].to_s
        end
        if i+1 >= min_length
          break if prefixes.uniq?
        end
      end

      # prepend dir path components if still not unique
      (max_path_component_length - 1).downto(0) do |i|
        break if prefixes.uniq?
        file_paths.each do |fp|
          processed_file_paths[fp][:prefix].insert(0, processed_file_paths[fp][:path_dirs][i].to_s + "/")
        end
      end

      # pick out the results
      res = {}
      longest_prefix_length = 0
      file_paths.each do |fp|
        res[fp] = processed_file_paths[fp][:prefix]
        longest_prefix_length = res[fp].length if res[fp].length > longest_prefix_length
      end

      file_paths.each do |fp|
        orig_prefix_length = res[fp].length
        res[fp] << ": " << " " * (longest_prefix_length - orig_prefix_length)
      end

      res
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
