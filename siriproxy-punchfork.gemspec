# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "siriproxy-punchfork"
  s.version     = "0.0.1" 
  s.authors     = ["rakusu"]
  s.email       = [""]
  s.homepage    = ""
  s.summary     = %q{Siri controlled random recipe PunchFork generator}
  s.description = %q{Ask Siri what's for dinner and she'll return a random recipe from PunchFork}

  s.rubyforge_project = "siriproxy-punchfork"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "json"
  s.add_runtime_dependency "httparty"
end

