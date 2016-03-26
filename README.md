# Rest API demo in ruby

Test of the github REST API

The whole program consists of 2 files.__
First the github.rb is a ruby module which consists of 2 classes. API class handles fetching of github data through the github REST API. The repository class handles further processing and displaying of the fetched data.__
The second file get_repo.rb is a simple switch statement which handles the flow of the script execution and some script argument checking action. The script can hadle strings in format https://github.com/<github_user>/<github_repository> and also shortened <github_user>/<github_repository>.__
The result should look like this:__
__
thedoctor@galactica:~/Development/ruby/ruby_github_demo$ ./get_repo.rb https://github.com/mcurlej/ruby_github_demo__
mcurlej/ruby_github_demo__
Issues (0): 0 open, 0 closed__
thedoctor@galactica:~/Development/ruby/ruby_github_demo$ ./get_repo.rb openshift/origin__
openshift/origin__
Issues (3176): 810 open, 2366 closed__
thedoctor@galactica:~/Development/ruby/ruby_github_demo$__
