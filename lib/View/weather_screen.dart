import 'package:flutter/material.dart';
import 'package:whether_app/View/Service/WeatherApis/apis.dart';
import 'package:whether_app/View/Service/WeatherApis/weather_model.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<WeatherScreen> {
  String message = 'Search for the location to get Weather data';
  Widget _buildWeatherWidgets(){
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    if (response == null){
      return  Text(message,style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w500),);
    }else {
      return  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Icon(Icons.location_on_outlined,size: 60),
                Text(response?.location?.name?? '',style: const TextStyle(fontSize: 40,fontWeight: FontWeight.w400)),
                 SizedBox(width: width * 0.03),
                Text(response?.location?.country?? '',style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w300)),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text('${response?.current?.tempC.toString()??''} °c' ,style: const TextStyle(fontSize: 55,fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 10),
                Text((response?.current?.condition?.text.toString()??'' ),style: const TextStyle(fontSize: 23,fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          Center(
            child: SizedBox(
                height: height * 0.25,
                child: Image.network('https:${response?.current?.condition?.icon}'.replaceAll('64x64','128x128'),
                  scale: 0.6,)),
          ),

           Card(
            elevation: 5,
            color: Colors.white,

            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _dataAndTitleWidgets('Humidity',response?.current?.humidity?.toString()?? ''),
                    _dataAndTitleWidgets('Wind Speed','${response?.current?.humidity?.toString()?? ''}km/h'),
                  ],
                ), Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _dataAndTitleWidgets('UV',response?.current?.uv?.toString()?? ''),
                    _dataAndTitleWidgets('Perception','${response?.current?.humidity?.toString()?? ''}km/h'),
                  ],
                ), Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // To get only the time (HH:mm)
                    _dataAndTitleWidgets('Local Time', response?.location?.localtime?.split(' ').last ?? ''),

                    // To get only the date (yyyy-MM-dd)
                    _dataAndTitleWidgets('Local Date',response?.location?.localtime?.split(' ').first ?? ''),

                  ],
                ),
              ],
            ),
          )
        ],
      );
    }
  }
  Widget _dataAndTitleWidgets(String title,String data ){
    return  Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(data,style: const TextStyle(fontSize: 30,fontWeight: FontWeight.w600),),
          Text(title,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
  ApiResponse? response;
  bool isLoading = false;
  _getWeatherData(String location) async{
setState(() {
  isLoading = true;
});
    try {
       response = await WeatherApis().getCurrentWeather(location);

    }catch (e){
      setState(() {
        message = 'Field to get weather';
        response = null;
      });
    }finally {
      setState(() {
        isLoading = false;
      });
    }

  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return  SafeArea(
        child: Scaffold(

          /// SearchBar
          body: Padding(padding: const EdgeInsets.all(20),

          child: SingleChildScrollView(
            child: Column(
              children: [
                SearchBar(
                  textStyle: const WidgetStatePropertyAll(TextStyle(fontSize: 20,fontWeight: FontWeight.w500)),
                  hintText: 'Search any location',
                  onSubmitted: (value) {
                    _getWeatherData(value);
                },
                ),
                const SizedBox(height: 15),
                if(isLoading ) const CircularProgressIndicator()
                else _buildWeatherWidgets(),

                SizedBox(height: height * 0.05)
            
              ],
            ),
          ),
          ),
        ));
  }
}
