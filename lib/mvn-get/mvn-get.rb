

require 'active_support/core_ext/hash'
require 'rest-client'
require 'json'


MAVEN_CENTRAL_HOST = "http://search.maven.org"
MAVEN_CENTRAL_REMOTE_CONTENT = "#{MAVEN_CENTRAL_HOST}/remotecontent"
MAVEN_CENTRAL_SEARCH = "#{MAVEN_CENTRAL_HOST}/solrsearch/select"

module MavenCentral
  module_function

  def version
    "0.0.4"
  end

  def extract_url_from_dict(d, filetype="pom")
    "#{MAVEN_CENTRAL_REMOTE_CONTENT}?filepath=#{d["groupId"].gsub(".", "/")}/#{d["artifactId"]}/#{d["version"]}/#{d["artifactId"]}-#{d["version"]}.#{filetype}"
  end

  def extract_url_from_id(id, filetype="pom")
    MavenCentral.extract_url_from_dict(id2dict(id), filetype)
  end

  def id2dict(id)
    if (res = id.scan(/(.*):(.*)/)[0]) != nil
      if (res1 = id.scan(/(.*):(.*):(.*)/)[0]) != nil
        res = res1
      end
    else
      return nil
    end

    d = {}
    d["groupId"], d["artifactId"], d["version"] = res
    d
  end

  def dict2id(d)
    "#{d["groupId"]}:#{d["artifactId"]}:#{d["version"]}"
  end

  def search(keyword)
    d = MavenCentral.id2dict(keyword)
    url = if d != nil
      "#{MAVEN_CENTRAL_SEARCH}?q=g:%22#{d["groupId"]}%22%20AND%20a:%22#{d["artifactId"]}%22%20AND%20v:%22#{d["version"]}%22&wt=json"
    else
      "#{MAVEN_CENTRAL_SEARCH}?q=#{keyword}&wt=json"
    end

    result = {}
    body = JSON.parse(MavenCentral.request(url))
    result["candidates"] = body["response"]["docs"].map{|x| x["id"] }
    result["suggestions"] = if body["spellcheck"] and body["spellcheck"]["suggestions"] and body["spellcheck"]["suggestions"][1] then body["spellcheck"]["suggestions"][1]["suggestion"] else  [] end
    result
  end

  def fetch_lastest_version(groupId, artifactId)
    id2dict(search("#{groupId}:#{artifactId}")["candidates"].sort.last)["version"]
  end

  def request(url)
    RestClient.get(url)
  end

end

class MavenCentralRepo

  attr_reader :id, :pom, :groupId, :artifactId, :version

  def version
    MavenCentral.version
  end

  def initialize(id)

    @id = id
    d = MavenCentral.id2dict(@id)
    raise "not a correct id. please use 'groupId:artifactId' or 'groupId:artifactId:version'" if d.nil?

    # use lastest version by default
    if d["version"] == nil || d["version"].strip == ""
      d["version"] = MavenCentral.fetch_lastest_version(d["groupId"], d["artifactId"])
      @id = MavenCentral.dict2id(d)
    end

    @groupId, @artifactId, @version = d["groupId"], d["artifactId"], d["version"]

    pom_url = MavenCentral.extract_url_from_dict(d)
    body = MavenCentral.request(pom_url)
    @pom = Hash.from_xml( body )
  end

  def dependencies(ignore_test_lib = true)
    return [] if @pom["project"]["dependencies"].nil? or
      (@pom["project"]["dependencies"].class == String and @pom["project"]["dependencies"].strip == "")
    [@pom["project"]["dependencies"]["dependency"]].flatten.map{|x| 
      next if ignore_test_lib and x["scope"] and x["scope"].strip == "test"
      if x["version"] =~ /\s*[$]{\s*project[.]version\s*}\s*/
        x["version"] = @version
      end
      "#{x["groupId"]}:#{x["artifactId"]}:#{x["version"]}" 
    }.compact.sort!
  end

  def jar_url
    MavenCentral.extract_url_from_id(@id, "jar")
  end

  def recursive_dependencies(ignore_test_lib = true, only_select_lastest_version = true)
    return [] if dependencies(ignore_test_lib) == []
    return @_recursive_dependencies[ignore_test_lib][only_select_lastest_version] if @_recursive_dependencies and @_recursive_dependencies[ignore_test_lib] and @_recursive_dependencies[ignore_test_lib][only_select_lastest_version]

    
    res = []
    deps = dependencies(ignore_test_lib)
    while not deps.empty?
      d = deps.shift
      if not res.map{|x| x.id }.include?(d)
        r = MavenCentralRepo.new(d)
        if not res.include?(r)
          if only_select_lastest_version == false or
            (only_select_lastest_version == true and 
              ( not res.any?{|x| r.groupId == x.groupId and r.artifactId == x.artifactId } or
               res.any?{|x| r.groupId == x.groupId and r.artifactId == x.artifactId and r.version < x.version }) # lexicographic order
            )
              deps += r.dependencies
              res << r
          end
        end
      end
    end

    if only_select_lastest_version
      res = res.group_by{|x| "#{x.groupId}:#{x.artifactId}" }.map{|k, v| v.reduce{|s, x| if s.version <=> x.version then x else s end } }.flatten
    end

    res.sort!
    @_recursive_dependencies ||= {}
    @_recursive_dependencies[ignore_test_lib] ||= {}
    @_recursive_dependencies[ignore_test_lib][only_select_lastest_version] = res
    return res
  end

  def inspect
    @id
  end

  def ==(other)
    other.class == MavenCentralRepo and id == other.id
  end

  def <=>(other)
    id <=> other.id
  end

  def download(path = ".")
    url = jar_url
    open(File.join(path, url.split("/").last), "w") { |f|
      f.write MavenCentral.request(url)
    }
  end

end

# id = 'com.mashape.unirest:unirest-java:1.4.5'
# r = MavenCentralRepo.new(id)



