import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_home/api/apiQueryLog.dart';

import '../class/History.dart';

class ViewHistory extends StatefulWidget {
  const ViewHistory({super.key});

  @override
  State<ViewHistory> createState() => _ViewHistoryState();
}


class _ViewHistoryState extends State<ViewHistory> {

  List<History> lHistory = [];
  DateTime selectedDate = DateTime.now();
  Future<void> getValue(String year, String month, String day) async {
    ApiQueryLog apiQueryLog = await QueryLog(year,month,day);
    lHistory = [];
    for(var i in apiQueryLog.userMap){
      Map<String, dynamic> map = i;
      History history = new History();
      history.datetime = map["datetime"];
      history.username = map["username"];
      history.content = map["content"];
      history.level = map["level"].toString();
      lHistory.add(history);
    }
    setState(() {
    });
  }

  // Hàm để chọn thời gian
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      getValue(
        selectedDate.year.toString(),
        selectedDate.month.toString(),
        selectedDate.day.toString(),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    getValue(selectedDate.year.toString(), selectedDate.month.toString(), selectedDate.day.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text("History Day:  ${DateFormat("dd/MM/yyyy").format(selectedDate)}"),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        child: Column(
          children: [
            Container(
              child: ElevatedButton(
                onPressed: () {
                  _selectDate(context);
                },
                child: Text('Select Date'),
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 500,
              child: ListView.builder(
                  itemCount: lHistory.length,
                  itemBuilder: (context,snapshot){
                    int inf = lHistory.length - snapshot-1;
                    DateTime dateTime = DateTime.parse(lHistory[inf].datetime);
                    return Container(
                      margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white, // Màu nền của container
                        borderRadius: BorderRadius.circular(10), // Độ cong của góc
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5), // Màu và độ trong suốt của bóng đổ
                            spreadRadius: 5, // Độ rộng mà bóng đổ lan ra
                            blurRadius: 7, // Độ mờ của bóng đổ
                            offset: Offset(0, 3), // Độ dịch chuyển của bóng đổ theo trục X và trục Y
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.all(20),
                            child:  Text(lHistory[inf].level),
                          ),
                          Container(
                            width: 300,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    lHistory[inf].content,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  textAlign: TextAlign.center, // Đưa chữ về giữa
                                ),
                                Text("${dateTime.hour}:${dateTime.minute}:${dateTime.second}")
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
              ),
            ),

          ],
        ),
      ),
    );
  }

}
