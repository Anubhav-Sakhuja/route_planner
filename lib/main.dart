
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:route_planner/dijkstra.dart';

void main() {
  runApp(MaterialApp(home: Home()));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

int mode = 0;
double posx, posy;
List<List<double>> nodesList = [];
List<int> twoNodes = [];
List<int> destNodes = [];
int index;
List<List<int>> links = [];

List<List<dynamic>> LinksAndWeights =[];
List<dynamic> routeList = [];


class _HomeState extends State<Home> {
  ImageProvider mapImage;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
      var  _image = FileImage(File(pickedFile.path));
        mapImage = _image;
      } else {
        print('No image selected.');
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.black87,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: <Widget>[
              Positioned(
                left: (size.width - 150) / 2,
                top: 10,
                child: Container(
                  height: 50,
                  width: 150,
                  child: RaisedButton(
                    onPressed: () {
getImage();
                    },
                    color: Colors.grey,
                    child: Text(
                      "Get Image",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              ), //getimage
              Visibility(
                visible:(mapImage!=null)?true:false ,
                child: Positioned(
                    child: GestureDetector(
                  onTapDown: (TapDownDetails details) {
                    setState(() {
                      posx = details.localPosition.dx;
                      posy = details.localPosition.dy;
                      if (mode == 2 || mode == 3) {
                        setState(() {
                          index = detectNode();
                        });
                      }
                    });
                  },
                  child: Container(
                    height: size.height * 0.8,
                    width: size.width,
                    color: Colors.white12,
                    child: DecoratedBox(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: (mapImage != null)
                                    ? mapImage
                                    : AssetImage("noImage"))
                            ),
                        child: CustomPaint(
                          painter: NLDpainter(),
                          child: Container(
                            height: size.height * 0.8,
                            width: size.width,
                          ),
                        )),
                    // child: (mapImage!=null)?Image(image: mapImage):Center()
                  ),
                )),
              ), //image
              Positioned(
                left: 10,
                bottom: 70,
                child: Container(
                  height: 40,
                  width: size.width / 3.5,
                  child: RaisedButton(
                    onPressed: () {
                      setState(() {

                        twoNodes = [];
                        posx = posy = 0;
                        mode = 1;
                      });
                    },
                    color: Colors.grey,
                    child: Text(
                      "Nodes",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              ), //nodes
              Positioned(
                left: size.width * (1 - 1 / 3.5) / 2,
                bottom: 70,
                child: Container(
                  height: 40,
                  width: size.width / 3.5,
                  child: RaisedButton(
                    onPressed: () {
                      setState(() {

                        twoNodes = [];
                        posx = posy = 0;
                        mode = 2;
                      });
                    },
                    color: Colors.grey,
                    child: Text(
                      "Link",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              ), //link
              Positioned(
                right: 10,
                bottom: 70,
                child: Container(
                  height: 40,
                  width: size.width / 3.5,
                  child: RaisedButton(
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      setState(() {
                        routeList = destNodes=[];
                        twoNodes = [];
                        posx = posy = 0;
                        mode = 3;
                      });
                    },
                    color: Colors.grey,
                    child: Text(
                      "Destinations",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ), //destinations
              Positioned(
                right: 30,
                bottom: 10,
                child: Container(
                  height: 40,
                  width: size.width / 3.5,
                  child: RaisedButton(
                    onPressed: () {
                          dijkstra dj = dijkstra(links: LinksAndWeights,nodes: nodesList.length,startNode:destNodes[0]);

                          dj.generateTable();
                          setState(() {
                            routeList = dj.calculateShortestDistance(destNodes[1]);
                          });

                          },
                    color: Colors.grey,
                    child: Text(
                      "Find",
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                  ),
                ),
              ),//find
              Positioned(
                left: 30,
                bottom: 10,
                child: Container(
                  height: 40,
                  width: size.width / 3.5,
                  child: RaisedButton(
                    onPressed: () {
                      switch (mode) {
                        case 1:
                          nodesList.add([posx, posy]);
                          print("the node list is ${nodesList}");
                          break;
                        case 2:
                          links.add(twoNodes);
                          LinksAndWeights.add(addWeight(twoNodes));
                          print("the links are $links");print("the linksandweight list is $LinksAndWeights");
                          int a = twoNodes[1];
                          twoNodes = [a];
                          break;
                        case 3:destNodes.add(index);
                        index =null;
                        break;
                        default:print("error  ");
                      }
                    },
                    color: Colors.grey,
                    child: Text(
                      "Fix",
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                  ),
                ),
              ) //fix
            ],
          ),
        ),
      ),
    );
  }



  int detectNode() {
    if (nodesList != null) {
      for (List<double> xy in nodesList) {
        if (sqrt(pow(posx - xy[0], 2) + pow(posy - xy[1], 2)) <= 10) {
          setState(() {
            if (mode == 2) {
              twoNodes.add(nodesList.indexOf(xy));

              print(twoNodes.length);
            }
          });
          return nodesList.indexOf(xy);
        }
      }
      setState(() {
        twoNodes = [];
      });
      return null;
    } else {
      setState(() {
        twoNodes = [];
      });

      return null;
    }
  }
  List<dynamic> addWeight(List<int> ll){
    double dis = sqrt(pow((nodesList[ll[0]][0] -nodesList[ll[1]][0]),2) + pow((nodesList[ll[0]][1] -nodesList[ll[1]][1]),2) );
     return [ll[0],ll[1],dis];
  }
}

class NLDpainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double xx, yy;
    var _paintNode = new Paint();
    _paintNode.color = Colors.black87;
    _paintNode.style = PaintingStyle.fill;
    var _activeNode = new Paint();
    _activeNode.color = Colors.redAccent;
    _activeNode.style = PaintingStyle.fill;
    var _activeLink = new Paint();
    _activeLink.color = Colors.redAccent;
    _activeLink.style = PaintingStyle.stroke;
    _activeLink.strokeWidth = 5;
    var _paintLink = new Paint();
    _paintLink.color = Colors.black87;
    _paintLink.style = PaintingStyle.stroke;
    _paintLink.strokeWidth = 5;
    var _paintDest = new Paint();
    _paintDest.color = Colors.blueAccent;
    _paintDest.style = PaintingStyle.fill;
    var _paintRoute = new Paint();
    _paintRoute.color = Colors.black87;
    _paintRoute.style = PaintingStyle.stroke;
    _paintRoute.strokeWidth = 5;



      //nodes !!
      if (mode == 1) {
        canvas.drawCircle(Offset(posx, posy), 10, _paintNode);
      }
      if (nodesList != null) {
        for (List<double> xy in nodesList) {
          canvas.drawCircle(Offset(xy[0], xy[1]), 10, _paintNode);
        }
      }
      // links !!
      if (mode == 2) {
        if (twoNodes.length == 2) {
          canvas.drawLine(
              Offset(nodesList[twoNodes[0]][0], nodesList[twoNodes[0]][1]),
              Offset(nodesList[twoNodes[1]][0], nodesList[twoNodes[1]][1]),
              _activeLink);
        }
      }
      if (links != null) {
        for (List<int> ab in links) {
          canvas.drawLine(Offset(nodesList[ab[0]][0], nodesList[ab[0]][1]),
              Offset(nodesList[ab[1]][0], nodesList[ab[1]][1]), _paintLink);
        }
      }
// destinations !!
      if (destNodes != []) {
        for (int a in destNodes) {
          canvas.drawCircle(Offset(nodesList[a][0], nodesList[a][1]), 10, _paintDest);
        }
      }



    if (mode == 3 || mode == 2) {
      if (index != null) {
        canvas.drawCircle(
            Offset(nodesList[index][0], nodesList[index][1]), 10, _activeNode);
      }
    }
    if(routeList!=[]){
      for(int i =0 ; i<routeList.length-1;i++){
        canvas.drawCircle(
            Offset(nodesList[routeList[i]][0], nodesList[routeList[i]][1]), 10, _paintDest);

      }

    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
