import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:todo/services/addImages/gallery_image.dart';
import 'package:todo/utils/styles.dart';

class FullImageView extends StatefulWidget {
  final String url;
  final String path;
  final String documentId;
  const FullImageView({
    Key? key,
    required this.url,
    required this.path,
    required this.documentId,
  }) : super(key: key);

  @override
  _FullImageViewState createState() => _FullImageViewState();
}

class _FullImageViewState extends State<FullImageView> {
  bool deleted = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red[400],
        onPressed: () async {
          print(widget.documentId);
          setState(() {
            deleted = true;
          });
          await AddGalleryImage().deleteImage(
            widget.path,
            widget.documentId,
            context,
          );
          setState(() {
            deleted = false;
          });
          Navigator.pop(context);
        },
        child: Icon(
          Icons.delete,
          size: ScreenUtil().setSp(
            25,
          ),
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Gallery Image",
          style: MidBoldText,
        ),
        centerTitle: true,
      ),
      body: ModalProgressHUD(
        inAsyncCall: deleted,
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setSp(20),
            vertical: ScreenUtil().setSp(10),
          ),
          child: Center(
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: widget.url,
              placeholder: (context, url) => Image.asset(
                "images/placeholder.png",
              ),
            ),
          ),
        ),
      ),
    );
  }
}
