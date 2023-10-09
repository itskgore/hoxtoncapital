import 'package:flutter/material.dart';
import 'package:wedge/core/contants/theme_contants.dart';

class ImagePickerDialog extends StatelessWidget {
  final Function onTap;

  const ImagePickerDialog({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)), //this right here
      child: SizedBox(
        height: 360,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Upload profile picture",
                      textAlign: TextAlign.center,
                      style: TitleHelper.h8,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                        "You can upload image files up to a maximum size of 2MB. ",
                        textAlign: TextAlign.center,
                        style: SubtitleHelper.h11.copyWith(
                          height: 1.4,
                        ))
                  ],
                ),
              ),
              const Spacer(),
              getPopUpButtons(
                  icon: Icons.camera_alt,
                  onTap: () {
                    onTap(false);
                    // imagePicker(false);
                  },
                  title: "Take a picture"),
              const SizedBox(
                height: 20,
              ),
              getPopUpButtons(
                  icon: Icons.cloud_upload,
                  onTap: () {
                    onTap(true);
                  },
                  title: "Upload from phone"),
              const SizedBox(
                height: 25,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cancel,
                      size: 20,
                      color: Colors.red[300],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Cancel",
                      style: TextStyle(
                          color: Colors.red[300], fontSize: kfontMedium),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget getPopUpButtons(
    {required IconData icon,
    required String title,
    required Function() onTap}) {
  return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            backgroundColor: Colors.white,
            elevation: 3,
            primary: Colors.black,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: Colors.grey,
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(child: Text(title, style: SubtitleHelper.h10)),
                const Spacer(),
                const Icon(Icons.arrow_right)
              ],
            ),
          )));
}
