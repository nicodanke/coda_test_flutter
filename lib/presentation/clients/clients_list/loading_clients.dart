import 'package:coda_flutter_test/presentation/utils/shimmer_loading_effect.dart';
import 'package:flutter/material.dart';

class LoadingClientShimmer extends StatelessWidget {
  const LoadingClientShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<int> list = [1,2,3,4];
    return SizedBox(
      height: 510,
      child: Shimmer(
        child: Padding(
          padding: const EdgeInsets.only(top:20),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(10),
                child: ShimmerLoading(
                  child: Container(
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
