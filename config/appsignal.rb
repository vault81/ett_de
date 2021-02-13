require 'appsignal' # Load AppSignal

Appsignal.config =
Appsignal::Config.new(Hanami.root, (Hanami.env), name: 'ett_de')

Appsignal.start
Appsignal.start_logger

