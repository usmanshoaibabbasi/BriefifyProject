import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget shimmereffect({context}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 30),
    padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
    decoration: const BoxDecoration(
      color: Color(0xffFFFFFF),
      borderRadius: BorderRadius.all(Radius.circular(20),
      ),
    ),
    child: Shimmer.fromColors(
        baseColor: const Color(0XffD3D3D3),
        highlightColor: const Color(0xffBBBBBB),
        child: Row(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Color(0xffFFFFFF),
                borderRadius: BorderRadius.all(Radius.circular(200),
                ),
              ),
              height: 50,
              width: 50,
            ),
            const SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: const Color(0xffFFFFFF),
                  height: 20,
                  width: MediaQuery.of(context).size.width*0.35,
                ),
                const SizedBox(height: 5,),
                Container(
                  color: const Color(0xffFFFFFF),
                  height: 20,
                  width: MediaQuery.of(context).size.width*0.6,
                ),
              ],
            )
          ],
        )
    ),
  );
}