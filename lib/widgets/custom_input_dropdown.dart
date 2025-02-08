import 'package:Acorn/services/app_colors.dart';
import 'package:Acorn/services/constants.dart';
import 'package:Acorn/services/custom_text.dart';
import 'package:Acorn/services/spacings.dart';
import 'package:Acorn/widgets/icon_presenter.dart';
import 'package:expandable_section/expandable_section.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomInputDropdown extends StatefulWidget {
  const CustomInputDropdown(
      {super.key,
      this.searchableData,
      this.text = '',
      this.hintText = '',
      this.onTextChanged});

  final List<dynamic>? searchableData;
  final String? text;
  final String hintText;
  //* Returns <T> if searchable, returns String if textfield
  final Function(dynamic data)? onTextChanged;

  @override
  State<CustomInputDropdown> createState() => _CustomInputDropdownState();
}

class _CustomInputDropdownState extends State<CustomInputDropdown> {
  late TextEditingController textEditingController;
  final RxBool _expand = true.obs;
  RxnString selectedIcon = RxnString(null);
  FocusNode focusNode = FocusNode();
  RxList<dynamic> searchableData = RxList<dynamic>();

  @override
  void initState() {
    runWidgetConfigurations();

    super.initState();
  }

  void runWidgetConfigurations() {
    selectedIcon.value = null;
    searchableData.value = widget.searchableData ?? [];
    textEditingController = TextEditingController();

    focusNode.requestFocus();
    textEditingController.selection = TextSelection(
        baseOffset: 0, extentOffset: textEditingController.value.text.length);
  }

  void onTextChanged(dynamic data) {
    if (widget.onTextChanged != null) {
      widget.onTextChanged!(data);
    }
  }

  @override
  Widget build(BuildContext context) {
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
        Obx(
          () => ExpandableSection(
            // curve: Curves.fastOutSlowIn,
            expand: _expand.value,
            child: (widget.searchableData ?? []).isEmpty
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppColors.whiteColor.withOpacity(0.5),
                      strokeWidth: Constants.circularProgressIndicatorStroke,
                    ),
                  )
                : Obx(
                    () => SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: list()),
                  ),
          ),
        )
      ],
    );
  }

  Widget searchTextField() {
    debugPrint('SELEECTED ICON: ${selectedIcon.value}');
    return Obx(
      () => TextFormField(
        onTap: () {
          textEditingController.selection = TextSelection(
              baseOffset: 0,
              extentOffset: textEditingController.value.text.length);
          focusNode.requestFocus();
          _expand.value = true;
        },
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
        style: Custom.header4('', isBold: true).style,
        decoration: InputDecoration(
          hintText: widget.text == null || (widget.text ?? '').isEmpty
              ? widget.hintText
              : widget.text,
          hintStyle: Custom.header4('', isBold: true).style,
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 10),
            child: selectedIcon.value == null
                ? const Icon(
                    Icons.search_outlined,
                    color: AppColors.secondaryColor,
                    size: 32,
                  )
                : IconPresenter(
                    icon: selectedIcon.value,
                    size: 22,
                  ),
          ),
          enabled: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          enabledBorder: _expand.value
              ? const OutlineInputBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  borderSide:
                      BorderSide(color: Colors.transparent), // No border color
                )
              : const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  borderSide:
                      BorderSide(color: Colors.transparent), // No border color
                ),
          focusedBorder: _expand.value
              ? const OutlineInputBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  borderSide:
                      BorderSide(color: Colors.transparent), // No border color
                )
              : const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  borderSide:
                      BorderSide(color: Colors.transparent), // No border color
                ),
          filled: true,
          fillColor: AppColors.darkGrayColor,
        ),
      ),
    );
  }

  Widget list() {
    if (searchableData.isEmpty) {
      return Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: RichText(
          text: TextSpan(
            style: Custom.body2('', isBold: false).style,
            children: [
              TextSpan(
                  text:
                      "Oops! We don't have that yet.\nAs an alternative, type in 'Others' for now and request it "),
              TextSpan(
                text: 'here',
                style: Custom.body2('', isBold: true)
                    .style
                    ?.copyWith(color: Colors.blueAccent),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    final Uri url = Uri.parse('https://www.google.com');
                    launchUrl(url, mode: LaunchMode.externalApplication);
                  },
              ),
              const TextSpan(text: '!'),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: searchableData.length,
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 3, bottom: 0),
      itemBuilder: (context, index) {
        var data = searchableData[index];
        String name = data.name ?? 'Placeholder';
        String? icon;

        try {
          icon = data.icon ?? '';
        } catch (e) {
          debugPrint('');
        }

        return Container(
          color: AppColors.darkGrayColor,
          padding:
              const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  textEditingController.text = name;
                  selectedIcon.value = icon;
                  _expand.value = false;
                  focusNode.unfocus();
                  onTextChanged(data);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconPresenter(icon: icon),
                    HorizSpace.fifteen(),
                    Custom.subheader1(name, isBold: false)
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
    );
  }
}
