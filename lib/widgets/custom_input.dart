import 'package:Acorn/services/app_colors.dart';
import 'package:Acorn/services/constants.dart';
import 'package:Acorn/services/custom_text.dart';
import 'package:Acorn/services/spacings.dart';
import 'package:Acorn/widgets/icon_presenter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomInput extends StatefulWidget {
  const CustomInput(
      {super.key,
      this.isSearchable = false,
      this.searchableData,
      this.isTextField = false,
      this.autoFocus = true,
      this.prefixIcon,
      this.text = '',
      this.hintText = '',
      this.onTextChanged});

  final bool isSearchable;
  final bool isTextField;
  final bool autoFocus;
  final List<dynamic>? searchableData;
  final Widget? prefixIcon;
  final String text;
  final String hintText;
  //* Returns <T> if searchable, returns String if textfield
  final Function(dynamic data)? onTextChanged;

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput>
    with SingleTickerProviderStateMixin {
  late TextEditingController textEditingController;
  late bool isSearchable;
  late bool isTextField;
  FocusNode focusNode = FocusNode();
  RxList<dynamic> searchableData = RxList<dynamic>();

  @override
  void initState() {
    runWidgetConfigurations();

    super.initState();
  }

  //? Reasoning for this is, new searchable data does not rebuild the whole widget thus not calling initState again.
  @override
  void didUpdateWidget(covariant CustomInput oldWidget) {
    searchableData.value = widget.searchableData ?? [];
    // print("oldWidget.searchTerm is ${oldWidget.searchableData}");
    // print("widget.searchTerm is ${widget.searchableData}");

    if (oldWidget.searchableData != widget.searchableData) {
      updateChildWithParent();
    }
    super.didUpdateWidget(oldWidget);
  }

  void updateChildWithParent() {
    setState(() {
      searchableData.value = widget.searchableData ?? [];
    });

    // Do whatever you want here…
    // Like call api call again in child widget.
  }

  void runWidgetConfigurations() {
    debugPrint('INIT STATE');
    isSearchable = widget.isSearchable;
    isTextField = widget.isTextField;
    searchableData.value = widget.searchableData ?? [];
    textEditingController = TextEditingController();

    if (widget.autoFocus) {
      focusNode.requestFocus();
      textEditingController.selection = TextSelection(
          baseOffset: 0, extentOffset: textEditingController.value.text.length);
    }
  }

  void onTextChanged(dynamic data) {
    if (widget.onTextChanged != null) {
      widget.onTextChanged!(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.isSearchable) {
          setState(() {
            isSearchable = true;
            focusNode.requestFocus();
            textEditingController.selection = TextSelection(
                baseOffset: 0,
                extentOffset: textEditingController.value.text.length);
          });
        } else if (widget.isTextField) {
          setState(() {
            isTextField = true;
            focusNode.requestFocus();
            textEditingController.selection = TextSelection(
                baseOffset: 0,
                extentOffset: textEditingController.value.text.length);
          });
        }
      },
      child: AnimatedSize(
        duration: Duration(milliseconds: Constants.appAnimations),
        curve: Curves.fastOutSlowIn,
        child: Container(
          margin: const EdgeInsets.only(bottom: 5),
          width: Get.width,
          padding: isSearchable
              ? null
              : const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          decoration: BoxDecoration(
              color: AppColors.lightGrayColor,
              borderRadius: BorderRadius.circular(15)),
          child: isSearchable
              ? searchableField()
              : isTextField
                  ? textField()
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        widget.prefixIcon != null
                            ? widget.prefixIcon!
                            : const SizedBox(),
                        HorizSpace.fifteen(),
                        Custom.header3(
                            widget.text.isEmpty ? widget.hintText : widget.text,
                            isBold: widget.text.isEmpty ? false : true)
                      ],
                    ),
        ),
      ),
    );
  }

  Widget searchableField() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: searchTextField()),
          ],
        ),
        ConstrainedBox(
          constraints:
              BoxConstraints(minHeight: 100, maxHeight: Get.height * 0.35),
          child: (widget.searchableData ?? []).isEmpty
              ? Center(
                  child: CircularProgressIndicator(
                    color: AppColors.whiteColor.withOpacity(0.5),
                    strokeWidth: Constants.circularProgressIndicatorStroke,
                  ),
                )
              : Obx(
                  () => ListView.builder(
                    itemCount: searchableData.length,
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    itemBuilder: (context, index) {
                      var data = searchableData[index];
                      String name = data.name ?? 'Placeholder';
                      String? icon;

                      try {
                        icon = data.icon ?? '';
                      } catch (e) {
                        debugPrint('');
                      }

                      return Padding(
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  textEditingController.text = name;
                                  isSearchable = false;
                                  onTextChanged(data);
                                });
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconPresenter(icon: icon),
                                  HorizSpace.fifteen(),
                                  Custom.subheader1(name, isBold: true)
                                ],
                              ),
                            ),
                            VertSpace.eight(),
                            Divider(
                              thickness: 0.25,
                              color: AppColors.whiteColor.withOpacity(0.25),
                              indent: 5,
                              endIndent: Get.width * 0.1,
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
        )
      ],
    );
  }

  Widget searchTextField() {
    return TextFormField(
      onChanged: (searchString) {
        searchableData.value = (widget.searchableData ?? [])
            .where((data) => (data.name as String)
                .toLowerCase()
                .contains(searchString.toLowerCase()))
            .toList();
      },
      controller: textEditingController,
      focusNode: focusNode,
      cursorColor: AppColors.whiteColor,
      cursorHeight: 24,
      cursorRadius: const Radius.elliptical(30, 30),
      style: const TextStyle(
          color: AppColors.whiteColor,
          fontSize: 24,
          fontWeight: FontWeight.w700),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(
            color: AppColors.whiteColor.withOpacity(0.5),
            fontSize: 24,
            fontWeight: FontWeight.w400),
        prefixIcon: const Icon(
          Icons.search_outlined,
          color: AppColors.secondaryColor,
          size: 32,
        ),
        suffixIcon: GestureDetector(
          onTap: () {
            if (widget.isSearchable) {
              setState(() {
                isSearchable = false;
              });
            }
          },
          child: const Icon(
            Icons.check_outlined,
            color: AppColors.monthlyColor,
            size: 32,
          ),
        ),
        enabled: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          borderSide: BorderSide(color: Colors.transparent), // No border color
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          borderSide: BorderSide(
              color: Colors.transparent), // No border colorr color when focused
        ),
        filled: true,
        fillColor: AppColors.darkGrayColor,
      ),
    );
  }

  Widget textField() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        widget.prefixIcon != null ? widget.prefixIcon! : const SizedBox(),
        HorizSpace.fifteen(),
        Expanded(
          child: TextFormField(
            onChanged: (value) {
              if (widget.isTextField) {
                if (widget.onTextChanged != null) {
                  widget.onTextChanged!(textEditingController.text);
                }
              }
            },
            controller: textEditingController,
            focusNode: focusNode,
            cursorColor: AppColors.whiteColor,
            cursorHeight: 24,
            cursorRadius: const Radius.elliptical(30, 30),
            style: const TextStyle(
                color: AppColors.whiteColor,
                fontSize: 24,
                fontWeight: FontWeight.w700),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(
                  color: AppColors.whiteColor.withOpacity(0.5),
                  fontSize: 24,
                  fontWeight: FontWeight.w400),
              suffixIcon: GestureDetector(
                onTap: () {
                  if (widget.isTextField) {
                    setState(() {
                      isTextField = false;
                    });
                  }
                },
                child: const Icon(
                  Icons.check_outlined,
                  color: AppColors.monthlyColor,
                  size: 32,
                ),
              ),
              enabled: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                borderSide:
                    BorderSide(color: Colors.transparent), // No border color
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                borderSide: BorderSide(
                    color: Colors
                        .transparent), // No border colorr color when focused
              ),
              filled: true,
              fillColor: AppColors.darkGrayColor,
            ),
          ),
        ),
      ],
    );
  }
}
