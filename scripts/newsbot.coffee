# Description:
#   Example scripts for you to examine and try out.
#
# Notes:
#   They are commented out by default, because most of them are pretty silly and
#   wouldn't be useful and amusing enough for day to day huboting.
#   Uncomment the ones you want to try and experiment with.
#
#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md

module.exports = (robot) ->

  robot.hear /twitter.com\/(.*)\//i, (res) ->
    res.send "Recorded tweet ... checking for obvious problems ..."
    res.send "• YES Found user @" + res.match[1] + " is already in the database"
    res.send "... Tineye-all-the-things! mode is enabled [configure]"
    res.send "... Performing Tineye search [$0.06]"

  robot.hear /665313496406429698/, (res) ->
    res.send "That photo is from January"

  robot.respond /open the (.*) doors/i, (res) ->
    doorType = res.match[1]
    if doorType is "pod bay"
      res.reply "I'm afraid I can't let you do that."
    else
      res.reply "Opening #{doorType} doors"

  robot.hear /stampit/i, (res) ->
    res.emote "• Stamping it with current verification status: unknown"
    sleep(10)
    res.send "http://blogcenter.readingeagle.com/digital-watch-by-adam-richter/wp-content/uploads/sites/11/2015/11/January-2015.jpg"

  statuses = ['fake', 'true', 'unknown']

  robot.respond /checkstatus/i, (res) ->
    res.send res.random statuses

  # robot.topic (res) ->
  #   res.send "#{res.message.text}? That's a Paddlin'"

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

  # robot.respond /have a soda/i, (res) ->
  #   # Get number of sodas had (coerced to a number).
  #   sodasHad = robot.brain.get('totalSodas') * 1 or 0

  #   if sodasHad > 4
  #     res.reply "I'm too fizzy.."

  #   else
  #     res.reply 'Sure!'

  #     robot.brain.set 'totalSodas', sodasHad+1

  # robot.respond /sleep it off/i, (res) ->
  #   robot.brain.set 'totalSodas', 0
  #   res.reply 'zzzzz'
