// Greet the visitor by the name in the URL, e.g. ?name=Asha
const params = new URLSearchParams(window.location.search);
const visitor = params.get('name');
if (visitor) {
  // textContent treats the value as plain text, never as HTML
  document.getElementById('msg').textContent = 'Hello, ' + visitor + '!';
}
