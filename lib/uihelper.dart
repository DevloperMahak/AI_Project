import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UiHelper{
  static CustomTextField1(TextEditingController controller,String text,IconData iconData,bool toHide){
    return  Center(
        child:Container(
            margin: const EdgeInsets.only(top:5,bottom: 10),
            height: 48,
            width: 366,
            child:TextField(
                controller: controller,
                obscureText: toHide,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: text,
                  labelStyle:TextStyle(color: Colors.white),
                  prefixIcon: Icon(iconData,color:Color(0xffD9D9D9) ,),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffD9D9D9)),
                      borderRadius: BorderRadius.circular(30),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffD9D9D9)),
                    borderRadius: BorderRadius.circular(30),
                  ),
                )
            )
        ));
  }
  static CustomTextField2(TextEditingController controller,String text,IconData iconData1,iconData2,bool toHide){
    return  Center(
        child:Container(
            margin: const EdgeInsets.only(top:5,bottom: 10),
            height: 48,
            width: 366,
            child:TextField(
                controller: controller,
                obscureText: toHide,
                decoration: InputDecoration(
                  hintText: text,
                  prefixIcon: Icon(iconData1,color:Color(0xffD9D9D9) ,),
                  suffixIcon: Icon(iconData2,color:Color(0xffD9D9D9),),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffD9D9D9))),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffD9D9D9))),
                )
            )
        ));
  }
  static CustomTextField3(TextEditingController controller,String text,bool toHide){
    return  Center(
        child:Container(
            margin: const EdgeInsets.only(top:5,bottom: 10),
            height: 48,
            width: 366,
            child:TextField(
                controller: controller,
                obscureText: toHide,
                decoration: InputDecoration(
                  hintText: text,
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffFFB330))),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffFFB330))),
                )
            )
        ));
  }
  static CustomTextField4(TextEditingController controller,String text,IconData iconData,bool toHide){
    return  Center(
        child:Container(
            margin: const EdgeInsets.only(top:5,bottom: 10),
            height: 48,
            width: 366,
            child:TextField(
                controller: controller,
                obscureText: toHide,
                decoration: InputDecoration(
                  hintText: text,
                  suffixIcon: Icon(iconData,color:Color(0xffFFB330) ,),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffFFB330))),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffFFB330))),
                )
            )
        ));
  }
  // Add in UiHelper.dart
  static Widget label(String text) {
    return Container(
      margin: const EdgeInsets.only(left: 23, top: 15),
      child: Text(text, style: TextStyle(fontSize: 16)),
    );
  }
  static CustomButton(VoidCallback voidcallback,String text){
    return Center(
        child:Container(
          margin: const EdgeInsets.only(top:20,bottom: 10),
          height: 48,
          width: 366,
          child: ElevatedButton(onPressed: (){
            voidcallback();
          }, style: ElevatedButton.styleFrom(
              foregroundColor: Color(0xff5F2C82),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)
              )
          ),
              child: Text(text,)),));
  }
  static CustomAlertBox(BuildContext context,String text){
    return showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text(text),
      );
    });
  }
}