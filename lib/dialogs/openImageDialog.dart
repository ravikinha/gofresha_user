import 'dart:typed_data';

import 'package:app/models/barberShopDescModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:app/models/businessLayer/global.dart' as global;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OpenImageDialog extends StatefulWidget {
  final Uint8List? image;
  final BarberShopDesc? barberShopDesc;
  final int? index;
  final String? name;

  OpenImageDialog(
      {a, o, this.image, this.barberShopDesc, this.index, this.name})
      : super();
  @override
  OpenImageDialogState createState() => OpenImageDialogState(
      this.image, this.barberShopDesc, this.index, this.name);
}

class OpenImageDialogState extends State<OpenImageDialog> {
  final Uint8List? image;
  BarberShopDesc? barberShopDesc;
  int? index;
  String? name;
  OpenImageDialogState(this.image, this.barberShopDesc, this.index, this.name)
      : super();
  int? currentIndex = 0;
  PageController? pageController;
  @override
  void initState() {
    super.initState();
    if (index != null) {
      pageController = new PageController(initialPage: index!);
      currentIndex = index;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.lbl_gallery),
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
          child: barberShopDesc != null && index != null
              ? PhotoViewGallery.builder(
                  customSize: Size(300, 300),
                  scrollPhysics: const BouncingScrollPhysics(),
                  builder: (BuildContext context, int index) {
                    return PhotoViewGalleryPageOptions(
                      imageProvider: CachedNetworkImageProvider(
                          global.baseUrlForImage +
                              barberShopDesc!.gallery[index].image!),
                      initialScale: PhotoViewComputedScale.contained * 0.8,
                    );
                  },
                  itemCount: barberShopDesc!.gallery.length,
                  loadingBuilder: (context, event) => Center(
                    child: Container(
                      width: 20.0,
                      height: 20.0,
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                        strokeWidth: 2,
                        value: event == null
                            ? 0
                            : event.cumulativeBytesLoaded /
                                event.expectedTotalBytes!,
                      ),
                    ),
                  ),
                  backgroundDecoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                  pageController: pageController,
                )
              : PhotoView(
                  backgroundDecoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  imageProvider: MemoryImage(image!),
                )),
    );
  }
}
