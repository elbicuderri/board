// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(home: MyHomePage());
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   static const _greyColor = Color(0xFFE5E5E5);
//   static const _fontColor = Color(0xFF747779);

//   final FocusNode _titleFocusNode = FocusNode();
//   final FocusNode _discussionFocusNode = FocusNode();

//   // @override
//   // void initState() {
//   //   super.initState();
//   //   _discussionFocusNode.addListener(() {
//   //     setState(() {}); // Rebuild when focus changes
//   //   });
//   // }

//   @override
//   void dispose() {
//     _titleFocusNode.dispose();
//     _discussionFocusNode.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 10),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Icon(Icons.arrow_back_ios),
//                 Text(
//                   '글쓰기',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 Text(
//                   '등록',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: _greyColor,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 40),
//             Container(
//               // padding: EdgeInsets.symmetric(horizontal: 10),
//               width: double.infinity,
//               height: 60,
//               color: Colors.red,
//               // color: Color(0xFFE5E5E5),
//               // padding: EdgeInsets.all(16), // 내부 여백 추가
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 16),
//                   child: Text(
//                     '카테고리 선택',
//                     style: TextStyle(
//                       fontSize: 16, // 글자 크기
//                       color: _fontColor, // 글자 색상
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 12),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16),
//               child: TextField(
//                 focusNode: _titleFocusNode,
//                 style: TextStyle(
//                   color: Color(0xFF000000),
//                   fontWeight:
//                       _titleFocusNode.hasFocus
//                           ? FontWeight.bold
//                           : FontWeight.normal,
//                 ),
//                 decoration: InputDecoration(
//                   hintText: '제목',
//                   hintStyle: TextStyle(color: Color(0xFF747779), fontSize: 16),
//                   filled: true,
//                   fillColor: Colors.red, // 배경색 설정
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8), // 모서리 둥글게
//                     borderSide: BorderSide.none, // 기본 테두리 제거
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                     borderSide: BorderSide(
//                       color: Colors.black,
//                       width: 2.0,
//                     ), // 포커스 시 테두리
//                   ),
//                   contentPadding: EdgeInsets.all(12), // 내부 여백
//                 ),
//               ),
//             ),
//             SizedBox(height: 12),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16),
//               child: TextField(
//                 focusNode: _discussionFocusNode,
//                 style: TextStyle(
//                   color: Color(0xFF000000),
//                   fontWeight:
//                       _discussionFocusNode.hasFocus
//                           ? FontWeight.bold
//                           : FontWeight.normal,
//                 ),
//                 decoration: InputDecoration(
//                   hintText: '다양한',
//                   hintStyle: TextStyle(color: Color(0xFF747779), fontSize: 16),
//                   filled: true,
//                   fillColor: Colors.red, // 배경색 설정
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8), // 모서리 둥글게
//                     borderSide: BorderSide.none, // 기본 테두리 제거
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                     borderSide: BorderSide(
//                       color: Colors.black,
//                       width: 2.0,
//                     ), // 포커스 시 테두리
//                   ),
//                   contentPadding: EdgeInsets.all(12), // 내부 여백
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
