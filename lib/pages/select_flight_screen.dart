
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class SelectFlightScreen extends StatefulWidget {
  @override
  _SelectFlightScreenState createState() => _SelectFlightScreenState();
}
class _SelectFlightScreenState extends State<SelectFlightScreen> {
  String departure = 'Đà Nẵng (DAD)';
  String destination = 'Hồ Chí Minh (SGN)';
  DateTime departureDate = DateTime.now();
  DateTime? returnDateStart; // Ngày bắt đầu khứ hồi
  DateTime? returnDateEnd; // Ngày kết thúc khứ hồi
  bool isRoundTrip = false;
  int adults = 0;
  int children = 0;
  int infants = 0;

 // Trạng thái khứ hồi
  void swapLocations() {
    setState(() {
      final temp = departure;
      departure = destination;
      destination = temp;
    });
  }
  // Hàm mở lịch để chọn ngày khởi hành
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: departureDate, // Ngày khởi hành hiện tại
      firstDate: DateTime.now(), // Không cho chọn trước ngày hôm nay
      lastDate: DateTime.now().add(Duration(days: 365)), // Trong vòng 1 năm
    );
    if (pickedDate != null && pickedDate != departureDate) {
      setState(() {
        departureDate = pickedDate;
      });
    }
  }
  // Hàm hiển thị lịch chọn khoảng thời gian khứ hồi
  Future<void> _selectRoundTripDates(BuildContext context) async {
    final DateTime? startPicked = await showDatePicker(
      context: context,
      initialDate: returnDateStart ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (startPicked != null) {
      final DateTime? endPicked = await showDatePicker(
        context: context,
        initialDate: startPicked.add(Duration(days: 1)),
        firstDate: startPicked,
        lastDate: DateTime.now().add(Duration(days: 365)),
      );
      if (endPicked != null) {
        setState(() {
          returnDateStart = startPicked;
          returnDateEnd = endPicked;
        });
      }
    }
  }
  
  //hàm voi hành khách
  void showPassengerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text('Hành khách', style: TextStyle(fontWeight: FontWeight.bold)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Người lớn
                  buildPassengerRow(
                    'Người lớn',
                    'Từ 12 tuổi trở lên',
                    adults,
                    (value) {
                      setStateDialog(() {
                        if (value == 1 && adults + children + infants < 9) adults++;
                        if (value == -1 && adults > 0) {
                          adults--;
                          if (children > adults * 8) children = adults * 8;
                          if (infants > adults) infants = adults;
                        }
                      });
                    },
                  ),
                  Divider(),
                  // Trẻ em
                  buildPassengerRow(
                    'Trẻ em',
                    'Từ 2 - 11 tuổi',
                    children,
                    (value) {
                      setStateDialog(() {
                        if (value == 1 && children < adults * 8 && adults + children + infants < 9) {
                          children++;
                        }
                        if (value == -1 && children > 0) children--;
                      });
                    },
                  ),
                  Divider(),
                  // Em bé
                  buildPassengerRow(
                    'Em bé',
                    'Dưới 2 tuổi',
                    infants,
                    (value) {
                      setStateDialog(() {
                        if (value == 1 && infants < adults && adults + children + infants < 9) {
                          infants++;
                        }
                        if (value == -1 && infants > 0) infants--;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Hủy'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {}); // Cập nhật lại UI ngoài khi chọn OK
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget buildPassengerRow(String title, String subtitle, int count, Function(int) onChange) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: () => onChange(-1),
            ),
            Text('$count', style: TextStyle(fontSize: 16)),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => onChange(1),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Vietjet Air',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Khung xanh cây bao cả hai thẻ
            Container(
              decoration: BoxDecoration(
                color: Colors.green[200],
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.all(10),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    children: [
                      // Thẻ Điểm khởi hành
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.yellow[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Điểm khởi hành',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            ListTile(
                              leading:
                                  Icon(Icons.flight_takeoff, color: Colors.black),
                              title: Text(
                                departure,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.normal),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 3), // Khoảng cách 3px giữa hai thẻ
                      // Thẻ Điểm đến
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.red[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Điểm đến',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            ListTile(
                              leading: Icon(Icons.flight_land, color: Colors.black),
                              title: Text(
                                destination,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.normal),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Nút đổi vị trí (chồng lên giữa hai thẻ)
                  Positioned(
                    right: 10, // Đẩy nút sang bên phải
                    child: ElevatedButton(
                      onPressed: swapLocations,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(12),
                      ),
                      child: Icon(Icons.swap_vert),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Ngày khởi hành và khứ hồi
            Container(
              decoration: BoxDecoration(
                color: Colors.purple[200],
                borderRadius: BorderRadius.circular(3), // Bo góc 3px
              ),
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ngày khởi hành',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        ListTile(
                          leading: GestureDetector(
                            onTap: () => _selectDate(context), // Mở lịch chọn ngày
                            child: Icon(Icons.calendar_today, color: Colors.black),
                          ),
                          title: Text(
                            DateFormat('EEEE, dd MMMM, yyyy')
                                .format(departureDate),
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        'Khứ hồi?',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      Switch(
                        value: isRoundTrip,
                        onChanged: (value) {
                          setState(() {
                            isRoundTrip = value;
                            if (!isRoundTrip) {
                              returnDateStart = null;
                              returnDateEnd = null;
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (isRoundTrip)
              Container(
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  color: Colors.orange[200],
                  borderRadius: BorderRadius.circular(3),
                ),
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ngày khứ hồi',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    ListTile(
                      leading: GestureDetector(
                        onTap: () => _selectRoundTripDates(context),
                        child: Icon(Icons.calendar_today, color: Colors.black),
                      ),
                      title: Text(
                        returnDateStart != null && returnDateEnd != null
                            ? '${DateFormat('dd/MM/yyyy').format(returnDateStart!)} - ${DateFormat('dd/MM/yyyy').format(returnDateEnd!)}'
                            : 'Chọn ngày khứ hồi',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 20),
            

            // Hiển thị số lượng hành khách
            
            GestureDetector(
              onTap: showPassengerDialog,
              child: buildPassengerTile(),
            ),
            
            
            
            
            
            // Button Tìm kiếm chuyến bay
            Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 230, 0),
                foregroundColor: Colors.black,
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: () {},
              child: Text(
                'TÌM KIẾM CHUYẾN BAY',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget buildPassengerTile() {
    return ListTile(
      leading: Icon(Icons.person, color: Colors.black),
      title: Text('Hành khách', style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text('$adults người lớn, $children trẻ em, $infants em bé'),
    );
  }

}


