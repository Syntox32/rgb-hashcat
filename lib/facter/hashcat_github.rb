# 
# Retrieve a link to the latest compressed archive on github
# 
# @return A link to the latest compressed archive from the official hashcat github
#
# This facter uses the github API to retrieve the latest compressed archive with 
# binaries from the official hashcat repositories.
#
require 'net/http'
require 'json'

Facter.add(:github_archive) do
	url = "https://api.github.com/repos/hashcat/hashcat/releases/latest"
	uri = URI(url)
	resp = Net::HTTP.get(uri)
	data = JSON.parse(resp)
	archive_url = data["assets"][0]["browser_download_url"]
	
	setcode do
		archive_url
	end
end

Facter.add(:github_archive_name) do
	url = "https://api.github.com/repos/hashcat/hashcat/releases/latest"
	uri = URI(url)
	resp = Net::HTTP.get(uri)
	data = JSON.parse(resp)
	archive_url = data["assets"][0]["browser_download_url"]
	
	setcode do
		File.basename(archive_url, File.extname(archive_url))
	end
end
