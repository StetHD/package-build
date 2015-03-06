class Python3Boto3 < FPM::Cookery::Recipe
  # This is a bit hacky: boto3 is installed via pip3 into the destdir,
  # which is going to be packaged by fpm afterwards. So the 'source'
  # attribute is actually not needed, but syntactically required.
  # This creates the python3-boto3 package with all it's dependencies.
  description "Python interface to Amazon's Web Services"

  name     'python3-boto3'
  version  '0.0.10'
  revision 0
  homepage 'http://aws.amazon.com/sdk-for-python/'
  source   'https://github.com/boto/boto3.git', :with => :git, :tag => "#{version}"

  build_depends 'python3-setuptools'

  def build
    safesystem '/usr/bin/easy_install3 pip'
  end

  def install
    with_trueprefix do
        safesystem "/usr/local/bin/pip3 install boto3==#{version} --target #{destdir}/usr/local/lib/python3.2/dist-packages/"
    end
  end
end
