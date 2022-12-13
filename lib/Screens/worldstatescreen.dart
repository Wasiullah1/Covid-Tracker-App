import 'package:covidtracker/Model/worldstatemode.dart';
import 'package:covidtracker/Services/stateservices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';

import 'countrieslist.dart';

class WorldStateScreen extends StatefulWidget {
  const WorldStateScreen({super.key});

  @override
  State<WorldStateScreen> createState() => _WorldStateScreenState();
}

class _WorldStateScreenState extends State<WorldStateScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(duration: const Duration(seconds: 3), vsync: this)
        ..repeat();

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  final colorList = <Color>[
    const Color(0xff4285f4),
    const Color(0xff1aa260),
    const Color(0xffde5246)
  ];
  @override
  Widget build(BuildContext context) {
    StateServices stateServices = StateServices();
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            FutureBuilder(
                future: stateServices.fetchWorldStateRecords(),
                builder: (context, AsyncSnapshot<WorldStateModel> snapshot) {
                  if (!snapshot.hasData) {
                    return Expanded(
                        flex: 1,
                        child: SpinKitFadingCircle(
                          color: Colors.white,
                          size: 50,
                          controller: _controller,
                        ));
                  } else {
                    return Column(
                      children: [
                        PieChart(
                          dataMap: {
                            "Total":
                                double.parse(snapshot.data!.cases!.toString()),
                            "Recovered": double.parse(
                                snapshot.data!.recovered!.toString()),
                            "Death":
                                double.parse(snapshot.data!.deaths!.toString()),
                          },
                          chartValuesOptions: const ChartValuesOptions(
                              showChartValuesInPercentage: true),
                          chartRadius: MediaQuery.of(context).size.width / 3.2,
                          legendOptions: const LegendOptions(
                              legendPosition: LegendPosition.left),
                          animationDuration: const Duration(milliseconds: 1200),
                          chartType: ChartType.ring,
                          colorList: colorList,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.height * .06),
                          child: Card(
                            child: Column(
                              children: [
                                ReusableRow(
                                    title: 'Total',
                                    value: snapshot.data!.cases!.toString()),
                                ReusableRow(
                                    title: 'Death',
                                    value: snapshot.data!.deaths!.toString()),
                                ReusableRow(
                                    title: 'Recovered',
                                    value:
                                        snapshot.data!.recovered!.toString()),
                                ReusableRow(
                                    title: 'Active',
                                    value: snapshot.data!.active!.toString()),
                                ReusableRow(
                                    title: 'Critical',
                                    value: snapshot.data!.critical!.toString()),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CountriesListScreen()));
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(0xff1aa260),
                            ),
                            child: Center(child: Text("Track Country")),
                          ),
                        )
                      ],
                    );
                  }
                }),
            // PieChart(
            //   dataMap: {
            //     "Total": 20,
            //     "Recovered": 15,
            //     "Death": 5,
            //   },
            //   chartRadius: MediaQuery.of(context).size.width / 3.2,
            //   legendOptions:
            //       const LegendOptions(legendPosition: LegendPosition.left),
            //   animationDuration: const Duration(milliseconds: 1200),
            //   chartType: ChartType.ring,
            //   colorList: colorList,
            // ),
            // Padding(
            //   padding: EdgeInsets.symmetric(
            //       vertical: MediaQuery.of(context).size.height * .06),
            //   child: Card(
            //     child: Column(
            //       children: [
            //         ReusableRow(title: 'Total', value: '200'),
            //         ReusableRow(title: 'Total', value: '200'),
            //         ReusableRow(title: 'Total', value: '200'),
            //         SizedBox(
            //           height: 20,
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            // Container(
            //   height: 50,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(20),
            //     color: Color(0xff1aa260),
            //   ),
            //   child: Center(child: Text("Track Country")),
            // )
          ],
        ),
      )),
    );
  }
}

class ReusableRow extends StatelessWidget {
  String title, value;
  ReusableRow({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(title), Text(value)],
          ),
          SizedBox(height: 5),
          Divider(),
        ],
      ),
    );
  }
}
