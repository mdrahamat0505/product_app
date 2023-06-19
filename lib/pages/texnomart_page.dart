import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_repositories/pages/texnomart_detail.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import 'bloc/events/texnomart_event.dart';
import 'bloc/states/texnomart_state.dart';
import 'bloc/texnomart_bloc.dart';

class TexnomartPage extends StatefulWidget {

  @override
  State<TexnomartPage> createState() => _TexnomartPageState();
}

class _TexnomartPageState extends State<TexnomartPage> {
  final bloc = TexnomartBloc();
  final controller = RefreshController();
  final controllerTe = TextEditingController();
  var current = 0;
  @override
  void initState() {
    bloc.add((TexnomartCatByProductsEvent()));
    bloc.add(TexnomartInitEvent(current));
    super.initState();
  }

  @override
  void dispose() {
    bloc.close();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: BlocConsumer<TexnomartBloc, TexnomartState>(
        listener: (context, state) {
          if (state.status == Status.loadingNextSuc) {
            controller.refreshCompleted();
            controller.loadComplete();
          }
        },
        builder: (context, state) {
          return SafeArea(
              child: Scaffold(
                backgroundColor: Colors.white,
                body: Builder(builder: (context) {
                  if (state.status == Status.loadingFirst) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Container(
                              width: double.infinity,
                              margin:
                              const EdgeInsets.only(left: 17, bottom: 10, right: 17),
                              child: TextField(
                                onSubmitted: (value) {
                                  if(value.isEmpty){
                                    bloc.add(TexnomartInitEvent(current));
                                  }
                                  else{
                                    bloc.add(
                                        TexnomartSearchEvent(value));

                                  }
                                  return;

                                },
                                textInputAction: TextInputAction.go,
                                controller: controllerTe,
                                cursorColor: Colors.black,
                                enableInteractiveSelection: true,
                                style: const TextStyle(fontSize: 15.5),
                                decoration: InputDecoration(
                                  hintText: "Products...",
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      bloc.add(
                                          TexnomartSearchEvent(controllerTe.text));
                                    },
                                    child: const Icon(
                                      Icons.search,
                                      color: Colors.black,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(13),
                                    borderSide: const BorderSide(
                                      color: Color(0xff626262),
                                      width: 2.0,
                                    ),
                                  ),
                                  hintStyle: const TextStyle(
                                      fontSize: 15.5, color: Color(0xff878787)),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 18),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            height: 59,
                            child: ListView.builder(
                              itemCount: state.categorys.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8, right: 8, top: 10, bottom: 10),
                                  child: ZoomTapAnimation(
                                    onTap: () {
                                      setState(() {
                                        current = index;
                                        print(state.categorys[current].slug
                                            .toString());
                                        bloc.add(TexnomartCatByProductsEvent(
                                            slug: state.categorys[current].slug
                                                .toString()));
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12.0),
                                        color: index == current
                                            ? const Color(0xfffbc200)
                                            : const Color(0xffffffff),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 18, vertical: 10),
                                            child: Text(
                                              state.categorys[index].title
                                                  .toString(),
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: index == current
                                                      ? Colors.black
                                                      : Colors.black),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Container(
                            height: 590,
                            child: Builder(
                              builder: (context) {
                                if (state.status == Status.loadingFirst ||
                                    state.status == Status.loadingSearch) {
                                  return const Center(child: CircularProgressIndicator());
                                } else {
                                  return Container(
                                    height: double.infinity,
                                    width: double.infinity,
                                    child: SmartRefresher(
                                      enablePullDown: false,
                                      enablePullUp: true,
                                      controller: controller,
                                      onLoading: () => bloc.add(TexnomartNextEvent(
                                          slug: state.categorys[current].slug
                                              .toString())),
                                      child: GridView.builder(
                                        physics: const BouncingScrollPhysics(),
                                        itemCount: state.products.length,
                                        gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 8,
                                          childAspectRatio: 2 / 2.5,
                                          mainAxisSpacing: 2,
                                        ),
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(top: 5),
                                            child: ZoomTapAnimation(

                                              onTap: () {
                                                Navigator.push(context, MaterialPageRoute(builder: (context){

                                                  return  TexnoDetailScreen(item:state.products[index]);
                                                },));
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 9.0,
                                                    right: 10,
                                                    left: 10,
                                                    top: 8),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                      BorderRadius.circular(16),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color:
                                                          Colors.grey.shade400,
                                                          blurRadius: 4,
                                                          offset:
                                                          const Offset(2, 2),
                                                        )
                                                      ]),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                        height: 100,
                                                        width: double.infinity,
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                          image: DecorationImage(
                                                              fit: BoxFit.fill,
                                                              image: NetworkImage(
                                                                  "https://backend.texnomart.uz${state.products[index].image}")),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets.only(
                                                            top: 8,
                                                            left: 8,
                                                            right: 8),
                                                        child: Expanded(
                                                          flex: 0,
                                                          child: Text(
                                                            textAlign:
                                                            TextAlign.start,
                                                            state.products[index]
                                                                .name
                                                                .toString(),
                                                            maxLines: 1,
                                                            style: const TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                              FontWeight.w400,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 8,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets.only(
                                                                top: 3,
                                                                left: 10,
                                                                right: 8),
                                                            child: Text(
                                                              state.products[index]
                                                                  .fSalePrice
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                                  fontSize: 16,
                                                                  color:
                                                                  Colors.black),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        children: [
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          Container(
                                                            padding:
                                                            const EdgeInsets.only(
                                                                top: 7,
                                                                bottom: 7),
                                                            decoration:
                                                            BoxDecoration(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  9.0),
                                                              color:
                                                              const Color(0xfffbc200),
                                                            ),
                                                            child:  Row(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                              children: [
                                                                SizedBox(
                                                                  width: 6,
                                                                ),
                                                                Icon(
                                                                  Icons
                                                                      .shopping_cart,
                                                                  color:
                                                                  Colors.black,
                                                                  size: 22,
                                                                ),
                                                                SizedBox(
                                                                  width: 8,
                                                                ),
                                                                Text(
                                                                  "Savatchaga",
                                                                  style: TextStyle(
                                                                      fontSize: 15,
                                                                      color: Colors
                                                                          .black54,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                                ),
                                                                SizedBox(
                                                                  width: 8,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                }),
              ));
        },
      ),
    );
  }
}
