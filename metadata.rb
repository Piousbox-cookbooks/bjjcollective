name               'bjjcollective'
maintainer         'wasya.co'
maintainer_email   'victor@wasya.co'
license            'All rights reserved'
description        'Installs/Configures bjjcollective'
long_description   IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version            '0.1.0'

%w{ ish application }.each do |cookbook|
  depends cookbook
end
