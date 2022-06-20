import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../model/property_card_view_model.dart';
import '../services/property_card_http_request.dart';
import 'filter_page_for_the_rest.dart';


final DateTime now = DateTime.now();
final DateFormat formatter = DateFormat('yyyy-MM-dd');
final String formatted = formatter.format(now);


class History extends StatefulWidget {
  History({Key? key}) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<PropertyCardView>? card;
  var isLoaded = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    card = await HistoryViewCard().propertyCardView();
    if (card != null  ) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  late bool active = true;
  void toggle() {
    setState(() {
      active = !active;
    });
  }

  @override
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Visibility(
        replacement: const Center(
          child: CircularProgressIndicator(),
        ),
        visible: isLoaded,
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.only(top: 50),
          //crossAxisAlignment: CrossAxisAlignment.start,
          itemCount: card?.length,
          itemBuilder: (BuildContext context, int index) {
            return HistoryCarsCard(
              location: card![index].areaName.toString(),
              title: card![index].titel.toString(),
              price: card![index].price.toString(),
              img: card![index].fronPhoto.toString(),
              logo: 'assets/cars/mitsubishi.svg',
              active: active,
              onTap: () => toggle(),
              date: card![index].date.toString(),
              view: card![index].seen.toString(),
            );
          },
        ),
      ),
    );
  }
}

class HistoryCarsCard extends StatefulWidget {
  const HistoryCarsCard({
    Key? key,
    required this.img,
    required this.title,
    required this.location,
    required this.price,
    required this.logo,
    required this.active,
    required this.onTap,
    required this.date,
    required this.view,
  }) : super(key: key);
  final String img;
  final String title;
  final String location;
  final String price;
  final String logo;
  final String date;
  final String view;
  final bool active;
  final VoidCallback onTap;

  @override
  State<HistoryCarsCard> createState() => _HistoryCarsCardState();
}

class _HistoryCarsCardState extends State<HistoryCarsCard> {
  @override
  Widget build(BuildContext context) {
    bool status = widget.active;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Container(
        height: MediaQuery.of(context).size.height * .34,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(blurRadius: 10.0, color: Colors.grey.withOpacity(0.5))
            ],
            color: const Color(0xfff2f2f2),
            borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * .4,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 12.0, color: Colors.grey.withOpacity(0.5))
                  ],
                  image: DecorationImage(
                    image: NetworkImage(
                      "http://192.168.15.122/easy/image/${widget.img}",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),

              ),
              SizedBox(
                width: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width * .45,
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 30,
                        width: 30,
                        decoration: const BoxDecoration(
                            border: Border(
                                right: BorderSide(
                                    width: 1.0, color: Colors.white24))),
                        child: SvgPicture.asset(
                          widget.logo,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.title,
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.price,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Date: ${formatted}",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.fade),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Time: 12:00:00",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          EditDelete(
                            onTap: () {},
                            title: 'Edit',
                            icon: Icons.edit,
                            iconColor: Colors.teal,
                          ),
                          EditDelete(
                            onTap: () {},
                            title: 'Delete',
                            icon: Icons.delete,
                            iconColor: Colors.red,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          EditDelete(
                            onTap: () {},
                            title: widget.view,
                            icon: Icons.remove_red_eye,
                            iconColor: Colors.teal,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              primary: Colors.white,
                              backgroundColor:
                                  status ? Colors.green : Colors.black,
                            ),
                            onPressed: widget.onTap,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                status ? "Active" : "Sold",
                                style: TextStyle(
                                    fontSize: 15,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class EditDelete extends StatefulWidget {
  const EditDelete({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
    required this.iconColor,
  }) : super(key: key);

  final VoidCallback onTap;
  final IconData icon;
  final String title;
  final Color iconColor;

  @override
  State<EditDelete> createState() => _EditDeleteState();
}

class _EditDeleteState extends State<EditDelete> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: OutlinedButton.styleFrom(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
      onPressed: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              widget.icon,
              size: 25,
              color: widget.iconColor,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              widget.title,
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  overflow: TextOverflow.ellipsis),
            )
          ],
        ),
      ),
    );
  }
}

class HistoryPropertyCard extends StatefulWidget {
  const HistoryPropertyCard({
    Key? key,
    required this.img,
    required this.title,
    required this.location,
    required this.price,
    required this.listing,
    required this.active,
    required this.onTap,
  }) : super(key: key);
  final String img;
  final String title;
  final String location;
  final String price;
  final String listing;
  final bool active;
  final VoidCallback onTap;

  @override
  _HistoryPropertyCardState createState() => _HistoryPropertyCardState();
}

class _HistoryPropertyCardState extends State<HistoryPropertyCard> {
  @override
  Widget build(BuildContext context) {
    bool status = widget.active;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Container(
        height: MediaQuery.of(context).size.height * .34,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(blurRadius: 10.0, color: Colors.grey.withOpacity(0.5))
            ],
            color: const Color(0xfff2f2f2),
            borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * .4,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 12.0, color: Colors.grey.withOpacity(0.5))
                  ],
                  image: DecorationImage(
                    image: AssetImage(
                      widget.img,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width * .45,
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          primary: Colors.white,
                          backgroundColor: Color.fromRGBO(64, 75, 96, .9),
                        ),
                        onPressed: () {},
                        child: Text(
                          "Sale",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.title,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.price,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Uploaded: 14-jan-2022",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.fade),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Time: 12:00:00",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          EditDelete(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (Context) => FilterPageTheRest(
                                            select1Name: 'mm',
                                            select2: 'scdf',
                                            select2Name: "ghjk",
                                            select3: 'ghjk',
                                            select4: 'hjkl;',
                                          )));
                            },
                            title: 'Edit',
                            icon: Icons.edit,
                            iconColor: Colors.teal,
                          ),
                          EditDelete(
                            onTap: () {},
                            title: 'Delete',
                            icon: Icons.delete,
                            iconColor: Colors.red,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          EditDelete(
                            onTap: () {},
                            title: '200',
                            icon: Icons.remove_red_eye,
                            iconColor: Colors.teal,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              primary: Colors.white,
                              backgroundColor:
                                  status ? Colors.green : Colors.black,
                            ),
                            onPressed: widget.onTap,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                status ? "Active" : "Sold",
                                style: TextStyle(
                                    fontSize: 15,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
