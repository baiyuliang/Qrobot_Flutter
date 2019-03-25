import 'package:event_bus/event_bus.dart';
EventBus eventBus = new EventBus();
class EventRobotRespone {

  String message;

  EventRobotRespone(message) {
    this.message = message;
  }
}
