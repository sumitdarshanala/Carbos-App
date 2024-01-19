import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Tile extends StatefulWidget {
  bool isvalue;

  String title;
  double carbon;
  String icon;
  bool check;
  List<String> data;
  String tag;
  final void Function(double a) updatetotal;

  Tile(
      {required this.updatetotal,
      this.check = true,
      this.isvalue = false,
      required this.title,
      required this.carbon,
      required this.icon,
      required this.data,
      required this.tag});

  @override
  State<Tile> createState() => _TileState();
}

double val = 0;

class _TileState extends State<Tile> {
  void load_data(double newRating) async {
    int idx = 0;
    if (widget.title == 'purchase') {
      idx = 0;
    } else if (widget.title == 'Petrol') {
      idx = 1;
    } else if (widget.title == 'Electricity') {
      idx = 2;
    } else {
      idx = 3;
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    widget.updatetotal(val - double.parse(widget.data[idx]));
    print("value added to total");
    print(val -double.parse(widget.data[idx]));
    widget.data[idx] = newRating.toString();
    await prefs.setStringList('${widget.tag}', widget.data);
    print("changed successfully");
  }

  @override
  Widget build(BuildContext context) {
    int idx = 0;
    if (widget.title == 'purchase') {
      idx = 0;
    } else if (widget.title == 'Petrol') {
      idx = 1;
    } else if (widget.title == 'Electricity') {
      idx = 2;
    } else {
      idx = 3;
    }
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              widget.isvalue = !widget.isvalue;
            });
          },
          child: ListTile(
            titleAlignment: ListTileTitleAlignment.top,
            leading: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset(
                widget.icon,
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.title,
                style: TextStyle(color: Colors.black, fontSize: 25),
              ),
            ),
            trailing: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${widget.carbon}',
                style: TextStyle(color: Colors.black, fontSize: 25),
              ),
            ),
          ),
        ),
        widget.isvalue && widget.check
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    width: MediaQuery.of(context).size.width * 2 / 3,
                    child: Slider(
                      value: val,
                      onChanged: (newRating) {
                        setState(() {
                          val = newRating;
                        });
                      },
                      min: 0,
                      max: 10,
                      activeColor: Colors.green[900],
                      inactiveColor: Colors.green[100],
                      label: ((10 * val).round() / 10).toString(),
                      divisions: 100,
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          widget.carbon = val * 10.round() / 10;
                          widget.isvalue = false;
                          load_data(((10 * val).round() / 10));
                        });
                      },
                      icon: Icon(Icons.check))
                ],
              )
            : AnimatedContainer(
                duration: Duration(milliseconds: 300),
              ),
      ],
    );
  }
}
