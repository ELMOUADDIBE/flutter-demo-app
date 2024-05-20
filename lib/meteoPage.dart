import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MeteoPage extends StatefulWidget {
  const MeteoPage({super.key});

  @override
  State<MeteoPage> createState() => _MeteoPageState();
}

class _MeteoPageState extends State<MeteoPage> {
  String _city = '';
  String _weather = '';
  final String apiKey = '1d7c57890314ab4ba48803b4944e1021';

  void _updateCity(String newCity) {
    setState(() {
      _city = newCity;
    });
  }

  Future<void> _getWeather() async {
    if (_city.isEmpty) return;

    final url = Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$_city&appid=$apiKey&units=metric');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _weather = '${data['name']} Weather: ${data['weather'][0]['main']}';
        _weather += '\nTemperature: ${data['main']['temp']}°C';
        _weather += '\nMin Temperature: ${data['main']['temp_min']}°C';
        _weather += '\nMax Temperature: ${data['main']['temp_max']}°C';
        _weather += '\nHumidity: ${data['main']['humidity']}%';
      });
    } else {
      setState(() {
        _weather = 'Failed to get weather data';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Enter city name',
                hintText: 'e.g., Mohammadia',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: _updateCity,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getWeather,
              child: const Text('Get Weather'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Center(
                child: _city.isEmpty
                    ? const Text('No city entered')
                    : _weather.isEmpty
                    ? const CircularProgressIndicator()
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _weather,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    const Icon(
                      Icons.wb_sunny,
                      color: Colors.orange,
                      size: 50,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}