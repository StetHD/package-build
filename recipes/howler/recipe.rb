#!/bin/env ruby
# encoding: utf-8

# THIS SHOULD NOT BE USED ANYMORE, BECAUSE THE BINARIES FOR THIS PROJECT ARE NOW
# COMPILED AND DISTRIBUTED VIA CI JOBS.

class Howler < FPM::Cookery::Recipe
  description "Howler: waits to hear something in the Marathon Event Bus and shouts it to the other monkeys"
  GOPACKAGE = "github.com/zalando-incubator/howler"

  name      "howler"
  version   "0.0.8"
  revision  201602111024

  homepage      "https://github.com/zalando-incubator/howler"
  source        "https://github.com/zalando-incubator/howler.git", :with => :git, :tag => "#{version}"
  maintainer    "Sören König <soeren.koenig@zalando.de>"

  build_depends   "golang-go git"

  def build
    # Set up directory structure and $GOPATH.
    pkgdir = builddir("gobuild/src/#{GOPACKAGE}")
    mkdir_p pkgdir
    cp_r Dir["*"], pkgdir

    ENV["GOPATH"] = builddir("gobuild/")

    # Install dependencies.
    safesystem "go get github.com/tools/godep"
    safesystem "cd ${GOPATH}/src/#{GOPACKAGE} && ${GOPATH}/bin/godep restore"
    safesystem "go install -tags zalando #{GOPACKAGE}/..."
  end

  def install
    bin.install builddir("gobuild/bin/#{name}")
  end

  def after_install
    # For allowing more than one successive builds, there has some cleanup to be done.
    # If the build cookie is still existing on the second run, fpm-cook will stop and
    # not build the binary again.
    package_name = "#{name}-#{version}"
    build_cookie_name = (builddir/".build-cookie-#{package_name.gsub(/[^\w]/,'_')}").to_s
    rm_rf "#{build_cookie_name}", :verbose => true
  end
end
