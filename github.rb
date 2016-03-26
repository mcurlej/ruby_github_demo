# Library which fetches and processes github information through its REST API
module Github

# API class responsible for interacting with github REST API
  class API


    def initialize(user, repository)
      @user = user
      @repository = repository
# the default urls which will use to communicate with the api
# Set the per_page parameter to 1 so the response doesnt return data that we dont need (cant set 0 it will return 100 as default)
      @apiUrlsTemplates = {
         "issuesOpenUrl" => "https://api.github.com/search/issues?q=repo:user/repository+is:issue+is:open+&per_page=1",
         "issuesClosedUrl" => "https://api.github.com/search/issues?q=repo:user/repository+is:issue+is:closed+&per_page=1",
# NOTE: Was not specified if the name should be returned from github. To be safe the api is also returning the repository object where i getting the name of the repo.
         "repositoryUrl" => "https://api.github.com/repos/user/repository"
      }
    end

    def callUrls
      repositoryData = []
      configuredUrls = configUrls()

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

      configuredUrls.push(URI(@apiUrlsTemplates["issuesOpenUrl"].sub(/(.+\?q=repo:)user\/repository(.+)/, "\\1#{@user}\/#{@repository}\\2")))
      configuredUrls.push(URI(@apiUrlsTemplates["issuesClosedUrl"].sub(/(.+\?q=repo:)user\/repository(.+)/, "\\1#{@user}\/#{@repository}\\2")))
      configuredUrls.push(URI(@apiUrlsTemplates["repositoryUrl"].sub(/(.+?\/repos\/)user\/repository/, "\\1#{@user}\/#{@repository}")))
      return configuredUrls
    end

    protected :callUrls
    private :configUrls

  end

# A repository class for the API for further processing of data from the API
  class Repository < API


    def initialize(repoString)
      repoInfo = parseRepoString(repoString)
# initializing the parent
      super(repoInfo["user"], repoInfo["repository"])
    end

    def getRepoInfo
        repositoryData = callUrls()
        formatData(repositoryData)
    end

    def parseRepoString(repoString)
# parse the correct github user and repository from the string provided as argument
      repoCred = /([^\/]+)\/([^\/]+)$/.match(repoString)
      if !repoCred
        puts "The argument repository string provided is not a valid repository!\n"
        self.class.displayHelp()
        abort()
      end
      return {
        "user" => repoCred[1],
        "repository" => repoCred[2]
      }
    end

    def formatData(repositoryData)
      openIssues = repositoryData[0]["total_count"]
      closedIssues = repositoryData[1]["total_count"]
      repoName = repositoryData[2]["full_name"]
      puts repoName
      puts "Issues (#{openIssues+closedIssues}): #{openIssues} open, #{closedIssues} closed"
    end

    def self.displayHelp
        puts "Usage:
        -h - will display this help
        <github_user>/<github_repository> - will display the name of the repository, and number of opened and closed issues.
        https://github.com/<github_user>/<github_repository> - will display the name of the repository, and number of opened and closed issues."
    end

    private :formatData, :parseRepoString
  end

end
