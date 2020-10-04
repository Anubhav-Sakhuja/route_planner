import 'package:flutter/services.dart';

class dijkstra{
  int startNode = 0;
  List<List<dynamic>> links ;
  int nodes;
  dijkstra({this.links ,this.nodes, this.startNode});
  List<int> visitedNodes = [];
  List<int> unVisitedNodes = [];
  List<Dnode> ndp =[];//node distance parent
void generateTable(){
  // creating all unvisited nodes and ndp
  for(int i = 0;i<nodes ; i++){
    unVisitedNodes.add(i);
    if(i==startNode)
    {
      ndp.add(Dnode(node: i,distance: 0,parent: null));
    }else{
      ndp.add(Dnode(node: i,distance: double.infinity,parent: null));
    }
  }
  Dnode currDNode ;
while(unVisitedNodes.length!=0){
    // giving priority to the node with smallest distance from parent !
  currDNode = smallestDistanceDnode(unVisitedNodes);


  for(List<dynamic>  i in links){
    if(currDNode.node==i[0] || currDNode.node==i[i.length-1-1]){
      print("${currDNode.node} lalal 1");
      int nextNode , flag;
      if(currDNode.node==i[0]){nextNode = i[i.length-1-1];}else{nextNode=i[0];}
      for(int i in unVisitedNodes){
        if(nextNode==i){
          flag =1;
          break;
        }
      }
      if(flag ==1){

        print("if a is currnode ${currDNode.node} and b is next node $nextNode then ${currDNode.distance +i[i.length-1]}  distance of bc ${ndp[nextNode].distance }");
        if(ndp[nextNode].distance>currDNode.distance+i[i.length-1]){

          ndp[nextNode].distance = currDNode.distance+i[i.length-1];
          ndp[nextNode].parent = currDNode.node;
        }
      }
    }
  }
  unVisitedNodes.remove(currDNode.node);
  visitedNodes.add(currDNode.node);
  print("the current node is ${currDNode.node} , the left nodes are $unVisitedNodes");
}
for (Dnode i in ndp){
  print("node = ${i.node} , distance = ${i.distance} , Parent = ${i.parent}");
}
}
List<dynamic> calculateShortestDistance(int destinationNode){

  List<dynamic> path =[destinationNode];
  int node = destinationNode;
  double distance =0;
  while(node!=startNode){
    for (Dnode i in ndp){
      if(i.node==node){
        node = i.parent;
        path.add(node);
        distance+=i.distance;
        break;
      }
    }
  }
  path.add(distance);
  print(path);
return path;
}
Dnode smallestDistanceDnode(List<int> leftNodes){
  double min = double.infinity;
  Dnode minDnode;
  for(Dnode i in ndp){
    for(int j in leftNodes){
      if(j==i.node){
        if(i.distance == 0){
          return i;
        }else if(i.distance<min){
          min = i.distance;
          minDnode = i;
        }
      }
    }

  }
  return minDnode;
}
}

class Dnode {
  int node;
  double distance;
  int parent;
  Dnode({this.node,this.distance,this.parent});

}