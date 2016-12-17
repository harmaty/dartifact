part of nest_ui;

/** This is a basic component for form fields, from which most other form field components should inherit.
  * The important thing that it does, it defines a `value_holder` concept - a part inside the DOM-structure
  * that actually holds the value (an input) and is being submitted when the form is submitted.
  *
  * Properties description:
  *
  *   * `validation_errors_summary` - validations errors are dumped there as text;
  *                                   Have a property element in the DOM structure to display them automatically.
  *   * `name`                      - name of the http param that's being sent to the server.
  *   * `disabled`                  - if set to true, the UI element doesn't respond to any input/events.
  *
  */
class FormFieldComponent extends Component {

  List   native_events                = ["value_holder.change", "change", "!value_holder.keyup", "keyup", "keypress", "keydown"];
  List   no_propagation_native_events = ["change"];
  String value_property  = 'value';
  List   attribute_names = ["validation_errors_summary", "name", "disabled"];
  List   behaviors       = [FormFieldComponentBehaviors];

  FormFieldComponent() {

    attribute_names.add(this.value_property);
    attribute_callbacks[this.value_property] = (attr_name, self) {
      prvt_setValueForValueHolderElement(self.attributes[self.value_property]);
      self.publishEvent("change", self);
    };

    event_handlers.addForEvent('change', {
        #self:               (self,event) => self.prvt_updateValueFromDom(),
        'self.value_holder': (self,event) => self.prvt_updateValueFromDom()
      }
    );

    event_handlers.add(event: 'keyup', role: 'self.value_holder', handler: (self,event) {
      prvt_updateValueFromDom();
    });

  }

  void afterInitialize() {
    super.afterInitialize();
    prvt_updateValueFromDom();
  }

  @override
  bool validate({ deep: true }) {
    super.validate();
    return valid;
  }

  /** Resets the value of the field to the initial state */
  void reset() {
    this.value = null;
    value_holder_element.value = null;
  }

  /** Component HTML code may consits of various tags, where, for example, a DIV wraps the actual field
    * holding the value. This is why we need a special element inside the DOM-structure of the component
    * called "value_holder". It's usually an input, hidden or not - depends on how a particular FormFieldComponent
    * is designed.
    */
  get value_holder_element {
    var value_holder = this.firstDomDescendantOrSelfWithAttr(
      this.dom_element, attr_name: 'data-component-part', attr_value: 'value_holder'
    );
    if(value_holder == null)
      value_holder = this.dom_element;
    return value_holder;
  }

  prvt_setValueForValueHolderElement(v) {
    attributes["value"] = v;
    v == null ? v = "" : v = v.toString();
    this.value_holder_element.value = v;
    if(this.value_holder_element is TextAreaElement)
      this.value_holder_element.text = v;
  }

  void prvt_updateValueFromDom() {
    this.updateAttributes({ "$value_property" : (value_holder_element.value == "" ? null : value_holder_element.value)});
  }

}
