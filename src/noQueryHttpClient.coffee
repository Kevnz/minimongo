# Create default JSON http client
module.exports = (method, url, params, data, success, error) ->
  # Append
  fullUrl = url + "?" + $.param(params)

  if method == "GET"
    req = fetch(fullUrl)
        .then (response) -> 
            response.json()
  else if method == "DELETE"
    req = fetch(fullUrl, { method : 'DELETE'})
  else if method == "POST" or method == "PATCH"
    req = fetch(fullUrl, {
      body : JSON.stringify(data),
      headers: {
        'Content-Type' : 'application/json'
      },
      method : method
    })

  req.then (response, textStatus, jqXHR) ->
    # Add debugging for https://github.com/mWater/minimongo/issues/16
    if not response?
      console.error("Empty response: #{fullUrl}:#{method} returned " + jqXHR.responseText + " as JSON " + JSON.stringify(response))

    success(response or null)
  req.catch (jqXHR, textStatus, errorThrown) ->
    if error
      error(jqXHR)
