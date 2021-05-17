```dart
double _volume = 50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              InputSlider(
                  onChange: (value) {
                    setState(() {
                      _volume = value;
                    });
                  },
                  min: 0.0,
                  max: 100.0,
                  decimalPlaces: 0,
                  value: _volume,
                  activeSliderColor: Colors.green,
                  inactiveSliderColor: Colors.green[100],
                  leading: Icon(Icons.volume_down)),
              _volumeDisplay()
            ],
          ),
        ));
  }

  Widget _volumeDisplay() {
    if (_volume < 30) return Text("Turn it up!");
    if (_volume < 70) return Text("Nice volume :-)");
    return Text("Ahhhh! My ears!");
  }
```
