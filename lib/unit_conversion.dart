import 'package:flutter/material.dart';

class ConverterScreen extends StatefulWidget {
  @override
  _ConverterScreenState createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  double _inputValue = 0.0;
  double _convertedValue = 0.0;
  String _selectedUnit = 'Meter';

  void _convert(double value, String unit) {
    setState(() {
      _inputValue = value;
      _selectedUnit = unit;
      if (unit == 'Meter') {
        _convertedValue = value * 100; // Convert to centimeters
      } else {
        _convertedValue = value / 100; // Convert to meters
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Unit Converter'),
        backgroundColor: Colors.black, // Set app bar background color to black
      ),
      backgroundColor: Colors.grey[900], // Set scaffold background color to dark grey
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) => _convert(double.parse(value), _selectedUnit),
              decoration: InputDecoration(
                labelText: 'Enter value in $_selectedUnit',
                labelStyle: TextStyle(color: Colors.white), // Set label text color to white
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue), // Set border color to blue
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue), // Set enabled border color to blue
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue), // Set focused border color to blue
                ),
              ),
              style: TextStyle(color: Colors.white), // Set text color to white
            ),
            DropdownButton<String>(
              value: _selectedUnit,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedUnit = newValue!;
                  _convert(_inputValue, _selectedUnit);
                });
              },
              items: <String>['Meter', 'Centimeter'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: TextStyle(color: Colors.white)), // Set dropdown text color to white
                );
              }).toList(),
              dropdownColor: Colors.grey[800], // Set dropdown background color to dark grey
            ),
            SizedBox(height: 20),
            Text(
              'Converted value: $_convertedValue',
              style: TextStyle(color: Colors.white), // Set text color to white
            ),
          ],
        ),
      ),
    );
  }
}
