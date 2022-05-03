class Message {
  String text;
  bool byMe;

  Message({required this.text, required this.byMe});
}

bool switcher = false;

class DummyData {
  late List<Message> messages;
  DummyData() {
    messages = [
      generateMessages("Hey"),
      generateMessages("Hi"),
      generateMessages("Don't know what to say"),
      generateMessages("It's just a test, dw."),
      generateMessages("Oh Alright, wanna play some co-op horror?"),
      generateMessages("Yeah! I love horror stuff"),
      generateMessages("You got a decent PC to run em?"),
      generateMessages("Yeah got a RX550 and an i3"),
      generateMessages("Cool..."),
      generateMessages("I know not much, but it works"),
      generateMessages("Bruh I run on integrated graphics."),
    ];
  }

  generateMessages(String text) {
    switcher = !switcher;
    return Message(byMe: switcher, text: text);
  }
}
