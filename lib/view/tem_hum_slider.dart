import 'package:flutter/material.dart';

class TemHumSlider extends StatelessWidget {
  final Function(int) onChange;
  final int currentSlide;
  final String hum;
  final String tem;
  const TemHumSlider({
    super.key,
    required this.onChange,
    required this.currentSlide,
    required this.hum,
    required this.tem,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10,right: 10,bottom: 10,top : 20),
      child: Stack(
        alignment: Alignment.center,
      children: [
        SizedBox(
          height: 130,
          width: 280,
          child: PageView.builder(
            onPageChanged: onChange,
            itemCount: 2,
            itemBuilder: (context, index) {
              if (index == 0) {
                if(double.parse(tem) <= 15){
                  return Container(
                      height: 130,
                      width: 280,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color.fromARGB(255, 167, 248, 228), // Màu nền của container
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/icons/thermometer.png",
                              width: 54,height: 54,
                            ),
                            Text(
                            '$tem ℃', // Thay đổi độ ẩm tùy theo dữ liệu thực tế
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 32,
                            ),
                          ),
                          ],
                        )
                      ),
                    );
                }else if(double.parse(tem) >= 15 && double.parse(tem) <= 30){
                  return Container(
                      height: 110,
                      width: 240,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color.fromARGB(255, 166, 253, 125), // Màu nền của container
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/icons/thermometer.png",
                              width: 54,height: 54,
                            ),
                            Text(
                            '$tem ℃', // Thay đổi độ ẩm tùy theo dữ liệu thực tế
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 32,
                            ),
                          ),
                          ],
                        )
                      ),
                    );
                }else{
                  return Container(
                      height: 110,
                      width: 240,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color.fromARGB(255, 253, 202, 125), // Màu nền của container
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/icons/thermometer.png",
                              width: 54,height: 54,
                            ),
                            Text(
                            '$tem ℃', // Thay đổi độ ẩm tùy theo dữ liệu thực tế
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 32,
                            ),
                          ),
                          ],
                        )
                      ),
                    );
                }
                
                

              }else{
                if(double.parse(hum) <= 10){
                  return Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromARGB(255, 203, 236, 241), // Màu nền của container
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/icons/humidity.png",
                              width: 54,height: 54,
                      ),
                      Text(
                        '$hum %', // Thay đổi độ ẩm tùy theo dữ liệu thực tế
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                      ],
                    )
                  ),
                );
                }else if(double.parse(hum) > 10 && double.parse(hum) <= 20){
                  return Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromARGB(255, 184, 243, 251), // Màu nền của container
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/icons/humidity.png",
                              width: 54,height: 54,
                      ),
                      Text(
                        '$hum %', // Thay đổi độ ẩm tùy theo dữ liệu thực tế
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                      ],
                    )
                  ),
                );
                }else if(double.parse(hum) > 20 && double.parse(hum) <= 30){
                  return Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromARGB(255, 154, 233, 244), // Màu nền của container
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      Image.asset("assets/icons/humidity.png",
                              width: 54,height: 54,
                      ),
                      Text(
                        '$hum %', // Thay đổi độ ẩm tùy theo dữ liệu thực tế
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                      ],
                    )
                  ),
                );
                }else if(double.parse(hum) > 30 && double.parse(hum) <= 40){
                  return Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromARGB(199, 96, 234, 252)
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/icons/humidity.png",
                              width: 54,height: 54,
                      ),
                      Text(
                        '$hum %', // Thay đổi độ ẩm tùy theo dữ liệu thực tế
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                      ],
                    )
                  ),
                );
                }else if(double.parse(hum) > 40 && double.parse(hum) <= 50){
                  return Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromARGB(223, 77, 225, 255), // Màu nền của container
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/icons/humidity.png",
                              width: 54,height: 54,
                      ),
                      Text(
                        '$hum %', // Thay đổi độ ẩm tùy theo dữ liệu thực tế
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                      ],
                    )
                  ),
                );
                }else{
                  return Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromARGB(255, 47, 184, 202), // Màu nền của container
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      Image.asset("assets/icons/humidity.png",
                              width: 54,height: 54,
                      ),  
                      Text(
                        '$hum %', // Thay đổi độ ẩm tùy theo dữ liệu thực tế
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                      ],
                    )
                  ),
                );
                }
                
              }
              // return Container(
              //   height: 200,
              //   width: double.infinity,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(10),
              //     image: const DecorationImage(
              //       fit: BoxFit.fitWidth,
              //       image: AssetImage("assets/icons/smart-home.png"),
              //     ),
              //   ),
              // );
            },
          ),
        ),
        Positioned.fill(
          bottom: 10,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                2,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: currentSlide == index ? 15 : 8,
                  height: 8,
                  margin: const EdgeInsets.only(right: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: currentSlide == index
                        ? Colors.black
                        : Colors.transparent,
                    border: Border.all(color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
    );
  }
}
