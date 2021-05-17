[![Pub](https://img.shields.io/pub/v/input_slider.svg)](https://pub.dev/packages/input_slider)

# input_slider

While Sliders offer a quick and visual way to change a value, it can be hard to achieve precise inputs with them. Additionally, some users really dislike Sliders, and especially on small devices they can get quite fiddly. One way to use the advantages of having a Slider while minimizing the drawbacks is to add an additional alternativ (text) input field.

This packages InputSlider combines a TextField with a Slider and synchronizes both of them. They share the same minimum and maximum values and changes to one also changes the other. Optionally, you can also specify a leading widget, such as a label Text or Icon. 

## Usage
```dart 
InputSlider(
  onChange: (value) => print("change: $value"),
  min: 0.0,
  max: 100.0,
  decimalPlaces: 0,
  value: 50.0,
  leading: Text("Percentage:"),
)
```
