import 'package:flutter/material.dart';

class BackgroundImageWidget extends StatelessWidget {
  final Widget child;
  final ImageProvider image;

  const BackgroundImageWidget({
    Key? key, required this.child, required this.image
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ShaderMask(
    shaderCallback: (rect) => const LinearGradient(
      colors: [
        Colors.transparent,
        Colors.white,
      ],
      begin: Alignment.topCenter,
      end: Alignment.center
    ).createShader(rect),
    blendMode: BlendMode.darken,
    child: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: image,
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.1), 
            BlendMode.darken
          )
        ),
      ),
      child:child
    ),
  );
  
}

// ShaderMask(
//     shaderCallback: (rect) => const LinearGradient(
//       colors: [
//         Colors.white38,
//         Colors.white70,
//       ],
//       begin: Alignment.topCenter,
//       end: Alignment.center
//     ).createShader(rect),
//     blendMode: BlendMode.darken,
//     child: Container(
//       decoration: BoxDecoration(
//         image: DecorationImage(
//           image: image,
//           fit: BoxFit.cover,
//           colorFilter: ColorFilter.mode(
//             Colors.black.withOpacity(0.1), 
//             BlendMode.darken
//           )
//         ),
//       ),
//       child:child
//     ),
//   )