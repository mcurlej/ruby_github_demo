#!/usr/bin/ruby

require 'net/http'
require 'json'
require './github'



case ARGV[0]
when nil
  Github::Repository.displayHelp()
when "-h"
  Github::Repository.displayHelp()
else
  github = Github::Repository.new(ARGV[0])
  github.getRepoInfo()
end
