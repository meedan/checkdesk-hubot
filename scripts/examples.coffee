# Description:
#   Example scripts for you to examine and try out.

# Notes:
#   They are commented out by default, because most of them are pretty silly and
#   wouldn't be useful and amusing enough for day to day huboting.
#   Uncomment the ones you want to try and experiment with.

#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md

module.exports = (robot) ->

  robot.router.get "/hello", (req, res) -> res.end "Hello"

  robot.hear /twitter.com\/(.*)\//i, (res) ->
    res.send "Recorded tweet ... checking for obvious problems ..."
    res.send "• YES Found user @" + res.match[1] + " is already in the database"
    res.send "... Tineye-all-the-things! mode is enabled [configure]"
    res.send "... Performing Tineye search [$0.06]"

  robot.respond /check image 66531/, (res) ->
    res.send "That photo is from January"

  robot.respond /open the (.*) doors/i, (res) ->
    doorType = res.match[1]
    if doorType is "pod bay"
      res.reply "I'm afraid I can't let you do that."
    else
      res.reply "Opening #{doorType} doors"

  robot.hear /stampit (.*)/i, (res) ->
    res.emote "• Stamping it with current verification status: #{res.match[1]}"
    res.send "http://blogcenter.readingeagle.com/digital-watch-by-adam-richter/wp-content/uploads/sites/11/2015/11/January-2015.jpg"

  statuses = ['fake', 'true', 'unknown']

  robot.respond /checkstatus/i, (res) ->
    res.send res.random statuses

  enterReplies = ['Hi there', 'Howdy', 'Hello.', 'Hello friend.', 'Hai', 'Hallos']
  leaveReplies = ['Bye', 'cya', 'peace']

  robot.enter (res) ->
    res.send res.random enterReplies
  robot.leave (res) ->
    res.send res.random leaveReplies

  robot.error (err, res) ->
    robot.logger.error "Sorry, I didn't understand"

    if res?
      res.reply "Sorry I don't understand"
