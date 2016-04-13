part of nest_ui;

class Component extends Object with observable.Subscriber,
                                    observable.Publisher,
                                    HeritageTree,
                                    Attributable
{

  /* Events emitted by the browser that we'd like to handle
  *  if you prefer to not listen to them all for your component,
  *  simply list the ones you'd like to listen to, ommiting all the others.
  *
  *  native_events_list is a variable defined in native_events_list.dart
  *  and it simply contains a List of all events Dart is capable of catching.
  */
  List native_events = native_events_list;  

  // a DOM element associated with this component
  HtmlElement _dom_element; 

  Map  behaviors     = {}; 

  get dom_element => _dom_element;
  set dom_element(HtmlElement el) {
    _dom_element = el;
    _listen_to_native_events();
  }
  
  Component() {
  }

  _listen_to_native_events() {
     this.native_events.forEach((e) {
      dom_element.on[e].listen((e) => this.captureEvent(e.type, [#self]));
    }); 
  }

}
