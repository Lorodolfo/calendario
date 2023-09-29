import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class CalendarGrid extends StatefulWidget {
  const CalendarGrid({Key? key}) : super(key: key);

  @override
  _CalendarGridState createState() => _CalendarGridState();
}

class _CalendarGridState extends State<CalendarGrid> {
  DateTime _selectedDate = DateTime.now();
  int _selectedIndex = 0;
  late int indexOfFirstDayMonth;

  @override
  void initState() {
    super.initState();
    indexOfFirstDayMonth = getIndexOfFirstDayInMonth(_selectedDate);
    updateSelectedIndex(); // Actualiza _selectedIndex
  }

  void updateSelectedIndex() {
    final indexOfFirstDayMonth = getIndexOfFirstDayInMonth(_selectedDate);
    setState(() {
      _selectedIndex = indexOfFirstDayMonth +
          int.parse(DateFormat('d').format(DateTime.now())) -
          1;
    });
  }

  void _previousMonth() {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1, 1);
      updateSelectedIndex();
    });
  }

  void _nextMonth() {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1, 1);
      updateSelectedIndex();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.purpleAccent,
          shadowColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: _previousMonth,
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.arrow_forward,
                color: Colors.black,
              ),
              onPressed: _nextMonth,
            )
          ],
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Calendar",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.black),
              ),
              Text(
                DateFormat('MMMM yyyy').format(_selectedDate),
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Colors.white),
              )
            ],
          ),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 50,
              child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                  ),
                  itemCount: daysOfWeek.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      alignment: Alignment.center,
                      child: Text(
                        daysOfWeek[index],
                        style: const TextStyle(
                            fontSize: 15,
                            color: Colors.purpleAccent,
                            //color: Color(0xFFFD00F0F),
                            fontWeight: FontWeight.bold),
                      ),
                    );
                  }),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 0.1,
                      blurRadius: 7,
                      offset: const Offset(0, 7.75),
                    ),
                  ]),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                ),
                itemCount: listOfDatesInMonth(_selectedDate).length +
                    indexOfFirstDayMonth,
                itemBuilder: (BuildContext context, int index) {
                  final bool isSelectedDay = index == _selectedIndex;
                  final bool isCurrentMonth = index >= indexOfFirstDayMonth;
                  final bool isSunday = index % 7 == 6;
                  final int dayNumber =
                      isCurrentMonth ? (index + 1 - indexOfFirstDayMonth) : 0;
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: GestureDetector(
                      onTap: () => index >= indexOfFirstDayMonth
                          ? setState(() {
                              _selectedIndex = index;
                            })
                          : null,
                      child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: index == _selectedIndex
                                ? //const Color(0xFFFD00F0F)
                                Colors.purpleAccent
                                : Colors.transparent,
                            border: Border.all(
                              color: isSelectedDay
                                  ? Colors.black
                                  : Colors.transparent, // Color del borde
                              width: 2.0, // Ancho del borde
                            ),
                          ),
                          child: index < indexOfFirstDayMonth
                              ? const Text("")
                              : Text(
                                  '${index + 1 - indexOfFirstDayMonth}',
                                  style: TextStyle(
                                      color: index == _selectedIndex
                                          ? Colors.white
                                          : index % 7 == 6
                                              ? Colors.redAccent
                                              : Colors.black,
                                      fontSize: 17),
                                )),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Expanded(
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(bottom: 20, top: 10),
                    child: SvgPicture.asset(
                      "assets/svgs/haircut-svgrepo-com.svg",
                      height: 174,
                      width: 84,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "No events today",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<int> listOfDatesInMonth(DateTime currentDate) {
  var selectedMonthFirstDay =
      DateTime(currentDate.year, currentDate.month, currentDate.day);
  var nextMonthFirstDay = DateTime(selectedMonthFirstDay.year,
      selectedMonthFirstDay.month + 1, selectedMonthFirstDay.day);
  var totalDays = nextMonthFirstDay.difference(selectedMonthFirstDay).inDays;

  var listOfDates = List<int>.generate(totalDays, (i) => i + 1);
  return (listOfDates);
}

int getIndexOfFirstDayInMonth(DateTime currentDate) {
  var selectedMonthFirstDay =
      DateTime(currentDate.year, currentDate.month, currentDate.day);
  var day = DateFormat('EEE').format(selectedMonthFirstDay).toUpperCase();

  return daysOfWeek.indexOf(day) - 1;
}

final List<String> daysOfWeek = [
  "LUN",
  "MAR",
  "MIE",
  "JUE",
  "VIE",
  "SAB",
  "DOM",
];
