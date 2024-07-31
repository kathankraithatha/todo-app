import 'dart:ffi';
import 'package:flutter/material.dart';
class RouteFunction{
  Route createRoute(final Widget screenName){
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screenName,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin=Offset(2.0, 0.0);
        const end=Offset.zero;
        const curve=Curves.linear;
        var tween=Tween(begin: begin,end: end).chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween),child: child,);
      },
    );
  }
}