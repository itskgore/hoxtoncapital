import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/theme_contants.dart';

var darkThemeScript = '''
(function (root, factory) {
    if (typeof define === 'function' && define.amd) {
        // AMD. Register as an anonymous module.
        define(['exports', 'echarts'], factory);
    } else if (typeof exports === 'object' && typeof exports.nodeName !== 'string') {
        // CommonJS
        factory(exports, require('echarts'));
    } else {
        // Browser globals
        factory({}, root.echarts);
    }
}(this, function (exports, echarts) {
    var log = function (msg) {
        if (typeof console !== 'undefined') {
            console && console.error && console.error(msg);
        }
    };
    if (!echarts) {
        log('ECharts is not Loaded');
        return;
    }
    var contrastColor = '#000000';
    var axisCommon = function () {
        return {
            axisLine: {
                lineStyle: {
                    color: contrastColor
                }
            },
            axisTick: {
                lineStyle: {
                    color: contrastColor
                }
            },
            
            splitLine: {
                lineStyle: {
                    type: 'line',
                    color: '#aaa'
                }
            },
            splitArea: {
                areaStyle: {
                    color: contrastColor
                }
            }
        };
    };

    var theme = {
        backgroundColor: "#${appThemeColors!.bg!.value.toRadixString(16).substring(2, 8)}",
        timeAxis: axisCommon(),
        logAxis: axisCommon(),
        valueAxis: axisCommon(),
        categoryAxis: axisCommon(),
    };
    echarts.registerTheme('dark', theme);
}));
''';

var apphemeScript = '''
(function (root, factory) {
    if (typeof define === 'function' && define.amd) {
        // AMD. Register as an anonymous module.
        define(['exports', 'echarts'], factory);
    } else if (typeof exports === 'object' && typeof exports.nodeName !== 'string') {
        // CommonJS
        factory(exports, require('echarts'));
    } else {
        // Browser globals
        factory({}, root.echarts);
    }
}(this, function (exports, echarts) {
    var log = function (msg) {
        if (typeof console !== 'undefined') {
            console && console.error && console.error(msg);
        }
    };
    if (!echarts) {
        log('ECharts is not Loaded');
        return;
    }
    var contrastColor = "#${darken(appThemeColors!.textLight!, .3).value.toRadixString(16).substring(2, 8)}";
    var axisCommon = function () {
        return {
            axisLine: {
                lineStyle: {
                    color: contrastColor
                }
            },
            axisTick: {
                lineStyle: {
                    color: contrastColor
                }
            },
            
            splitLine: {
                lineStyle: {
                    type: 'line',
                    color: '#aaa'
                }
            },
            splitArea: {
                areaStyle: {
                    color: contrastColor
                }
            }
        };
    };

    var theme = {
        backgroundColor: {
        type: 'linear',

        colorStops: [{
            offset: 0, color: '#${darken(appThemeColors!.gradient![1], .0).value.toRadixString(16).substring(2, 8)}' // color at 0%
        }, {
            offset: 1, color: '#${darken(appThemeColors!.gradient![0], .0).value.toRadixString(16).substring(2, 8)}' // color at 100%
        }],
      
      },
        timeAxis: axisCommon(),
        logAxis: axisCommon(),
        valueAxis: axisCommon(),
        categoryAxis: axisCommon(), 
    };
    echarts.registerTheme('dark', theme);
}));
''';
