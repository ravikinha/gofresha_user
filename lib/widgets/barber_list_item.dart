// ignore_for_file: public_member_api_docs, sort_constructors_first, deprecated_member_use
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../models/barberShopModel.dart';
import '../screens/barberShopDescriptionScreen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:app/models/businessLayer/global.dart' as global;

import 'widgets.dart';

class BarberListItem extends StatelessWidget {
  final BarberShop barberShop;
  const BarberListItem({
    Key? key,
    required this.barberShop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => BarberShopDescriptionScreen(
                    vendorId: barberShop.vendor_id,
                  )),
        );
      },
      child: Card(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CachedNetworkImage(
              imageUrl: global.baseUrlForImage + barberShop.vendor_logo!,
              imageBuilder: (context, imageProvider) => Container(
                height: 85,
                width: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        fit: BoxFit.cover, image: imageProvider)),
              ),
              placeholder: (context, url) =>
                  Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Container(
                height: 85,
                width: 100,
                padding: EdgeInsets.all(8),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: Center(
                    child: Text(
                        AppLocalizations.of(context)!.txt_no_image_availa)),
              ),
            ),
            Expanded(
              child: ListTile(
                isThreeLine: true,
                title: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    capitalize('${barberShop.vendor_name}'),
                    style: Theme.of(context).primaryTextTheme.bodyText1,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 20,
                        ),
                        Expanded(
                          child: Text(
                            barberShop.vendor_loc != null &&
                                    barberShop.vendor_loc != ""
                                ? '${barberShop.vendor_loc}'
                                : 'Location not provided',
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).primaryTextTheme.bodyText2,
                          ),
                        ),
                      ],
                    ),
                    if (barberShop.rating != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('${barberShop.rating}',
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .bodyText1),
                            barberShop.rating != null
                                ? RatingBar.builder(
                                    initialRating: barberShop.rating!,
                                    minRating: 0,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemSize: 8,
                                    itemPadding:
                                        EdgeInsets.symmetric(horizontal: 0),
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    ignoreGestures: true,
                                    updateOnDrag: false,
                                    onRatingUpdate: (rating) {},
                                  )
                                : SizedBox()
                          ],
                        ),
                      )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
