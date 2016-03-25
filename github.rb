#!/usr/bin/ruby

require 'net/http'
require 'json'


# GithubAPI class responsible for interacting with github REST API
class GithubAPI
# the default urls which will use to communicate with the api
# Set the per_page parameter to 1 so the response doesnt return data that we dont need (cant set 0 it will return 100 as default)
  @@apiUrlsTemplates = {
    "issuesOpenUrl" => "https://api.github.com/search/issues?q=repo:user/repository+is:issue+is:open+&per_page=1",
    "issuesClosedUrl" => "https://api.github.com/search/issues?q=repo:user/repository+is:issue+is:closed+&per_page=1",
    #"repositoryUrl" => "https://api.github.com/repos/user/repository"
  }

  def initialize(user, repository)
    @user = user
    @repository = repository
  end

  def callUrls
    repositoryData = []
    configuredUrls = self.configUrls()

    configuredUrls.each do |uri|
      res = Net::HTTP.get_response(uri)
# Check if the data was found, kill the script if not
      if res.code == "404" or res.code == "422"
        abort("The requested information was now found! Please check your username and repository!")
      end
      res = JSON.parse(res.body)

      repositoryData.push(res)
    end
    return repositoryData
  end

  def configUrls
    configuredUrls = []
# replace the placeholders in the template urls with correct username and repository

    configuredUrls.push(URI(@@apiUrlsTemplates["issuesOpenUrl"].sub(/(.+\?q=repo:)user\/repository(.+)/, "\\1#{@user}\/#{@repository}\\2")))
    configuredUrls.push(URI(@@apiUrlsTemplates["issuesClosedUrl"].sub(/(.+\?q=repo:)user\/repository(.+)/, "\\1#{@user}\/#{@repository}\\2")))
    #configuredUrls.push(URI(@@apiUrlsTemplates["repositoryUrl"].sub(/(.+?\/repos\/)user\/repository/, "\\1#{@user}\/#{@repository}")))
    return configuredUrls
  end
end


class GithubRepository < GithubAPI


  def initialize(repoString)
    repoInfo = self.parseRepoString(repoString)
    super(repoInfo["user"], repoInfo["repository"])
  end
  def getInformation
      repositoryData = self.callUrls()
      formatData(repositoryData)
  end

  def parseRepoString(repoString)
    repoCred = /([^\/]+)\/([^\/]+)$/.match(repoString)

    return {
      "user" => repoCred[1],
      "repository" => repoCred[2]
    }
  end

  def formatData(repositoryData)
    #puts repositoryData[2]["full_name"]
    puts repositoryData[0]["total_count"]
    puts repositoryData[1]["total_count"]

    #return repositoryData
  end
end

r = GithubRepository.new("https://github.com/openshift/origin")
r.getInformation()
#g = GithubAPI.new("openshift", "origin")
#data = g.callUrls()
#puts data