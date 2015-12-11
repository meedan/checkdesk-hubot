#
#   Description:
#     Newsbot intelligence. Sends a link to the Checkdesk memebuster.
#
#   Configuration:
#     None
#
#   Commands:
#     memebuster [link]
#       opens a new link in the memebuster
#
#   Author:
#    Meedan, Chris Blow
#
module.exports = (robot) ->
  robot.respond /memebuster (.*) (.*) (.*)/i, (res) ->
    link = res.match[1]
    res.send "http://localhost:4567/?link=#{link}&image=#{res.match[2]}&credit=#{res.match[3]}"
