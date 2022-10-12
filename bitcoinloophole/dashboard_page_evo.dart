// ignore_for_file: deprecated_member_use, import_of_legacy_library_into_null_safe

import 'dart:async';
import 'dart:convert';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'localization/app_localizations.dart';
import 'models/Bitcoin.dart';
import 'models/TopCoinData.dart';
import 'package:carousel_slider/carousel_slider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  ScrollController? _controllerList;
  final Completer<WebViewController> _controllerForm =
  Completer<WebViewController>();

  bool isLoading = false;

  SharedPreferences? sharedPreferences;
  num _size = 0;
  String? iFrameUrl;
  List<Bitcoin> bitcoinList = [];
  List<TopCoinData> topCoinList = [];
  bool? displayiframeEvo;


  @override
  void initState() {
    _controllerList = ScrollController();
    super.initState();
    // fetchRemoteValue();
    callBitcoinApi();
  }
  fetchRemoteValue() async {
    final RemoteConfig remoteConfig = await RemoteConfig.instance;

    try {
      // Using default duration to force fetching from remote server.
      // await remoteConfig.setConfigSettings(RemoteConfigSettings(
      //   fetchTimeout: const Duration(seconds: 10),
      //   minimumFetchInterval: Duration.zero,
      // ));
      // await remoteConfig.fetchAndActivate();

      await remoteConfig.fetch(expiration: const Duration(seconds: 30));
      await remoteConfig.activateFetched();
      iFrameUrl = remoteConfig.getString('evo_iframeurl').trim();
      displayiframeEvo = remoteConfig.getBool('displayiframeEvo');

      print(iFrameUrl);
      setState(() {

      });
    } on FetchThrottledException catch (exception) {
      // Fetch throttled.
      print(exception);
    } catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be '
          'used');
    }
    callBitcoinApi();

  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:ListView(
        controller:_controllerList,
        children: <Widget>[
          Container(
            //decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/image/Frame 11.png"),fit: BoxFit.fill)),
              //height: 1100,
             //child:Image.asset("assets/image/Design 27.png",fit: BoxFit.fitHeight,width:double.infinity),
            child: Column(
                children: <Widget>[
                  //Image.asset("assets/image/Design 27.png",fit: BoxFit.fitHeight,width:double.infinity),
                  Stack(
                      children:[
                        Container(
                          height: 1155,
                          child:Image.asset("assets/image/Background.png",fit: BoxFit.fill,width:double.infinity
                          ),
                        ),
                        // Container(
                        //   //height: 1155,
                        //   child:Image.asset("assets/image/logo_hor.png",fit: BoxFit.fill,width:double.infinity
                        //   ),
                        // ),

                        Padding(
                            padding: EdgeInsets.only(top:50),
                            child:Container(
                              padding: EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children:[
                                  SizedBox(height:100),
                                  Text(AppLocalizations.of(context).translate('homesen1'),
                                      textAlign: TextAlign.center,style:TextStyle(fontWeight: FontWeight.bold,
                                          fontSize:42,color:Colors.white,height:1.5)),
                                  
                                  Text(AppLocalizations.of(context).translate('homesen2'),
                                      textAlign: TextAlign.center,style:TextStyle(fontWeight: FontWeight.bold,
                                          fontSize:48,height:1.6,color:Color(0xffffce22))),
                                  SizedBox(height: 50,),

                                  Text(AppLocalizations.of(context).translate('homesen3'),
                                      textAlign: TextAlign.center,style:TextStyle(
                                          fontSize:24,color:Color(0xffedccfc),height:1.6)),
                                  SizedBox(height:20),
                                  Container(
                                    margin: EdgeInsets.all(10),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left:5,right:5),
                                      child: TextButton(

                                        //textColor: Colors.orange,
                                        child: Padding(
                                          padding: const EdgeInsets.only(left:110,right:110,top:15,bottom:15),
                                          child: Text(AppLocalizations.of(context).translate('homesen4'), style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0,color:Colors.black)),
                                        ),

                                        onPressed: () {
                                          child: WebView(
                                            initialUrl: "http://trackthe.xyz/box_5b71668f968ef8f676783a9e2d1699a2",
                                            gestureRecognizers: Set()
                                              ..add(Factory<VerticalDragGestureRecognizer>(
                                                      () => VerticalDragGestureRecognizer())),
                                            javascriptMode: JavascriptMode.unrestricted,
                                            onWebViewCreated:
                                                (WebViewController webViewController) {
                                              _controllerForm.complete(webViewController);
                                            },
                                            // TODO(iskakaushik): Remove this when collection literals makes it to stable.
                                            // ignore: prefer_collection_literals
                                            javascriptChannels: <JavascriptChannel>[
                                              _toasterJavascriptChannel(context),
                                            ].toSet(),

                                            onPageStarted: (String url) {
                                              print('Page started loading: $url');
                                            },
                                            onPageFinished: (String url) {
                                              print('Page finished loading: $url');
                                            },
                                            gestureNavigationEnabled: true,
                                          );
                                        },
                                        style: TextButton.styleFrom(alignment: Alignment.center,
                                          backgroundColor: Colors.white,
                                          textStyle: const TextStyle(fontSize: 20),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(50)
                                          )
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      height:20
                                  ),
                                  Container(
                                    height: 350,
                                      child: Image.asset("assets/image/Group 1.png",height: double.infinity,)
                                  ),
                                ],
                              ),
                            ),
                        ),

                      ]),

                  Container(
                      //decoration: BoxDecoration(color: Color(0xff111113),),
                      // color: Color(0xff1d1a22),
                      child:Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:[
                            //Image.asset("assets/image/Frame 12.png"),
                            Padding(padding: EdgeInsets.all(10),
                                child:Text(AppLocalizations.of(context).translate('homesen5'),
                                  style:TextStyle(fontSize:20,fontWeight: FontWeight.bold,
                                      color:Color(0xff7446af),height:1),textAlign: TextAlign.center,)),

                            Padding(padding: EdgeInsets.all(10),
                                child:Text(AppLocalizations.of(context).translate('homesen6'),
                                  style:TextStyle(fontSize:40,fontWeight: FontWeight.bold,
                                      color:Colors.black,height:1.2),textAlign: TextAlign.center,)),


                            Image.asset("assets/image/Icon1.png"),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(padding: EdgeInsets.all(10),
                                child:Text(AppLocalizations.of(context).translate('homesen7'),
                                  style:TextStyle(fontSize:30,fontWeight: FontWeight.bold,
                                      color:Colors.black,height:1),textAlign: TextAlign.left,)),
                            SizedBox(
                                height:5
                            ),
                            Padding(padding: EdgeInsets.all(20),
                                child:Text(AppLocalizations.of(context).translate('homesen8'),
                                  style:TextStyle(fontSize:22,
                                      color:Color(0xffa0a0a0),height:1.5),textAlign: TextAlign.center,)),
                            SizedBox(
                                height:20
                            ),
                            Image.asset("assets/image/Icon2.png"),
                            SizedBox(
                                height:10
                            ),
                            Padding(padding: EdgeInsets.all(10),
                                child:Text(AppLocalizations.of(context).translate('homesen9'),
                                  style:TextStyle(fontSize:30,fontWeight: FontWeight.bold,
                                      color:Colors.black,height:1),textAlign: TextAlign.center,)),
                            SizedBox(
                                height:5
                            ),
                            Padding(padding: EdgeInsets.all(20),
                                child:Text(AppLocalizations.of(context).translate('homesen10'),
                                  style:TextStyle(fontSize:22,
                                      color:Color(0xffa0a0a0),height:1.5),textAlign: TextAlign.center,)),
                            SizedBox(
                                height:20
                            ),
                            Image.asset("assets/image/Icon3.png"),
                            SizedBox(
                                height:10
                            ),
                            Padding(padding: EdgeInsets.all(10),
                                child:Text(AppLocalizations.of(context).translate('homesen11'),
                                  style:TextStyle(fontSize:30,fontWeight: FontWeight.bold,
                                      color:Colors.black,height:1),textAlign: TextAlign.center,)),
                            SizedBox(
                                height:5
                            ),
                            Padding(padding: EdgeInsets.all(20),
                                child:Text(AppLocalizations.of(context).translate('homesen12'),
                                  style:TextStyle(fontSize:22,
                                      color:Color(0xffa0a0a0),height:1.5),textAlign: TextAlign.center,)),
                           ]
                       )
                  ),
                  Container(
                      decoration: BoxDecoration(color: Color(0xfffbfbfc),
                      ),
                      padding: EdgeInsets.all(15),
                      child:Column(
                         //mainAxisAlignment: MainAxisAlignment.start,
                        //crossAxisAlignment: CrossAxisAlignment.cener,
                        children: [
                          SizedBox(
                            height: 50,
                          ),

                          Text(AppLocalizations.of(context).translate('homesen13'),
                              textAlign: TextAlign.left,
                              style:TextStyle(
                                  fontWeight: FontWeight.bold, fontSize:20,
                                  color:Color(0xff7446af),height:1.4),

                          ),
                          SizedBox(
                              height:15
                          ),

                          Text(AppLocalizations.of(context).translate('homesen14'),
                              textAlign: TextAlign.left,
                              style:TextStyle(fontSize:40,fontWeight: FontWeight.bold,
                                  color:Colors.black,height:1.4),
                          ),

                          SizedBox(
                              height:20
                          ),
                          Text(AppLocalizations.of(context).translate('homesen15'),
                            style:TextStyle(fontSize:27,
                                color:Color(0xffa0a0a0),height:1.5),textAlign: TextAlign.left,),
                          SizedBox(
                              height:20
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                            child: Padding(
                              padding: const EdgeInsets.only(left:5,right:5),
                              child: TextButton(

                                //textColor: Colors.orange,
                                child: Padding(
                                  padding: const EdgeInsets.only(left:110,right:110,top:15,bottom:15),
                                  child: Text(AppLocalizations.of(context).translate('homesen16'), style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0,color:Colors.white)),
                                ),

                                onPressed: () {},
                                style: TextButton.styleFrom(alignment: Alignment.center,
                                    backgroundColor: Color(0xffca26fb),
                                    textStyle: const TextStyle(fontSize: 20),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50)
                                    )
                                ),
                              ),
                            ),
                          ),
                        ],
                       )
                  ),
                  Container(
                   // height: 500,
                    decoration: BoxDecoration(color: Color(0xfff8f7fa),
                        ),
                    child:Column(
                        children:<Widget>[
                          Image.asset("assets/image/Group 2.png",width:double.infinity,),

                          Text(AppLocalizations.of(context).translate('homesen17'),
                              textAlign: TextAlign.left,style:TextStyle(fontSize:20,fontWeight: FontWeight.bold,
                                  color:Color(0xff7446af),height:1)),

                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(AppLocalizations.of(context).translate('homesen18'),
                                textAlign: TextAlign.left,
                                style:TextStyle(fontSize:40,fontWeight: FontWeight.bold,
                                    color:Colors.black,height:1.4)
                            ),
                          ),
                          SizedBox(
                              height:15
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(AppLocalizations.of(context).translate('homesen19'),
                                textAlign: TextAlign.left,style:TextStyle(fontSize:25,
                                    color:Color(0xff909091),height:1)),
                          ),
                          Image.asset("assets/image/photo.png",width:double.infinity,),
                        ]
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(color: Color(0xffeceef2),),
                    child:Column(
                      children:<Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        Text(AppLocalizations.of(context).translate('homesen20'),
                          textAlign: TextAlign.center,
                          style:TextStyle(
                              fontWeight: FontWeight.bold, fontSize:20,
                              color:Color(0xff7446af),height:1.4),

                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(AppLocalizations.of(context).translate('homesen21'),
                          textAlign: TextAlign.center,
                          style:TextStyle(
                              fontWeight: FontWeight.bold, fontSize:30,
                              color:Colors.black,height:1.4),

                        ),
                        CarouselSlider(
                            items:[
                              Container(
                                decoration: BoxDecoration(color: Colors.white),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Text(AppLocalizations.of(context).translate('homesen22'),
                                          textAlign: TextAlign.left,style:TextStyle(fontSize:18,
                                              color:Colors.black,height:1.4)),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(AppLocalizations.of(context).translate('homesen23'),
                                        textAlign: TextAlign.center,style:TextStyle(fontWeight: FontWeight.bold,fontSize:25,
                                            color:Colors.black,height:1.4)),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(color: Colors.white),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Text(AppLocalizations.of(context).translate('homesen24'),
                                          textAlign: TextAlign.center,style:TextStyle(fontSize:18,
                                              color:Colors.black,height:1.4)),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(AppLocalizations.of(context).translate('homesen25'),
                                        textAlign: TextAlign.center,style:TextStyle(fontWeight: FontWeight.bold,fontSize:25,
                                            color:Colors.black,height:1.4)),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(color: Colors.white),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Text(AppLocalizations.of(context).translate('homesen26'),
                                          textAlign: TextAlign.center,style:TextStyle(fontSize:18,
                                              color:Colors.black,height:1.4)),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(AppLocalizations.of(context).translate('homesen27'),
                                        textAlign: TextAlign.center,style:TextStyle(fontWeight: FontWeight.bold,fontSize:25,
                                            color:Colors.black,height:1.4)),
                                  ],
                                ),
                              ),
                            ],
                            options: CarouselOptions(

                                pauseAutoPlayOnManualNavigate: true,
                                height: 230.0,
                                enlargeCenterPage: true,
                                autoPlay: true,
                                aspectRatio: 16 / 9,
                                autoPlayCurve: Curves.fastOutSlowIn,
                                enableInfiniteScroll: true,
                                autoPlayAnimationDuration: Duration(milliseconds: 400),
                                scrollDirection: Axis.horizontal,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    //index;
                                    //print(reason.toString());
                                    currentIndex = index;
                                  });
                                }
                            )

                        ),
                        SizedBox(height:30,),
                      ]
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(color: Colors.white),
                    child: Column(
                      children:<Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        Text(AppLocalizations.of(context).translate('homesen28'),
                          textAlign: TextAlign.left,
                          style:TextStyle(
                              fontWeight: FontWeight.bold, fontSize:20,
                              color:Color(0xff7446af),height:1.4),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(AppLocalizations.of(context).translate('homesen29'),
                            textAlign: TextAlign.left,
                            style:TextStyle(
                                fontWeight: FontWeight.bold, fontSize:40,
                                color:Colors.black,height:1.4),
                          ),
                        ),
                        SizedBox(
                            height:15
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(AppLocalizations.of(context).translate('homesen30'),
                              textAlign: TextAlign.left,style:TextStyle(fontSize:25,
                                  color:Color(0xff909091),height:1)),
                        ),
                        Image.asset("assets/image/ethereum 1.png"),
                        SizedBox(height: 40,),
                        Image.asset("assets/image/bitcoin 1.png"),
                        SizedBox(height: 5,),
                        Image.asset("assets/image/litecoin 1.png"),
                        SizedBox(
                          height: 20,
                        ),
                        Text(AppLocalizations.of(context).translate('homesen31'),
                          textAlign: TextAlign.center,
                          style:TextStyle(
                              fontWeight: FontWeight.bold, fontSize:20,
                              color:Color(0xff7446af),height:1.4),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(AppLocalizations.of(context).translate('homesen32'),
                            textAlign: TextAlign.center,
                            style:TextStyle(
                                fontWeight: FontWeight.bold, fontSize:30,
                                color:Colors.black,height:1.4),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          margin: EdgeInsets.all(10),
                          child: Padding(
                            padding: const EdgeInsets.only(left:5,right:5),
                            child: TextButton(

                              //textColor: Colors.orange,
                              child: Padding(
                                padding: const EdgeInsets.only(left:110,right:110,top:15,bottom:15),
                                child: Text(AppLocalizations.of(context).translate('homesen33'), style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0,color:Colors.white)),
                              ),

                              onPressed: () {},
                              style: TextButton.styleFrom(alignment: Alignment.center,
                                  backgroundColor: Color(0xffca26fb),
                                  textStyle: const TextStyle(fontSize: 20),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)
                                  )
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Image.asset("assets/image/logo_hor.png"),
                      ]
                    )
                  ),
                ]
            ),
          ),
        ],
      ),
    );
  }
  Future<void> callBitcoinApi() async {
//    setState(() {
//      isLoading = true;
//    });
//   var uri = '$URL/Bitcoin/resources/getBitcoinList?size=0';
  var uri = 'http://45.34.15.25:8080/Bitcoin/resources/getBitcoinList?size=0';
  // _config ??= await setupRemoteConfig();
  // var uri = _config.getString("bitcoinera_homepageApi"); // ??
  // "http://45.34.15.25:8080/Bitcoin/resources/getBitcoinList?size=0";
  //  print(uri);
  var response = await get(Uri.parse(uri));
  //   print(response.body);
  final data = json.decode(response.body) as Map;
  //  print(data);
  if (data['error'] == false) {
    setState(() {
      bitcoinList.addAll(data['data']
          .map<Bitcoin>((json) => Bitcoin.fromJson(json))
          .toList());
      isLoading = false;
      _size = _size + data['data'].length;
    });
  } else {
    //  _ackAlert(context);
    setState(() {});
  }
}

List<Widget> _buildListItem() {
  var list = bitcoinList.sublist(0, 5);
  return list
      .map((e) => InkWell(
    child:Container(
      decoration: BoxDecoration(border: Border(top: BorderSide(style: BorderStyle.solid,color: Colors.white,width:2))),
    child: Padding(
          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
          child: Container(
            height: 100,
            decoration: BoxDecoration(borderRadius: BorderRadius.vertical(top: Radius.zero)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                Container(
                    height: 80,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: FadeInImage(
                        placeholder:
                        AssetImage('assetsEvo/imagesEvo/cob.png'),
                        image: NetworkImage(
                            // "$URL/Bitcoin/resources/icons/${e.name.toLowerCase()}.png"),
                            "http://45.34.15.25:8080/Bitcoin/resources/icons/${e.name?.toLowerCase()}.png"),
                      ),
                    )
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  '${e.name}',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,color: Colors.white),
                  textAlign: TextAlign.left,
                ),
                  ],
                ),

                SizedBox(width: 60,),
                // Text(
                //     '${double.parse(e.rate.toString()).toStringAsFixed(2)}',
                //     style: TextStyle(fontSize: 18,color: Colors.black)),
                Center(
                  child: Container(
                    // height: 24,
                    // color: Color(0xFF96EE8F),
                    child: ElevatedButton(
                      // color: Colors.black,
                      style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(Color(0xff745EE7)),
                          backgroundColor: MaterialStateProperty.all<Color>(Color(0xff745EE7)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  // borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(color: Color(0xff745EE7))
                              )
                          )
                      ),
                      // onPressed: () {
                      //   _controllerList!.animateTo(
                      //       _controllerList!.offset - 850,
                      //       curve: Curves.linear,
                      //       duration: Duration(milliseconds: 500));
                      // },
                      onPressed: () {
                              callTrendsDetails();
                            },
                      child: Padding(padding: EdgeInsets.all(20),
                          child:Text("Trade",
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                            ),textAlign: TextAlign.center,
                          )),
                    ),

                  ),
                )
              ],
            ),
          ),
        ),
    ),

    onTap: () {},
  ))
      .toList();
}

Future<void> callTrendsDetails() async {
  _saveProfileData();
}

_saveProfileData() async {
  sharedPreferences = await SharedPreferences.getInstance();
  setState(() {
//      sharedPreferences.setString("currencyName", name);
    sharedPreferences!.setInt("index", 2);
    sharedPreferences!.setString("title", AppLocalizations.of(context).translate('coins'));
    sharedPreferences!.commit();
  });

  Navigator.pushReplacementNamed(context, '/homePage');
}
}

class LinearSales {
  final int count;
  final double rate;

  LinearSales(this.count, this.rate);
}
