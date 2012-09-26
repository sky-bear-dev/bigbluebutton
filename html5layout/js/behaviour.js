var layout = $("#layout");
var chat = $("#chat-btn");
var users = $("#users-btn");

chat.click(function() {
	layout.toggleClass("chat-enabled");
	chat.toggleClass("active", layout.hasClass("chat-enabled"));
});
users.click(function() {
	layout.toggleClass("users-enabled");
	users.toggleClass("active", layout.hasClass("users-enabled"));
});
