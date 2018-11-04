# 
# Retrieve a link to the latest compressed archive on github
# 
# @return A string with the name of the GPU vendor. 
#
# Returns an empty string if no GPU is detected or the vendor is not recognized. 
# If it outputs something else than 'NVIDIA', 'AMD' or '', an error occured.
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
