import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_home/config/size_config.dart';

class FanContainer extends StatefulWidget {
  final String iconAsset;
  final VoidCallback onTap;
  final String device;
  final String deviceCount;
  final bool itsOn;
  double? value;
  // final VoidCallback switchButton;
  final Function(double)? switchButton;

  FanContainer({
    Key? key,
    required this.iconAsset,
    required this.onTap,
    required this.device,
    required this.deviceCount,
    required this.itsOn,
    required this.switchButton,
    this.value
  }) : super(key: key);

  @override
  _FanContainerState createState() => _FanContainerState();
}

class _FanContainerState extends State<FanContainer> {

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: widget.itsOn
              ? const Color.fromRGBO(0, 0, 0, 1)
              : const Color(0xffededed),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 6,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: widget.itsOn
                          ? const Color.fromRGBO(45, 45, 45, 1)
                          : const Color(0xffdadada),
                      borderRadius:
                      const BorderRadius.all(Radius.elliptical(45, 45)),
                    ),
                    child: SvgPicture.asset(
                      widget.iconAsset,
                      color: widget.itsOn ? Colors.amber : const Color(0xFF808080),
                    ),
                  ),
                  // GestureDetector(
                  //   onTap: widget.switchAuto,
                  //   child:  Icon(
                  //     Icons.auto_awesome,
                  //     color: isAuto ?  Colors.amber:const Color(0xFF808080),
                  //     // color: Color(0xFF808080),
                  //   ),
                  // ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.device,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: widget.itsOn ? Colors.white : Colors.black,
                        fontSize: 24
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        widget.deviceCount,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                            color: Color.fromRGBO(166, 166, 166, 1),
                            fontSize: 13,
                            letterSpacing: 0,
                            fontWeight: FontWeight.normal,
                            height: 1.6),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        widget.itsOn ? widget.value.toString() : 'Off',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: widget.itsOn ? Colors.white : Colors.black,
                            fontSize: 24
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Container(
                width: 250,
                child: Slider(
                  min: 0.0,
                  max: 5.0,
                  divisions: 5,
                  value: widget.value!,
                  onChanged: widget.switchButton,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
