var _ = require('underscore');

var Hayo = Parse.Object.extend("Hayo")
var Friend = Parse.Object.extend("Friend")

Parse.Cloud.define("hayo", function(request, response) {

  console.log(request)

  var fromId = request.params.fromId
  var toId = request.params.toId
  var message = request.params.message
  var category = request.params.category

  var fromUser, toUser;

  console.log("userQuery start")
 
  findUserById(fromId)
  .then(function(result) {
    fromUser = result
    return findUserById(toId)
  }).then(function(result) {
    toUser = result
    console.log("fromUser: " + fromUser)
    console.log("toUser: " + toUser)
    return saveHayo(fromUser, toUser, message)
  }).then(function(result) {
    console.log("hayo saved: " + result)
    push(toId, fromUser.get("username") + " < " + message, category)
    response.success("hayo function success")
  }, function(error) {
    console.log("hayo save error: " + error.message)
    response.error(error)
  })
});


Parse.Cloud.beforeDelete(Parse.User, function(request, response) {
  var object = request.object
  console.log("beforeDelete User")
  deleteData("Hayo", "from", object)
  .then(function(result) {
    deleteData("Hayo", "to", object)    
  })
  .then(function(result) {
    deleteData("Friend", "from", object)    
  })
  .then(function(result) {
    deleteData("Friend", "to", object)    
  })
  .then(function(result) {
    response.success()
  }) 
});

function deleteData(tableName, propertyName, object) {
  query = new Parse.Query(tableName);
  query.equalTo(propertyName, object);
  return query.find()
  .then(function(results) {
    return Parse.Object.destroyAll(results)
  })
}

Parse.Cloud.define("makeFriends", function(request, response) {
  var fromId = request.params.fromId
  var toIds = request.params.toIds
  makeFriendsRecursively(fromId, toIds)
  .then(function(result) {
    console.log("result" + result)
    response.success(result)
  })
});

function makeFriendsRecursively(fromId, toIds) {
  var toId = toIds.pop(0)
  return makeFriendIfNeeded(fromId, toId)
  .then(function(result) {
    return makeFriendIfNeeded(toId, fromId)
  }).then(function(result) {
    if (toIds.length == 0) {
      return "completed"
    }
    return makeFriendsRecursively(fromId, toIds)
  })
}


Parse.Cloud.define("friendList", function(request, response) {
  var userId = request.params.userId

  var userQuery = new Parse.Query(Parse.User)
  userQuery.equalTo("objectId", userId)
  var friendQuery = new Parse.Query(Friend)
  friendQuery.matchesQuery("from", userQuery)
  friendQuery.select("to")
  friendQuery.include("to")
  return friendQuery.find()
  .then(function(results) {
    var users = _.map(results, function(friend) {
      console.log(friend)
      var to = friend.get("to")
      return to
    })
    var filtered = _.filter(users, function(friend) {
      console.log(friend)
      return friend !== undefined
    })
    response.success(filtered)
  })
});


Parse.Cloud.define("searchFriends", function(request, response) {
  var facebookIds = request.params.facebookIds
  var twitterIds = request.params.twitterIds
  var userQuery1 = new Parse.Query(Parse.User)
  userQuery1.containedIn("facebookId", facebookIds)
  var userQuery2 = new Parse.Query(Parse.User)
  userQuery2.containedIn("twitterId", twitterIds)
  var orQuery = Parse.Query.or(userQuery1, userQuery2).ascending("username")
  orQuery.find()
  .then(function(results) {
    response.success(results)
  })
})

function makeFriendIfNeeded(fromId, toId) {
  return existsFriend(fromId, toId)
  .then(function(result) {
    if (result) {    
      return
    }
    return linkFriend(fromId, toId)
  })
}

function findUserById(id) {
  var query = new Parse.Query(Parse.User)
  query.equalTo("objectId", id)
  return query.first().then(function(result) {
    return result.fetch()
  })
}

Parse.Cloud.define("hayoList", function(request, response) {
  console.log(request)

  var fromId = request.params.fromId
  console.log("fromId: " + fromId)
  var toId = request.params.toId
  console.log("toId: " + toId)
  var fromQuery = new Parse.Query(Parse.User)
  fromQuery.equalTo("objectId", fromId)
  var toQuery = new Parse.Query(Parse.User)
  toQuery.equalTo("objectId", toId)

  var hayoQuery1 = new Parse.Query(Hayo)
  hayoQuery1.matchesQuery("from", fromQuery)
  hayoQuery1.matchesQuery("to", toQuery)
  var hayoQuery2 = new Parse.Query(Hayo)
  hayoQuery2.matchesQuery("from", toQuery)
  hayoQuery2.matchesQuery("to", fromQuery)
  var orQuery = Parse.Query.or(hayoQuery1, hayoQuery2).ascending("createdAt")

  orQuery.find().then(function(results) {
    for (var i = 0; i < results.length; i++) {
      var hayo = results[i]
      console.log(hayo.get("message"))
      console.log("time: " + hayo.createdAt)
    }
    response.success(results)
  })
})

Parse.Cloud.define("hayoListAll", function(request, response) {
  console.log(request)

  var userId = request.params.userId
  var userQuery = new Parse.Query(Parse.User)
  userQuery.equalTo("objectId", userId)

  var hayoQuery1 = new Parse.Query(Hayo)
  hayoQuery1.matchesQuery("from", userQuery)
  var hayoQuery2 = new Parse.Query(Hayo)
  hayoQuery2.matchesQuery("to", userQuery)
  var orQuery = Parse.Query.or(hayoQuery1, hayoQuery2).ascending("createdAt")
  orQuery.include("to")
  orQuery.include("from")

  orQuery.find().then(function(results) {
    var filtered = _.filter(results, function(hayo) {
      console.log(hayo)
      return hayo.get("to") !== undefined && hayo.get("from") !== undefined
    })
    response.success(filtered)
  })
})

function existsFriend(fromUserId, toUserId) {
  var fromQuery = new Parse.Query(Parse.User)
  fromQuery.equalTo("objectId", fromUserId)
  var friendQuery = new Parse.Query(Friend)
  friendQuery.matchesQuery("from", fromQuery)
  var toQuery = new Parse.Query(Parse.User)
  toQuery.equalTo("objectId", toUserId)
  friendQuery.matchesQuery("to", toQuery)
  console.log("existsFriend")
  return friendQuery.find()
  .then(function (results) {
    return results.length > 0
  })
}

function saveHayo(fromUser, toUser, message) {
  var hayo = new Hayo()
  hayo.set("from", fromUser)
  hayo.set("to", toUser)
  hayo.set("message", message)
  return hayo.save()
}

function linkFriend(fromUserId, toUserId) {
  var fromUser, toUser;

  return findUserById(fromUserId)
  .then(function(result) {
    fromUser = result
    console.log(fromUser.username)
    return findUserById(toUserId)
  }).then(function(result) {
    toUser = result
    console.log(toUser.username)
    return saveFriend(fromUser, toUser)
  }).then(function(result) {
    return saveFriend(toUser, fromUser)
  })
}

function saveFriend(from, to) {
  var friend = new Friend()
  friend.set("from", from)
  friend.set("to", to)
  return friend.save()
}

function push(toId, message, category) {

  console.log("toId: " + toId)
  var userQuery = new Parse.Query(Parse.User)
  userQuery.equalTo("objectId", toId)

  var query = new Parse.Query(Parse.Installation);
  query.matchesQuery('user', userQuery);
 
  Parse.Push.send({
    where: query, // Set our Installation query
    data: {
      alert: message,
      sound: "sheep.caf",
      "content-available" : 1,
      category: category
    }
  }, {
    success: function() {
      console.log("Push was successful")
    },
    error: function(error) {
      console.log("Push was error")
    }
  });
}

function pushAll() {
    var query = new Parse.Query(Parse.Installation);
    Parse.Push.send({
      where: query, // Set our Installation query
      data: {
        alert: "The Giants won against the Mets 2-3."
      }
    }, {
      success: function() {
        // Push was successful
      },
      error: function(error) {
        // Handle error
      }
    });
}