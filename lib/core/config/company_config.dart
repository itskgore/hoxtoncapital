import 'package:wedge/core/config/app_icons.dart';
import 'package:wedge/core/contants/appIcon_json.dart';

import '../../dependency_injection.dart';
import '../contants/theme_json.dart';
import '../data_models/theme_model.dart';

void setCompany(Brand brand) {
  brand.setCompany();
}

abstract class Brand {
  setCompany();
}

class WedgeCapital extends Brand {
  @override
  setCompany() {
    locator<AppTheme>().fromJson(wedgeTheme);
    locator<AppIcons>().fromJson(wedgeIcons);
  }
}

class HoxtonCapital extends Brand {
  @override
  setCompany() {
    locator<AppTheme>().fromJson(hoxtonTheme);
    locator<AppIcons>().fromJson(hoxtonIcons);
  }
}
