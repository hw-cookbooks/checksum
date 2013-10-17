version = Chef::Version.new(Chef::VERSION)
use_inline_resources if version.major >= 11

def load_current_resource
  @path = new_resource.name
  @checksum = new_resource.checksum
end

action :verify do

  begin
    require 'digest/sha1'

    filesum = Digest::SHA1.file(@path).hexdigest
    if @checksum == filesum
      Chef::Log.info "SHA1 checksum match"
    else
      Chef::Log.error "SHA1 checksum mismatch"
    end

  rescue Errno::ENOENT
    Chef::Log.error "#{@path} is not a valid file to checksum"
  end

end
