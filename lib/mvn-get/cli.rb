

require File.join(File.expand_path(File.dirname(__FILE__)), "./mvn-get.rb")

require 'thor'

def select_one_library(lib_name, show_notice)
  search_result = MavenCentral.search(lib_name)
  if search_result["candidates"].map{|x| x.gsub(/(.*):(.*):(.*)/, '\1:\1')  }.uniq.size == 1 and search_result["suggestions"].size == 0
    return MavenCentralRepo.new(search_result["candidates"][0])
  elsif show_notice
    if search_result["candidates"].size > 0
      puts "Please specify a library, for example: "
      search_result["candidates"].each {|x| puts "\t#{x}"}
    else
      puts "No available library call #{lib_name}"
    end

    if search_result["suggestions"].size > 0
      print "\nOr... " if search_result["candidates"].size > 0
      puts "Did you mean:"
      search_result["suggestions"].each {|x| puts "\t#{x}"}
    end
  end
  nil
end

def check_dependencies(lib_name)
  repo = select_one_library(lib_name, true)
  if repo != nil
    puts "Select library '#{repo.id}'"
    puts "Check dependencies..."
    deps = repo.recursive_dependencies
    if deps.empty?
      puts "Doesn't have any dependencies"
    else
      puts "#{deps.size} Dependencies:"
      deps.each{|x| puts "\t#{x.id}"}
    end
  end
  repo
end


class CommandLine < Thor

  desc "search LIBRARY_NAME", "search library call LIBRARY_NAME"
  def search(lib_name)
    search_result = MavenCentral.search(lib_name)
    if search_result["candidates"].size > 0
      puts "Candidates:"
      search_result["candidates"].each {|x| puts "\t#{x}"}
    else
      puts "No available library call #{lib_name}"
    end

    if search_result["suggestions"].size > 0
      print "\nOr... " if search_result["candidates"].size > 0
      puts "Did you mean:"
      search_result["suggestions"].each {|x| puts "\t#{x}"}
    end
  end

  desc "deps LIBRARY_NAME", "check dependencies of LIBRARY_NAME"
  def deps(lib_name)
    repo = check_dependencies(lib_name)
  end

  desc "install LIBRARY_NAME", "install all dependencies of LIBRARY_NAME"
  def install(lib_name)
    repo = check_dependencies(ARGV[1])
    if repo != nil
      puts "Start downloading..."
      deps = [repo, repo.recursive_dependencies].flatten
      deps.zip(1..deps.size).each{|x, i| 
        puts "\t[#{i}/#{deps.size}] #{x.id}"
        x.download
      }
    end
    puts "Complete!"
  end
end

# CommandLine.start(ARGV)
