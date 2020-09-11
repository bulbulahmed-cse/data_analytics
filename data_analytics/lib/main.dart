import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DataAnalytics()));
}

class DataAnalytics extends StatefulWidget {
  @override
  _DataAnalyticsState createState() => _DataAnalyticsState();
}

class _DataAnalyticsState extends State<DataAnalytics> {
  List<Data> _data = List();
  bool _loading=true;

  Future loadData() async {
    var list = json.decode(await DefaultAssetBundle.of(context)
        .loadString('assets/stock_market_data.json')) as List;
    for (int i = 0; i < 40; i++) {
      _data.add(Data.fromJson(list[i]));
    }

    setState(() {
      _loading=false;
    });

  }

  void changeState() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              onPressed: () => SystemNavigator.pop(),
            )
          ],
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'Table',
                icon: Icon(Icons.table_chart),
              ),
              Tab(
                text: 'chart',
                icon: Icon(Icons.show_chart),
              ),
              Tab(
                text: 'other',
                icon: Icon(Icons.pie_chart_outlined),
              ),
            ],
          ),
          title: Text('Data Analytics'),
        ),
        body: _loading==true
            ? Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(10),
            child: Visibility(child: CircularProgressIndicator()))
            : TabBarView(
          children: [

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  columns: [
                    DataColumn(
                      label: Text("Date"),
                    ),
                    DataColumn(
                      label: Text("TradeCode"),
                    ),
                    DataColumn(
                      label: Text("high"),
                    ),
                    DataColumn(
                      label: Text("low"),
                    ),
                    DataColumn(
                      label: Text("open"),
                    ),
                    DataColumn(
                      label: Text("close"),
                    ),
                    DataColumn(
                      label: Text("volume"),
                    ),
                  ],
                  rows: _data
                      .map(
                        (e) => DataRow(cells: [
                      DataCell(
                        Text(e.date),
                      ),
                      DataCell(
                        Text(e.tradeCode),
                      ),
                      DataCell(
                        Text(e.high),
                      ),
                      DataCell(
                        Text(e.low),
                      ),
                      DataCell(
                        Text(e.open),
                      ),
                      DataCell(
                        Text(e.close),
                      ),
                      DataCell(
                        Text(e.volume),
                      ),
                    ]),
                  )
                      .toList(),
                ),
              ),
            ),
            Icon(Icons.directions_bike),

            Icon(Icons.directions_bike),
          ],
        ),
      ),
    );
  }
}

class Data {
  String date;
  String tradeCode;
  String high;
  String low;
  String open;
  String close;
  String volume;

  Data(
      {this.date,
        this.tradeCode,
        this.high,
        this.low,
        this.open,
        this.close,
        this.volume});

  Data.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    tradeCode = json['trade_code'];
    high = json['high'];
    low = json['low'];
    open = json['open'];
    close = json['close'];
    volume = json['volume'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['trade_code'] = this.tradeCode;
    data['high'] = this.high;
    data['low'] = this.low;
    data['open'] = this.open;
    data['close'] = this.close;
    data['volume'] = this.volume;
    return data;
  }
}
