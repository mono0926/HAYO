
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
    pushAll()
  response.success("Hello world!");
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