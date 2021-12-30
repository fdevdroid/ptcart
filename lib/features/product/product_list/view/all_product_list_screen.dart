import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/src/di/di.dart';
import 'package:core/src/res/string_constants.dart';
import 'package:fluttercommerce/features/common/state/result_state.dart';
import 'package:network/network.dart';
import 'package:widgets/src/common_app_loader.dart';
import 'package:widgets/src/product_card.dart';
import 'package:widgets/src/result_api_builder.dart';
import 'package:fluttercommerce/features/product/product_list/view_model/all_product_cubit.dart';
import 'package:navigation/navigation.dart';

class AllProductListScreen extends StatefulWidget {
  const AllProductListScreen({Key? key, this.productCondition}) : super(key: key);

  final String? productCondition;

  @override
  _AllProductListScreenState createState() => _AllProductListScreenState();
}

class _AllProductListScreenState extends State<AllProductListScreen> {
  var allProductsCubit = DI.container<AllProductCubit>();
  ScrollController controller = ScrollController();

  @override
  void initState() {
    allProductsCubit.fetchProducts(widget.productCondition);
    if (widget.productCondition == null) {
      controller.addListener(_scrollListener);
    }
    super.initState();
  }

  void _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent && !controller.position.outOfRange) {
      print("at the end of list");
      allProductsCubit.fetchNextList(widget.productCondition);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(StringsConstants.allProducts),
        actions: <Widget>[
          InkWell(
            onTap: () {
              NavigationHandler.navigateTo(const SearchItemScreenRoute());
            },
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: const Icon(Icons.search),
            ),
          )
        ],
      ),
      body: BlocConsumer<AllProductCubit, ResultState<List<ProductModel>>>(
        bloc: allProductsCubit,
        listener: (BuildContext context, ResultState<List<ProductModel>> state) {},
        builder: (BuildContext context, ResultState<List<ProductModel>> state) {
          return ResultStateBuilder(
            state: state,
            loadingWidget: (bool isReloading) {
              return const Center(
                child: CommonAppLoader(),
              );
            },
            errorWidget: (String error) {
              return Container();
            },
            dataWidget: (List<ProductModel> value) {
              return dataWidget(value);
            },
          );
        },
      ),
    );
  }

  Widget dataWidget(List<ProductModel> productList) {
    return GridView.builder(
      controller: controller,
      itemCount: productList.length,
      padding: const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 30),
      itemBuilder: (BuildContext context, int index) {
        return ProductCard(productList[index]);
      },
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        childAspectRatio: 0.7,
        crossAxisSpacing: 10,
      ),
    );
  }
}
