#!/usr/bin/env ruby
# frozen_string_literal: true

# Usage: update_formula.rb <sdkman-cli version> <sdkman-cli-native tag>, e.g. update_formula.rb 5.24.0 v0.8.0
# Renders Formula/sdkman-cli.rb from .github/templates/sdkman-cli.rb.erb with the
# urls and checksums of the given sdkman-cli and sdkman-cli-native releases.

require "digest"
require "erb"
require "fileutils"
require "open-uri"

ROOT = File.expand_path("../..", __dir__)
TEMPLATE = File.join(ROOT, ".github/templates/sdkman-cli.rb.erb")
FORMULA = File.join(ROOT, "Formula/sdkman-cli.rb")
TARGETS = %w[
  aarch64-apple-darwin
  x86_64-apple-darwin
  aarch64-unknown-linux-gnu
  x86_64-unknown-linux-gnu
].freeze

def sha256_of(url)
  Digest::SHA256.hexdigest(URI.open(url, "rb", &:read))
end

cli_version = ARGV.fetch(0)
native_tag = ARGV.fetch(1)
native_version = native_tag.delete_prefix("v")

cli_url = "https://github.com/sdkman/sdkman-cli/releases/download/#{cli_version}/sdkman-cli-#{cli_version}.zip"
cli_sha256 = sha256_of(cli_url)

url = TARGETS.to_h do |target|
  [target, "https://github.com/sdkman/sdkman-cli-native/releases/download/#{native_tag}/sdkman-cli-native-#{native_version}-#{target}.zip"]
end
sha256 = url.transform_values { |link| sha256_of(link) }

FileUtils.mkdir_p(File.dirname(FORMULA))
File.write(FORMULA, ERB.new(File.read(TEMPLATE), trim_mode: "-").result(binding))
