// The one piece of "business logic" in our app.
function greet(name) {
  return 'Hi, ' + name + '! Welcome to DevOps.';
}

// Lets the test (running in Node) load this file too.
if (typeof module !== 'undefined') {
  module.exports = { greet };
}
