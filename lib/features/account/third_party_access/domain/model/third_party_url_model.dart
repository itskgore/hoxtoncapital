class ThirdPartyUrlParams {
  final String pluginCode;
  final String serviceCode;
  final bool? isUpdate;
  final Map<String, dynamic> data;

  ThirdPartyUrlParams(this.pluginCode, this.serviceCode, this.data,
      {this.isUpdate = false});
}
