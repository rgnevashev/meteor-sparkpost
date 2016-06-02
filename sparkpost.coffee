
class SparkPostClass

  sendTemplate: (id, message) ->
    recipients = []
    data = message.data or {}
    if _.isArray(message.to)
      recipients = _.map message.to, (to) ->
        address: to
    else
      recipients.push address: message.to
    @api 'POST', 'transmissions?num_rcpt_errors=3',
      data:
        recipients: recipients
        content:
          template_id: id
        substitution_data: data
        options:
          inline_css: true

  renderTemplate: (id, data = {}) ->
    @api 'POST', "templates/#{id}/preview?draft=true",
      data:
        substitution_data: data

  config: (options) ->
    @options = _.defaults options,
      username: "SMTP_Injection"
      port: "587"
      host: "smtp.sparkpostmail.com"
      baseUrl: "https://api.sparkpost.com/api/v1/"
      enableSMTP: true
    process.env.MAIL_URL = "smtp://#{@options.username}:#{@options.key}@#{@options.host}:#{@options.port}" if @options.enableSMTP
    @headers =
      'Content-Type': 'application/json'
      'Accept': 'application/json'
      'Authorization': @options.key or ''

  api: (method, path, options = {}, callback) ->
    url = @options.baseUrl + path
    options = _.defaults options,
      headers: @headers
    try
      res =
        if !!callback
          if method in ['DEL','del']
            HTTP.del url, options, callback
          else
            HTTP.call method, url, options, callback
        else
          if method in ['DEL','del']
            HTTP.del url, options
          else
            HTTP.call method, url, options
      if res.data?.results then res.data.results else res.data
    catch e
      if e.response.data?.errors
        console.error "SparkPost: #{e.response.data.errors[0].message} [#{e.response.data.errors[0].description}]"
        e.response.data.errors[0]
      else
        console.error 'SparkPost: unknow error'


@SparkPost = new SparkPostClass
