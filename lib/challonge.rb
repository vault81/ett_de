require 'faraday'
require 'oj'

class Challonge
  def get(url)
    resp = conn.get(g_url(url))
    Oj.load(resp.body, symbol_keys: true)
  end

  private

  def conn
    @conn ||=
      Faraday.new do |con|
        con.headers['Accept'] = 'application/json'

        # con.headers['Accept-Encoding'] = 'gzip, deflate, br'
        con.headers['User-Agent'] = 'ett.vlt81.de'
      end
  end

  def g_url(url)
    'https://api.challonge.com/v1/tournaments/' +
      "#{url}.json?api_key=#{key}&include_participants=1"
  end

  def key
    ENV['CHALLONGE_API_KEY']
  end
end
