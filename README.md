# Rest API demo in ruby

Test of the github REST API

The whole program consists of 2 files.
First the github.rb is a ruby module which consists of 2 classes. API class handles fetching of github data through the github REST API. The repository class handles further processing and displaying of the fetched data.
The second file get_repo.rb is a simple switch statement which handles the flow of the script execution and some script argument checking action. The script can hadle strings in format https://github.com/<github_user>/<github_repository> and also shortened <github_user>/<github_repository>.
The result should look like this:

thedoctor@galactica:~/Development/ruby/ruby_github_demo$ ./get_repo.rb https://github.com/mcurlej/ruby_github_demo
mcurlej/ruby_github_demo
Issues (0): 0 open, 0 closed
thedoctor@galactica:~/Development/ruby/ruby_github_demo$ ./get_repo.rb openshift/origin
openshift/origin
Issues (3176): 810 open, 2366 closed
thedoctor@galactica:~/Development/ruby/ruby_github_demo$
