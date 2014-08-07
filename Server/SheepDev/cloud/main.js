var _ = require('underscore');

var Hayo = Parse.Object.extend("Hayo")

Parse.Cloud.define("hello", function(request, response) {
    pushAll()
  response.success("Hello world!");
});

Parse.Cloud.define("hayo", function(request, response) {

  console.log(request)

  var from = request.params.from
  var to = request.params.to
  var message = request.params.message


  var fromUser, toUser;

  console.log("userQuery start")
  var fromQuery = new Parse.Query(Parse.User)
  fromQuery.equalTo("username", from)

  fromQuery.first().then(function(result) {
    console.log("hoge")
    return result.fetch()
  }).then(function(result) {
    fromUser = result
    var toQuery = new Parse.Query(Parse.User)
    toQuery.equalTo("username", to)
    return toQuery.first()
  }).then(function(result) {
    return result.fetch()
  }).then(function(result) {
    toUser = result
    console.log("fromUser: " + fromUser)
    console.log("toUser: " + toUser)
    saveHayo(fromUser, toUser, message, function(hayo) {
      console.log("hayo saved: " + hayo)
      push(to, fromUser.get("nickname") + " < " + message)
      response.success("hayo function success")
    })
  })
});

Parse.Cloud.define("hayoList", function(request, response) {
  console.log(request)

  var userId = request.params.userId
  var userQuery = new Parse.Query(Parse.User)
  userQuery.equalTo("objectId", userId)

  console.log("userId: " + userId)

  var hayoQuery = new Parse.Query(Hayo)
  hayoQuery.matchesQuery("from", userQuery)

  hayoQuery.find().then(function(results) {
    for (var i = 0; i < results.length; i++) {
      var hayo = results[i]
      console.log(hayo.get("message"))
    }
    response.success(results)

  })
})

function saveHayo(fromUser, toUser, message, callback) {
  var hayo = new Hayo()
  hayo.set("from", fromUser)
  hayo.set("to", toUser)
  hayo.set("message", message)
  hayo.save(null, {
    success: function(hayo) {
      callback(hayo)
    },
    error: function(hayo, error) {
      alert("hayo save error: " + error.message)
      callback(undefined)
    }
  })
}

function push(to, message) {

  console.log("to: " + to)
  var userQuery = new Parse.Query(Parse.User)
  userQuery.equalTo("username", to)

  var query = new Parse.Query(Parse.Installation);
  query.matchesQuery('user', userQuery);
 
  Parse.Push.send({
    where: query, // Set our Installation query
    data: {
      alert: message,
      sound: "sheep.caf"
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