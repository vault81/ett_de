require 'rack'
require 'uri'

class AppsignalURLRack
  def initialize(app, options = {})
    @app = app
    @options = options
  end

  def call(env)
    req = Rack::Request.new(env)

    env['appsignal.route'] = "#{req.request_method} #{res_path(req)}"

    @app.call(env)
  end

  private

  def res_path(req)
    path = URI.parse(req.url).path

    if path.start_with?('/assets')
      '/assets'
    elsif path.start_with?('/players')
      res(path, 'players')
    elsif path.start_with?('/tournaments')
      res(path, 'tournaments')
    else
      path
    end
  end

  def res(path, name)
    if path.end_with?(name)
      "/#{name}"
    elsif path.end_with?('new')
      "/#{name}/new"
    else
      "/#{name}/:id"
    end
  end
end
