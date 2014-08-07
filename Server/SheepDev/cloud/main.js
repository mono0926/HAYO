
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
    pushAll()
  response.success("Hello world!");
});

Parse.Cloud.define("push", function(request, response) {

  console.log(request)

  var from = request.params.from
  var to = request.params.to
  var message = request.params.message

  console.log("to: " + to)
  push(to)


  response.success("hoge")
});

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

function push(to) {

  console.log("to: " + to)
  var userQuery = new Parse.Query(Parse.User)
  userQuery.equalTo("username", to)

  var query = new Parse.Query(Parse.Installation);
  query.matchesQuery('user', userQuery);
 
  Parse.Push.send({
    where: query, // Set our Installation query
    data: {
      alert: "Willie Hayes injured by own pop fly."
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